//
//  UIKitUtilsTests.m
//  JXUtilsKitTests
//
//  Created by Barnett on 2021/3/9.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "JXUIKitUtils.h"

@interface UIKitUtilsTests : XCTestCase

@end

@implementation UIKitUtilsTests

- (void)setUp {

}

- (void)tearDown {
}

- (void)test_UIKitUtils {
    XCTAssertTrue(system_version_equal(@"14.4"));
    XCTAssertFalse(system_version_equal(@"1.1"));
    
    XCTAssertTrue(system_version_lessThan(@"14.5"));
    XCTAssertFalse(system_version_lessThan(@"1.1"));
    
    XCTAssertTrue(system_version_moreThan(@"14.3"));
    XCTAssertFalse(system_version_moreThan(@"14.5"));
    
    XCTAssertTrue(system_version_lessThanOrEqual(@"14.5"));
    XCTAssertTrue(system_version_lessThanOrEqual(@"14.4"));
    XCTAssertFalse(system_version_lessThanOrEqual(@"14.0"));
    
    XCTAssertTrue(system_version_moreThanOrEqual(@"14.3"));
    XCTAssertTrue(system_version_moreThanOrEqual(@"14.4"));
    XCTAssertFalse(system_version_moreThanOrEqual(@"14.5"));
    
    XCTAssertTrue(is_iPhoneX());
    XCTAssertFalse(is_iPhone5());
    
    NSLog(@"screen_width === %f",screen_width());
    NSLog(@"screen_height === %f",screen_height());
    NSLog(@"width === %f , height === %f",screen_bounds().size.width,screen_bounds().size.height);
    NSLog(@"statusBar_height === %f",statusBar_height());
    NSLog(@"bottomSafeArea_height === %f",bottomSafeArea_height());
    NSLog(@"screenWidth_scale === %f,screenHeight_scale === %f",screenWidth_scale(),screenHeight_scale());
}


@end
