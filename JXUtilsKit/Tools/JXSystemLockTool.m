//
//  JXSystemLockTool.m
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/9.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import "JXSystemLockTool.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>

static NSString *kFaceIDUsageKey = @"NSFaceIDUsageDescription";

@implementation JXSystemLockTool

- (JXSystemLockSupportType)lockSupportType
{
    JXSystemLockSupportType supportType = JXSystemLock_None;
    // 检测设备是否支持TouchID或者FaceID
    LAContext *LAContent = [[LAContext alloc] init];
    NSError *authError = nil;
    BOOL isCanEvaluatePolicy = [LAContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
    if (authError) {
        return supportType;
    } else {
        if (isCanEvaluatePolicy) {
            // 判断设备支持TouchID还是FaceID
            if (@available(iOS 11.0, *)) {
                switch (LAContent.biometryType) {
                    case LABiometryTypeTouchID:
                    {
                        supportType = JXSystemLock_TouchID;
                    }
                        break;
                    case LABiometryTypeFaceID:
                    {
                        supportType = JXSystemLock_FaceID;
                    }
                        break;
                    default:
                        break;
                    }
            } else {
                // 因为iPhoneX起始系统版本都已经是iOS11.0，所以iOS11.0系统版本下不需要再去判断是否支持faceID，直接走支持TouchID逻辑即可。
                supportType = JXSystemLock_TouchID;
            }
        } else { }
    }
    return supportType;
}

- (BOOL)passwordLockAvailable
{
    LAContext* LAContent = [[LAContext alloc] init];
    NSError *authError = nil;
    BOOL isCanEvaluatePolicy = [LAContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError];
    return isCanEvaluatePolicy;
}

- (void)showSystemBiometricsLockWithDescribe:(NSString *)describe success:(void(^)(void))successBlock fail:(void(^)(JXSystemLockFailState failType))failBlock
{
    if (![self infoPlistContain]) { return; }
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:describe reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                successBlock();
            }else if(error){
                failBlock([self getFailStateWith:error.code]);
            }
        }];
    } else {
        if (failBlock) {
            failBlock([self getFailStateWith:error.code]);
        }
    }
}

- (void)showSystemLockWithDescribe:(NSString *)describe fallbackTitle:(NSString *)fallbackTitle success:(void(^)(void))successBlock fail:(void(^)(JXSystemLockFailState failType))failBlock
{
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = fallbackTitle;
    NSError *error = nil;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:describe reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                successBlock();
            }else if(error){
                failBlock([self getFailStateWith:error.code]);
            }
        }];
    } else {
        if (failBlock) {
            failBlock([self getFailStateWith:error.code]);
        }
    }
}

#pragma mark - private

- (JXSystemLockFailState)getFailStateWith:(LAError)errorCode
{
    switch (errorCode) {
        case LAErrorAuthenticationFailed:
            return JXSystemLockStateFail;
            break;
        case LAErrorUserCancel:
            return JXSystemLockStateUserCancel;
            break;
        case LAErrorUserFallback:
            return JXSystemLockStateInputPassword;
            break;
        case LAErrorSystemCancel:
            return JXSystemLockStateSystemCancel;
            break;
        case LAErrorPasscodeNotSet:
            return JXSystemLockStatePasswordNotSet;
            break;
        case LAErrorBiometryNotAvailable:
            return JXSystemLockStateBiometryNotSet;
            break;
        case LAErrorBiometryNotEnrolled:
            return JXSystemLockStateBiometryNotEnrolled;
            break;
        case LAErrorBiometryLockout:
            return JXSystemLockStateBiometryLockout;
            break;
        case LAErrorAppCancel:
            return JXSystemLockStateAppCancel;
            break;
        case LAErrorInvalidContext:
            return JXSystemLockStateInvalidContext;
            break;
        default:
            return JXSystemLockStateNotSupport;
            break;
    }
}

- (BOOL)infoPlistContain
{
    NSString *content = kFaceIDUsageKey;
    NSString *message = @"info.plist文件缺少FaceID权限相关描述";

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    BOOL flag = false;
    if ([infoDictionary.allKeys containsObject:content]) {
        NSString *stringValue = [infoDictionary objectForKey:content];
        if (stringValue.length != 0) {
            flag = true;
        }
    }
    if (!flag) {
        [self showAlertWithTitle:@"提示" message:message confirm:@"确定" cancle:nil confirmBlock:nil cancleBlock:nil];
    }
    return flag;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmStr cancle:(NSString *)cancleStr confirmBlock:(void(^)(void))confirm cancleBlock:(void(^)(void))cancle
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
        [[self visibleViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

- (UIViewController *)visibleViewController
{
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [self getVisibleViewControllerFrom:rootViewController];
}

- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

#pragma mark - init
static JXSystemLockTool *sharedSingleton = nil;
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

@end
