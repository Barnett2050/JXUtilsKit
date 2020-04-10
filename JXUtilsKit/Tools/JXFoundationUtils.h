//
//  JXFoundationUtils.h
//  JXUtilsKit
//
//  Created by Barnett on 2020/4/9.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXFoundationUtils : NSObject

#pragma mark - 弧度角度参数转换

/// 弧度转角度
/// @param radians 弧度
float radians_to_degrees(float radians);

/// 角度转弧度
/// @param angle 角度
float degrees_to_radians(float angle);

#pragma mark - 数据验证
bool string_valid(NSString *value);

NSString* string_safe(NSString *value);

bool string_have(NSString *value,NSString* key);

bool dictionary_valid(NSDictionary *value);

bool array_valid(NSArray *value);

bool number_valid(NSNumber *value);

bool data_valid(NSData *value);

bool class_valid(id value,Class cls);

@end

NS_ASSUME_NONNULL_END
