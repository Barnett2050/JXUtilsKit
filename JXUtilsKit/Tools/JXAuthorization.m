//
//  JXAuthorization.m
//  BaseAndTools
//
//  Created by Barnett on 2020/4/10.
//  Copyright © 2020 edz. All rights reserved.
//

#import "JXAuthorization.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreBluetooth/CoreBluetooth.h>

static NSString *cameraUsageKey = @"NSCameraUsageDescription"; // 相机权限key
static NSString *audioUsageKey = @"NSMicrophoneUsageDescription"; // 麦克风权限key
static NSString *photoLibraryKey = @"NSPhotoLibraryUsageDescription"; // 相册权限key
static NSString *contactsKey = @"NSContactsUsageDescription"; // 通讯录权限key
static NSString *remindersKey = @"NSRemindersUsageDescription"; // 提醒权限
static NSString *calendarsKey = @"NSCalendarsUsageDescription"; // 日历权限
static NSString *appleMusicKey = @"NSAppleMusicUsageDescription"; // 音乐媒体权限

@interface JXAuthorization ()

@end

@implementation JXAuthorization

static JXAuthorization *sharedSingleton = nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(sharedSingleton == nil) {
            sharedSingleton = [super allocWithZone:zone];
        }
    });
    return sharedSingleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(sharedSingleton == nil)
        {
            sharedSingleton = [[self alloc] init];
        }
    });
    return sharedSingleton;
}
- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

#pragma mark - public
+ (void)gotoApplicationSettings
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
    });
}

+ (void)jx_requestCameraAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    if (![JXAuthorization infoPlistIsContain:cameraUsageKey]) {
        return;
    }
    if (![JXAuthorization cameraIsAvailable]) {
        failBlock(AuthorizationFailTypeNoneCamera,nil);
        return;
    }
    if (![JXAuthorization rearCameraIsAvailable]) {
        failBlock(AuthorizationFailTypeRearUnavailable,nil);
        return;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                if (successBlock) {
                    successBlock();
                }
            }else {
                if (failBlock) {
                    failBlock(AuthorizationFailTypeFirstNoneAuthorization,nil);
                }
            }
        }];
    }else
    {
        [JXAuthorization jx_requestAuthorizationWith:status success:successBlock fail:failBlock];
    }
}
+ (BOOL)rearCameraIsAvailable
{
    BOOL result = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    return result;
}
+ (BOOL)frontCameraIsAvailable
{
    BOOL result = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    return result;
}

+ (void)jx_requestAudioAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    if (![JXAuthorization infoPlistIsContain:audioUsageKey]) {
        return;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                if (failBlock) {
                    failBlock(AuthorizationFailTypeFirstNoneAuthorization,nil);
                }
            }
        }];
    } else {
        [JXAuthorization jx_requestAuthorizationWith:status success:successBlock fail:failBlock];
    }
}

+ (void)jx_requestPhotoLibrayAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    if (![JXAuthorization infoPlistIsContain:photoLibraryKey]) {
        return;
    }
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [JXAuthorization jx_requestAuthorizationWith:status success:successBlock fail:failBlock];
        }];
    } else {
        [JXAuthorization jx_requestAuthorizationWith:status success:successBlock fail:failBlock];
    }
}

+ (void)jx_requestAddressBookAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    if (![JXAuthorization infoPlistIsContain:contactsKey]) {
        return;
    }
    CNContactStore * contactStore = [[CNContactStore alloc] init];
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                if (failBlock) {
                    failBlock(AuthorizationFailTypeFirstNoneAuthorization,error);
                }
            }
        }];
    } else {
        [JXAuthorization jx_requestAuthorizationWith:status success:successBlock fail:failBlock];
    }
}
+ (void)jx_requestEntityAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    if (![JXAuthorization infoPlistIsContain:calendarsKey]) {
        return;
    }
    [JXAuthorization jx_requestEntityType:EKEntityTypeEvent success:successBlock fail:failBlock];
}
+ (void)jx_requestReminderAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    if (![JXAuthorization infoPlistIsContain:remindersKey]) {
        return;
    }
    [JXAuthorization jx_requestEntityType:EKEntityTypeReminder success:successBlock fail:failBlock];
}
+ (void)jx_requestEntityType:(EKEntityType)type success:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];
    if (status == EKAuthorizationStatusNotDetermined) {
        [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                if (failBlock) {
                    failBlock(AuthorizationFailTypeFirstNoneAuthorization,error);
                }
            }
        }];
    } else {
        [JXAuthorization jx_requestAuthorizationWith:status success:successBlock fail:failBlock];
    }
}
+ (void)jx_requestMediaAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    // 请求媒体资料库权限
    if (![JXAuthorization infoPlistIsContain:appleMusicKey]) {
        return;
    }
    MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
    if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            [JXAuthorization jx_requestAuthorizationWith:status success:successBlock fail:failBlock];
        }];
    } else {
        [JXAuthorization jx_requestAuthorizationWith:status success:successBlock fail:failBlock];
    }
}

#pragma mark - private method
+ (void)jx_requestAuthorizationWith:(NSInteger)type success:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    switch (type) {
        case 1:
        {
            if (failBlock) {
                failBlock(AuthorizationFailTypeRestricted,nil);
            }
        }
            break;
        case 2:
        {
            if (failBlock) {
                failBlock(AuthorizationFailTypeDenied,nil);
            }
        }
            break;
        case 3:
        {
            if (successBlock) {
                successBlock();
            }
        }
            break;
        default:
            break;
    }
}
// 判断设备是否有摄像头
+ (BOOL)cameraIsAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (UIViewController *)jx_visibleViewController
{
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [JXAuthorization getVisibleViewControllerFrom:rootViewController];
}
+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [JXAuthorization getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [JXAuthorization getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [JXAuthorization getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
    
}
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmStr cancle:(NSString *)cancleStr confirmBlock:(void(^)(void))confirm cancleBlock:(void(^)(void))cancle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        if (confirmStr != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:confirmStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (confirm) {
                    confirm();
                }
            }]];
        }
        if (cancleStr != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:cancleStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (cancle) {
                    cancle();
                }
            }]];
        }
        [[JXAuthorization jx_visibleViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

+ (BOOL)infoPlistIsContain:(NSString *)content
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    BOOL flag = false;
    if ([infoDictionary.allKeys containsObject:content]) {
        NSString *stringValue = [infoDictionary objectForKey:content];
        if (stringValue.length != 0) {
            flag = true;
        }
    }
    if (!flag) {
        NSString *message;
        if ([content isEqualToString:cameraUsageKey]) {
            message = @"info.plist文件缺少相机权限相关描述";
        }else if ([content isEqualToString:audioUsageKey]) {
            message = @"info.plist文件缺少麦克风权限相关描述";
        }else if ([content isEqualToString:photoLibraryKey]) {
            message = @"info.plist文件缺少相册权限相关描述";
        }else if ([content isEqualToString:contactsKey]) {
            message = @"info.plist文件缺少通讯录权限相关描述";
        }else if ([content isEqualToString:calendarsKey]) {
            message = @"info.plist文件缺少日历权限相关描述";
        }else if ([content isEqualToString:remindersKey]) {
            message = @"info.plist文件缺少提醒权限相关描述";
        }else if ([content isEqualToString:appleMusicKey]) {
            message = @"info.plist文件缺少音乐媒体权限相关描述";
        }
        [JXAuthorization showAlertWithTitle:nil message:message confirm:@"确定" cancle:nil confirmBlock:nil cancleBlock:nil];
    }
    return flag;
}
@end
