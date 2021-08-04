//
//  JXAuthorizationTool.h
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/3.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JXAuthorizationRequestCamera = 0,   // 相机
    JXAuthorizationRequestPhotoLibraryAddOnly API_AVAILABLE(ios(14)), // 相册仅允许添加照片
    JXAuthorizationRequestPhotoLibraryReadWrite, // 相册允许访问照片，limitedLevel 必须为 readWrite
    JXAuthorizationRequestAudio, // 麦克风
    JXAuthorizationRequestMediaLibrary, // 获取音乐媒体权限，iOS 9.3之后
    JXAuthorizationRequestContacts, // 通讯录
    JXAuthorizationRequestCalendars, // 日历
    JXAuthorizationRequestReminder, // 提醒事项,添加提醒事项需要打开iCloud里面的日历,日历权限和提醒权限必须同时申请.
    JXAuthorizationRequestSpeechRecognition, // 语音识别
} JXAuthorizationRequestType;

typedef enum : NSUInteger {
    JXAuthorizationStatusAuthorized = 0, // 完全的权限
    JXAuthorizationStatusLimited API_AVAILABLE(ios(14)), // 有限的权限
} JXAuthorizationSuccessType;

typedef enum : NSUInteger {
    JXAuthorizationStatusNotDetermined = 0, // 用户第一次请求权限未授权
    JXAuthorizationStatusRestricted    = 1, // 家长控制之类的活动限制
    JXAuthorizationStatusDenied        = 2, // 用户明确拒绝
    JXAuthorizationFailNoneCamera      = 3, // 无摄像头
    JXAuthorizationFailRearUnavailable = 4, // 后方摄像头不可用
} JXAuthorizationFailType;

// 权限获取成功
typedef void(^requestAuthorizationSuccess)(JXAuthorizationSuccessType successType);
// 权限获取失败
typedef void(^requestAuthorizationFail)(JXAuthorizationFailType failType,NSError * _Nullable error);

@interface JXAuthorizationTool : NSObject

/// 跳转系统设置
+ (void)pushToApplicationSettings;
/// 后面的摄像头是否可用
+ (BOOL)rearCameraIsAvailable;
/// 前面的摄像头是否可用
+ (BOOL)frontCameraIsAvailable;

/// 请求系统相关授权
/// @param requestType 授权类型
/// @param success 成功回调
/// @param fail 失败回调
+ (void)requestAuthorizationType:(JXAuthorizationRequestType)requestType success:(requestAuthorizationSuccess)success fail:(requestAuthorizationFail)fail;

@end

NS_ASSUME_NONNULL_END
