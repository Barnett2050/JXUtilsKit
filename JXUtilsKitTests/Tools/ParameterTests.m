//
//  ParameterTests.m
//  JXUtilsKitTests
//
//  Created by Barnett on 2021/3/10.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "JXParameterTool.h"

@interface ParameterTests : XCTestCase

@end

@implementation ParameterTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_Parameter {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Parameter"];
    [JXParameterTool checkAndMonitorBatteryStatusAndLevel:^(UIDeviceBatteryState state) {
        switch (state) {
            case UIDeviceBatteryStateUnplugged:
                NSLog(@"放电");
                break;
            case UIDeviceBatteryStateCharging:
                NSLog(@"充电");
                break;
            case UIDeviceBatteryStateFull:
                NSLog(@"充满电");
                break;
            case UIDeviceBatteryStateUnknown:
                NSLog(@"未知");
                break;
            default:
                break;
        }
    } batteryLevel:^(float batteryLevel) {
        NSLog(@"=== %f",batteryLevel);
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}


@end
