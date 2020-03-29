//
//  FoundationMacroHeader.h
//  BaseAndTools
//
//  Created by edz on 2019/10/17.
//  Copyright © 2019 edz. All rights reserved.
//

#ifndef FoundationMacroHeader_h
#define FoundationMacroHeader_h

/* ----------------------------------------  参数转换  ---------------------------------------*/
/**
 弧度转角度

 @param radians 弧度
 @return 角度
 */
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
/**
 角度转弧度

 @param angle 角度
 @return 弧度
 */
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
/* ----------------------------------------  参数转换  ---------------------------------------*/


/* ----------------------------------------  快速声明  ---------------------------------------*/

//property属性快速声明
#define Property_String(s) @property(nonatomic,copy)NSString *s

#define Property_NSInteger(s) @property(nonatomic,assign)NSInteger s

#define Property_Float(s) @property(nonatomic,assign)float s

#define Property_Double(s) @property(nonatomic,assign)double s

#define Property_NSDictionary(s) @property(nonatomic,strong)NSDictionary *s

#define Property_NSMutableDictionary(s) @property(nonatomic,strong)NSMutableDictionary *s

#define Property_NSArray(s) @property(nonatomic,strong)NSArray *s

#define Property_NSMutableArray(s) @property(nonatomic,strong)NSMutableArray *s

// 拼接字符串
#define NSString_Format(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

// 快速生成UIImage对象
#define IMAGE_NAMED(name)[UIImage imageNamed:name]

//强弱引用
#define JXWeak_Object(type)__weak typeof(type)weak##type = type;
#define JXStrong_Object(type)__strong typeof(type)type = weak##type;

//随机数 [from,to] //包含from 和 to
#define kRandomInt(from,to) (int)(from + (arc4random() % (to - from + 1)))

/* ----------------------------------------  快速声明  ---------------------------------------*/


/* ----------------------------------------  数据验证  ---------------------------------------*/

#define String_Valid(value) (value!=nil && value.length != 0 &&[value isKindOfClass:[NSString class]]&& ![value isEqualToString:@""])

#define String_Safe(value) (String_Valid(value) ? value : @"")

#define String_Has(value,key) ([value rangeOfString:key].location!=NSNotFound)

#define Dictionary_Valid(value) (value!=nil && ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]) && value.allKeys.count > 0)

#define Array_Valid(value) (value!=nil &&([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSMutableArray class]]) && [value count]>0)

#define Number_Valid(value) (value!=nil &&[value isKindOfClass:[NSNumber class]])

#define Data_Valid(value) (value!=nil &&[value isKindOfClass:[NSData class]])

#define Class_Valid(value,cls) (value!=nil &&[value isKindOfClass:[cls class]])

/* ----------------------------------------  数据验证  ---------------------------------------*/



/* ----------------------------------------  其他  ---------------------------------------*/

// 获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTimeNSLog (@"Time: %f",CFAbsoluteTimeGetCurrent()- start)

/* ----------------------------------------  其他  ---------------------------------------*/


/* ----------------------------------------  日志打印  ---------------------------------------*/
//DEBUG模式下打印日志,当前行
#ifdef DEBUG

#define DLog(fmt,...) NSLog((@"%s[Line %d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);
#define GLLog(...) printf("%s %s [%d]: %s\n",[[NSString timeString] UTF8String],[NSStringFromClass([self class]) UTF8String],__LINE__,[[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else

#define DLog(...)
#define GLLog(...)

#endif
/* ----------------------------------------  日志打印  ---------------------------------------*/


#endif /* FoundationMacroHeader_h */
