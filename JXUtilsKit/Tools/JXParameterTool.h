//
//  JXParameterTool.h
//  JXUtilsKit
//
//  Created by Barnett on 2020/4/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^batteryStateBlock)(UIDeviceBatteryState state);
typedef void(^batteryLevelBlock)(float batteryLevel);

NS_ASSUME_NONNULL_BEGIN
// 参数获取工具，需要使用到单例
@interface JXParameterTool : NSObject

/// 获取电池状态和电量
/// @param batteryStateBlock 状态回调
/// @param batteryLevelBlock 电量回调
+ (void)checkAndMonitorBatteryStatusAndLevel:(batteryStateBlock)batteryStateBlock batteryLevel:(batteryLevelBlock)batteryLevelBlock;

@end

NS_ASSUME_NONNULL_END
