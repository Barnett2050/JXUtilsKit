//
//  FoundationUtilsTests.m
//  JXUtilsKitTests
//
//  Created by Barnett on 2021/3/10.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "JXFoundationUtils.h"

@interface FoundationUtilsTests : XCTestCase

@end

@implementation FoundationUtilsTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)test_FoundationUtils {
    NSLog(@"%f",radians_to_degrees(3));
    NSLog(@"%f",degrees_to_radians(150));
}

@end
