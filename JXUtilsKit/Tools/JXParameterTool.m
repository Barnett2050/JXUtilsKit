//
//  JXParameterTool.m
//  JXUtilsKit
//
//  Created by Barnett on 2020/4/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import "JXParameterTool.h"

@interface JXParameterTool ()

@property (nonatomic, assign) batteryStateBlock stateBlock;
@property (nonatomic, assign) batteryLevelBlock levelBLock;

@end

@implementation JXParameterTool

static id sharedParameterTool = nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(sharedParameterTool == nil)
        {
            sharedParameterTool = [super allocWithZone:zone];
        }
    });
    return sharedParameterTool;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
+ (instancetype)sharedSingleInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(sharedParameterTool == nil)
        {
            sharedParameterTool = [[self alloc] init];
        }
    });
    return sharedParameterTool;
}
- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

+ (void)checkAndMonitorBatteryStatusAndLevel:(batteryStateBlock)batteryStateBlock batteryLevel:(batteryLevelBlock)batteryLevelBlock
{
    [JXParameterTool sharedSingleInstance].stateBlock = batteryStateBlock;
    [JXParameterTool sharedSingleInstance].levelBLock = batteryLevelBlock;
    UIDevice * device = [UIDevice currentDevice];
    //是否允许监测电池,要想获取电池电量信息和监控电池电量 必须允许
    device.batteryMonitoringEnabled = true;
    
    if (batteryStateBlock) {
        batteryStateBlock(device.batteryState);
    }
    if (batteryLevelBlock) {
        batteryLevelBlock(device.batteryLevel);
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:[JXParameterTool sharedSingleInstance] selector:@selector(didChangeBatteryState:) name:UIDeviceBatteryStateDidChangeNotification object:device];
    [[NSNotificationCenter defaultCenter] addObserver:[JXParameterTool sharedSingleInstance] selector:@selector(didChangeBatteryLevel:) name:UIDeviceBatteryLevelDidChangeNotification object:device];
}

#pragma mark - 监听
- (void)didChangeBatteryState:(NSNotification *)noti
{
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    if ([JXParameterTool sharedSingleInstance].stateBlock) {
        [JXParameterTool sharedSingleInstance].stateBlock(myDevice.batteryState);
    }
}
- (void)didChangeBatteryLevel:(NSNotification *)noti
{
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    if ([JXParameterTool sharedSingleInstance].levelBLock) {
        [JXParameterTool sharedSingleInstance].levelBLock(myDevice.batteryLevel);
    }
}

@end
