//
//  JXFoundationUtils.m
//  JXUtilsKit
//
//  Created by Barnett on 2020/4/9.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import "JXFoundationUtils.h"
@implementation JXFoundationUtils

float radians_to_degrees(float radians) {
    return ((radians) * (180.0 / M_PI));
}

float degrees_to_radians(float angle) {
    return ((angle) / 180.0 * M_PI);
}

bool string_valid(NSString *value) {
    bool flag = (value != nil && value.length != 0 &&[value isKindOfClass:[NSString class]]&& ![value isEqualToString:@""]);
    return flag;
}

NSString* string_safe(NSString *value) {
    return (string_valid(value) ? value : @"");
}

bool string_have(NSString *value,NSString *key) {
    bool flag = string_valid(value);
    if (flag) {
        flag = ([value rangeOfString:key].location != NSNotFound);
    }
    return flag;
}

bool dictionary_valid(NSDictionary *value) {
    bool flag = (value != nil && [value isKindOfClass:[NSDictionary class]] && value.allKeys.count > 0);
    return flag;
}

bool array_valid(NSArray *value) {
    bool flag = (value != nil && [value isKindOfClass:[NSArray class]] && [value count] > 0);
    return flag;
}

bool number_valid(NSNumber *value) {
    bool flag = (value != nil && [value isKindOfClass:[NSNumber class]]);
    return flag;
}

bool data_valid(NSData *value) {
    bool flag = (value != nil &&[value isKindOfClass:[NSData class]]);
    return flag;
}

bool class_valid(id value,Class cls) {
    bool flag = (value != nil &&[value isKindOfClass:[cls class]]);
    return flag;
}

@end
