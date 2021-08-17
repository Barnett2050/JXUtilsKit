//
//  JXSystemLockTool.h
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/9.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 支持的锁定方式
typedef NS_ENUM(NSInteger ,JXSystemLockSupportType) {
    JXSystemLock_None = 0, // 既不支持指纹，也不支持脸部识别
    JXSystemLock_TouchID,  // 指纹解锁
    JXSystemLock_FaceID    // 脸部识别
};

typedef NS_ENUM(NSInteger ,JXSystemLockFailState) {
    JXSystemLockStateNotSupport = 0,    // 当前设备不支持TouchID/FaceID
    JXSystemLockStateFail,              // TouchID/FaceID 验证失败
    JXSystemLockStateUserCancel,        // TouchID/FaceID 被用户手动取消
    JXSystemLockStateInputPassword,     // 用户不使用TouchID/FaceID,选择手动输入密码
    JXSystemLockStateSystemCancel,      // TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)
    JXSystemLockStatePasswordNotSet,    // TouchID/FaceID 无法启动,因为用户没有设置密码
    JXSystemLockStateBiometryNotSet API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)),                                         // TouchID/FaceID 无法启动,因为用户没有同意开启TouchID/FaceID
    JXSystemLockStateBiometryNotEnrolled API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)),                                    // TouchID/FaceID 无效,因为用户没有设置生物识别开启
    JXSystemLockStateBiometryLockout,   // TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)
    JXSystemLockStateAppCancel,         // 当前软件被挂起并取消了授权 (如App进入了后台等)
    JXSystemLockStateInvalidContext,    // 当前软件被挂起并取消了授权 (LAContext对象无效)
};

@interface JXSystemLockTool : NSObject

@property (nonatomic, assign, readonly) JXSystemLockSupportType lockSupportType; // 锁定类型
@property (nonatomic, assign, readonly) BOOL passwordLockAvailable; // 密码解锁是否可用
/// 绝对单例
+ (instancetype)sharedInstance;

/// 显示生物识别，只有face id 和 touch id,即LAPolicyDeviceOwnerAuthenticationWithBiometrics模式
/// @param describe 描述
/// @param successBlock 成功回调
/// @param failBlock 失败回调
- (void)showSystemBiometricsLockWithDescribe:(NSString *)describe success:(void(^)(void))successBlock fail:(void(^)(JXSystemLockFailState failType))failBlock;


/// 显示生物识别和密码输入，即LAPolicyDeviceOwnerAuthentication模式
/// @param describe 描述
/// @param fallbackTitle 不设置空值，则AlertView弹窗默认会有“输入密码”的选项,点击可以唤起输入手机密码页面
/// @param successBlock 成功回调
/// @param failBlock 失败回调
- (void)showSystemLockWithDescribe:(NSString *)describe fallbackTitle:(NSString *)fallbackTitle success:(void(^)(void))successBlock fail:(void(^)(JXSystemLockFailState failType))failBlock;

@end

NS_ASSUME_NONNULL_END
