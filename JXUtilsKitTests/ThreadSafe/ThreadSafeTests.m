//
//  ThreadSafeTests.m
//  JXUtilsKitTests
//
//  Created by Barnett on 2021/3/10.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "JXSafeMutableArray.h"
#import "JXSafeMutableDictionary.h"

@interface ThreadSafeTests : XCTestCase

@end

@implementation ThreadSafeTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)test_ThreadSafeArray {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Parameter"];
    
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    for (int i = 0; i < 100; i ++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [mutableArray addObject:[NSNumber numberWithInt:i]];
//        });
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSNumber *value = [mutableArray objectAtIndex:i];
//        });
//    }
    
    JXSafeMutableArray *mutableArray = [JXSafeMutableArray array];
    for (int i = 0; i < 100; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [mutableArray addObject:[NSNumber numberWithInt:i]];
            
            NSNumber *value = [mutableArray objectAtIndex:i];
        });
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
        NSLog(@"%@",mutableArray);
    });
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)test_ThreadSafeDictionary{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Parameter"];
    
//    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
//    for (int i = 0; i < 100; i++) {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [mutableDictionary setObject:[NSNumber numberWithInt:i] forKey:[NSString stringWithFormat:@"%d",i]];
//        });
//    }
    
    JXSafeMutableDictionary *mutableDictionary = [JXSafeMutableDictionary dictionary];
    for (int i = 0; i < 100; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [mutableDictionary setObject:[NSNumber numberWithInt:i] forKey:[NSString stringWithFormat:@"%d==",i]];
        });
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
        NSLog(@"%@",mutableDictionary);
    });
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
