//
//  JXHealthTool.h
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/10.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JXHealthToolStatus_NotAvailable = 0, // 不可用
    JXHealthToolStatus_Error, // 错误
    JXHealthToolStatus_Success, // 成功
    JXHealthToolStatus_ShareDenied, // 写入有拒绝,部分或全部
} JXHealthToolStatus;

@interface JXHealthTool : NSObject

/// 绝对单例
+ (instancetype)sharedInstance;

/// 申请health权限 authorizationStatusForType 只能获取写入的权限，无法获取读取的权限，受到苹果隐私权限的控制而无法读取
/// @param typesToShare 数据写入类型
/// @param typesToRead 数据读取类型
/// @param completion 回调
- (void)requestHealthAuthorizationWithShareTypes:(nullable NSSet<HKSampleType *> *)typesToShare
                                       readTypes:(nullable NSSet<HKObjectType *> *)typesToRead
                                      completion:(void(^)(JXHealthToolStatus status, NSSet *deniedShareSet,NSError *error))completion;
/// 获取当天健康数据 - 步数
- (void)getStepCount:(void (^)(double stepCount, NSError *error))queryResultBlock;

@end

NS_ASSUME_NONNULL_END
