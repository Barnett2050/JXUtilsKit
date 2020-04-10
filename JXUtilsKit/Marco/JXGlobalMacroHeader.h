//
//  JXGlobalMacroHeader.h
//  JXUtilsKit
//
//  Created by Barnett on 2020/4/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

#ifndef JXGlobalMacroHeader_h
#define JXGlobalMacroHeader_h

/* ----------------------------------------  快速声明  ---------------------------------------*/

// 拼接字符串
#define NSString_Format(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//强弱引用
#define JXWeak_Object(type)__weak typeof(type)weak##type = type;
#define JXStrong_Object(type)__strong typeof(type)type = weak##type;

// 获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTimeLog (@"Time: %f",CFAbsoluteTimeGetCurrent()- start)

/* ----------------------------------------  快速声明  ---------------------------------------*/


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

#endif /* JXGlobalMacroHeader_h */
