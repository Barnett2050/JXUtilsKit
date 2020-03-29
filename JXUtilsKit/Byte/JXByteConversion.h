//
//  JXByteConversion.h
//  JXUtilsKit
//
//  Created by Barnett on 2020/3/29.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXByteConversion : NSObject
/**
 将字节型的data转换为内容是字节的字符串
 */
+ (NSString *)jx_byteArrayStringFromData:(NSData *)value;

/**
 将内容是字节的字符串转换为data
 */
+ (NSData *)jx_hexStringToByteArrayData:(NSString*)hexStr;

/**
 取得一个大于256小于65536数字的高位字节
 */
+ (Byte)jx_getHighByteFromArg:(int)arg;

/**
 取得一个数字的低位字节
 */
+ (Byte)jx_getLowByteFromArg:(int)arg;

/**
 将字节转为字符串
 */
+ (NSString *)jx_byteToHexStr:(Byte)b;

/**
 将十六进制字符串转为带符号整型
 */
+ (int)jx_hexStringChangeToIntWithHexStr:(NSString *)hexStr;
@end

NS_ASSUME_NONNULL_END
