//
//  JXAuthorizationTool.m
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/3.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import "JXAuthorizationTool.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
#import <Speech/Speech.h>

static NSString *kCameraUsageKey = @"NSCameraUsageDescription"; // 相机权限key
static NSString *kAudioUsageKey = @"NSMicrophoneUsageDescription"; // 麦克风权限key
static NSString *kAppleMusicKey = @"NSAppleMusicUsageDescription"; // 音乐媒体权限key
static NSString *kContactsKey = @"NSContactsUsageDescription"; // 通讯录权限key
static NSString *kCalendarsKey = @"NSCalendarsUsageDescription"; // 日历权限key
static NSString *kRemindersKey = @"NSRemindersUsageDescription"; // 提醒权限key
static NSString *kSpeechRecognitionKey = @"NSSpeechRecognitionUsageDescription"; // 语音识别权限key

@interface JXAuthorizationTool ()

@end

@implementation JXAuthorizationTool

+ (void)pushToApplicationSettings
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
    });
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

+ (void)requestAuthorizationType:(JXAuthorizationRequestType)requestType success:(requestAuthorizationSuccess)success fail:(requestAuthorizationFail)fail
{
    if (![self infoPlistContainWith:requestType]) { return; }
    switch (requestType) {
        case JXAuthorizationRequestCamera:
            [self requestCameraAuthorizationSuccess:success fail:fail];
            break;
        case JXAuthorizationRequestAudio:
            [self requestAudioAuthorizationSuccess:success fail:fail];
            break;
        case JXAuthorizationRequestMediaLibrary:
            [self requestMediaAuthorizationSuccess:success fail:fail];
            break;
        case JXAuthorizationRequestContacts:
            [self requestContactsAuthorizationSuccess:success fail:fail];
            break;
        case JXAuthorizationRequestCalendars:
            [self requestEntityType:EKEntityTypeEvent success:success fail:fail];
            break;
        case JXAuthorizationRequestReminder:
            [self requestEntityType:EKEntityTypeReminder success:success fail:fail];
            break;
        case JXAuthorizationRequestSpeechRecognition:
            [self requestSpeechRecognitionAuthorizationSuccess:success fail:fail];
            break;
        default:
            break;
    }
}

+ (void)requestCameraAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                if (successBlock) {
                    successBlock();
                }
            }else {
                if (failBlock) {
                    failBlock(JXAuthorizationStatusDenied,nil);
                }
            }
        }];
    }else
    {
        [self requestAuthorizationResultWith:status success:successBlock fail:failBlock];
    }
}

+ (void)requestAudioAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                if (failBlock) {
                    failBlock(JXAuthorizationStatusDenied,nil);
                }
            }
        }];
    } else {
        [self requestAuthorizationResultWith:status success:successBlock fail:failBlock];
    }
}

+ (void)requestMediaAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
    if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            switch (status) {
                case 1:
                    if (failBlock) { failBlock(JXAuthorizationStatusDenied,nil); }
                    break;
                case 2:
                    if (failBlock) { failBlock(JXAuthorizationStatusRestricted,nil); }
                    break;
                case 3:
                    if (successBlock) { successBlock(); }
                    break;
                default:
                    break;
            }
        }];
    } else {
        switch (status) {
            case 1:
                if (failBlock) { failBlock(JXAuthorizationStatusDenied,nil); }
                break;
            case 2:
                if (failBlock) { failBlock(JXAuthorizationStatusRestricted,nil); }
                break;
            case 3:
                if (successBlock) { successBlock(); }
                break;
            default:
                break;
        }
    }
}

+ (void)requestContactsAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore * contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                if (failBlock) {
                    failBlock(JXAuthorizationStatusDenied,error);
                }
            }
        }];
    } else {
        [self requestAuthorizationResultWith:status success:successBlock fail:failBlock];
    }
}

+ (void)requestEntityType:(EKEntityType)type success:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];
    if (status == EKAuthorizationStatusNotDetermined) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                if (successBlock) {
                    successBlock();
                }
            } else {
                if (failBlock) {
                    failBlock(JXAuthorizationStatusDenied,error);
                }
            }
        }];
    } else {
        [self requestAuthorizationResultWith:status success:successBlock fail:failBlock];
    }
}
+ (void)requestSpeechRecognitionAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    if (status == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            switch (status) {
                case 1:
                    if (failBlock) { failBlock(JXAuthorizationStatusDenied,nil); }
                    break;
                case 2:
                    if (failBlock) { failBlock(JXAuthorizationStatusRestricted,nil); }
                    break;
                case 3:
                    if (successBlock) { successBlock(); }
                    break;
                default:
                    break;
            }
        }];
    } else {
        switch (status) {
            case 1:
                if (failBlock) { failBlock(JXAuthorizationStatusDenied,nil); }
                break;
            case 2:
                if (failBlock) { failBlock(JXAuthorizationStatusRestricted,nil); }
                break;
            case 3:
                if (successBlock) { successBlock(); }
                break;
            default:
                break;
        }
    }
}

#pragma mark - init

static JXAuthorizationTool *sharedSingleton = nil;
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
        if(sharedSingleton == nil) {
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

#pragma mark - private
+ (void)requestAuthorizationResultWith:(NSInteger)status success:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock
{
    switch (status) {
        case 1:
            if (failBlock) { failBlock(JXAuthorizationStatusRestricted,nil); }
            break;
        case 2:
            if (failBlock) { failBlock(JXAuthorizationStatusDenied,nil); }
            break;
        case 3:
            if (successBlock) { successBlock(); }
            break;
        default:
            break;
    }
}

+ (BOOL)infoPlistContainWith:(JXAuthorizationRequestType)requestType
{
    NSString *content;
    NSString *message;
    switch (requestType) {
        case JXAuthorizationRequestCamera:
            content = kCameraUsageKey;
            message = @"info.plist文件缺少相机权限相关描述";
            break;
        case JXAuthorizationRequestAudio:
            content = kAudioUsageKey;
            message = @"info.plist文件缺少麦克风权限相关描述";
            break;
        case JXAuthorizationRequestMediaLibrary:
            content = kAppleMusicKey;
            message = @"info.plist文件缺少音乐媒体权限相关描述";
            break;
        case JXAuthorizationRequestContacts:
            content = kContactsKey;
            message = @"info.plist文件缺少通讯录权限相关描述";
            break;
        case JXAuthorizationRequestCalendars:
            content = kCalendarsKey;
            message = @"info.plist文件缺少日历权限相关描述";
            break;
        case JXAuthorizationRequestReminder:
            content = kRemindersKey;
            message = @"info.plist文件缺少提醒事项权限相关描述";
            break;
        case JXAuthorizationRequestSpeechRecognition:
            content = kSpeechRecognitionKey;
            message = @"info.plist文件缺少语音识别权限相关描述";
            break;
        default:
            break;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    BOOL flag = false;
    if ([infoDictionary.allKeys containsObject:content]) {
        NSString *stringValue = [infoDictionary objectForKey:content];
        if (stringValue.length != 0) {
            flag = true;
        }
    }
    if (!flag) {
        [JXAuthorizationTool showAlertWithTitle:@"提示" message:message confirm:@"确定" cancle:nil confirmBlock:nil cancleBlock:nil];
    }
    return flag;
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
        [[JXAuthorizationTool visibleViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

+ (UIViewController *)visibleViewController
{
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [JXAuthorizationTool getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [JXAuthorizationTool getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [JXAuthorizationTool getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [JXAuthorizationTool getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end
