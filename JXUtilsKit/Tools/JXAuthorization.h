//
//  JXAuthorization.h
//  BaseAndTools
//
//  Created by Barnett on 2020/4/10.
//  Copyright © 2020 edz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    AuthorizationFailTypeNoneCamera, // 无摄像头
    AuthorizationFailTypeRearUnavailable, // 后方摄像头不可用
    AuthorizationFailTypeFirstNoneAuthorization, // 用户第一次请求权限未授权
    AuthorizationFailTypeRestricted, // 家长控制之类的活动限制
    AuthorizationFailTypeDenied // 用户明确拒绝
} AuthorizationFailType;

typedef void(^requestAuthorizationSuccess)(void); // 权限获取成功
typedef void(^requestAuthorizationFail)(AuthorizationFailType type,NSError * _Nullable error); // 日历事件和提醒权限获取失败

NS_ASSUME_NONNULL_BEGIN

@interface JXAuthorization : NSObject

/// 跳转权限设置
+ (void)gotoApplicationSettings;

/// 获取照相机权限
+ (void)jx_requestCameraAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock;
// 后面的摄像头是否可用
+ (BOOL)rearCameraIsAvailable;
// 前面的摄像头是否可用
+ (BOOL)frontCameraIsAvailable;

/// 获取麦克风权限
+ (void)jx_requestAudioAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock;

/// 获取相册权限 iOS 8.0之后
+ (void)jx_requestPhotoLibrayAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock;

/// 获取日历事件权限
+ (void)jx_requestEntityAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock;
/// 获取提醒事项权限，需要注意:添加提醒事项需要打开iCloud里面的日历,日历权限和提醒权限必须同时申请
+ (void)jx_requestReminderAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock;

/// 获取媒体权限，iOS 9.3之后
+ (void)jx_requestMediaAuthorizationSuccess:(requestAuthorizationSuccess)successBlock fail:(requestAuthorizationFail)failBlock;

@end

NS_ASSUME_NONNULL_END
