//
//  JXByteConversion.m
//  JXUtilsKit
//
//  Created by Barnett on 2020/3/29.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import "JXByteConversion.h"

#define C2I(c) ((c >= '0' && c<='9') ? (c-'0') : ((c >= 'a' && c <= 'z') ? (c - 'a' + 10): ((c >= 'A' && c <= 'Z')?(c - 'A' + 10):(-1))))

@implementation JXByteConversion

#pragma mark - 将字节型的data转换为内容是字节的字符串
+ (NSString *)jx_byteArrayStringFromData:(NSData *)value
{
    Byte *data = (Byte*)[value bytes];
    NSString *ret = @"";
    for(int i = 0;i < [value length]; i++){
        NSString *hexStr = @"";
        NSString *stmp =  [NSString stringWithFormat:@"%x",data[i]&0xff];
        if([stmp length] == 1){
            hexStr = [NSString stringWithFormat:@"0%@",stmp];
        }else {
            hexStr = stmp;
        }
        
        ret = [ret stringByAppendingString:hexStr];
    }
    return ret;
}

#pragma mark - 将内容是字节的字符串转换为data
+ (NSData *)jx_hexStringToByteArrayData:(NSString*)hexStr
{
    const char *cs = hexStr.UTF8String;
    
    int count = (int)strlen(cs);
    int8_t bytes[count / 2];
    
    for(int i = 0; i<count; i+=2)
    {
        char c1 = *(cs + i);
        char c2 = *(cs + i + 1);
        
        if(C2I(c1) >= 0 && C2I(c2) >= 0){
            bytes[i / 2] = C2I(c1) * 16 + C2I(c2);
        }
        else{
            return nil;
        }
    }
    return [NSData dataWithBytes:bytes length:count / 2];
}

#pragma mark - 取得一个大于256小于65536数字的高位字节
+ (Byte)jx_getHighByteFromArg:(int)arg
{
    uint temp = 0;
    NSString *int2str;
    NSString *subStr = nil;
    NSString *newSubStr = nil;
    
    // int转16进制得到的是String
    int2str = [NSString stringWithFormat:@"%x",arg];
    NSScanner *scanner;
    
    switch ([int2str length]) {
        case 3:
            newSubStr = [[NSString alloc]initWithFormat:@"0%@",int2str];// 不及4位 前面补足0
            subStr = [newSubStr substringWithRange:NSMakeRange(0, 2)];
            // String 转16进制 再转int型
            scanner = [NSScanner scannerWithString:subStr];
            [scanner scanHexInt:&temp];
            break;
        case 4:
            subStr = [int2str substringWithRange:NSMakeRange(0, 2)];
            // String 转16进制 再转int型
            scanner = [NSScanner scannerWithString:subStr];
            [scanner scanHexInt:&temp];
            break;
            
        default:
            temp = 0x00;
            break;
    }
    return (Byte)temp;
}

#pragma mark - 取得一个数字的低位字节
+ (Byte)jx_getLowByteFromArg:(int)arg
{
    uint temp = 0;
    NSString *int2str;
    NSString *subStr = nil;
    NSString *newSubStr = nil;
    
    int2str = [NSString stringWithFormat:@"%x",arg];// int转16进制得到的是String
    
    NSScanner *scanner;
    switch ([int2str length]) {
        case 0:
            temp = 0x00;
            break;
        case 1:
            newSubStr = [[NSString alloc]initWithFormat:@"0%@",int2str];// 不及2位 前面补足0
            subStr = [newSubStr substringWithRange:NSMakeRange(0, 2)];
            scanner = [NSScanner scannerWithString:newSubStr];
            [scanner scanHexInt:&temp];
            
            break;
        case 2:
            scanner = [NSScanner scannerWithString:int2str];
            [scanner scanHexInt:&temp];
            
            break;
        default:
        {
            subStr = [int2str substringWithRange:NSMakeRange([int2str length] - 2, 2)];// 截取低位
            // String 转16进制 再转int型
            scanner = [NSScanner scannerWithString:subStr];
            [scanner scanHexInt:&temp];
        }
            break;
    }
    return (Byte) temp;
}

#pragma mark - 将字节转为字符串
+ (NSString *)jx_byteToHexStr:(Byte)b
{
    NSString *hs = @"";
    NSString *stmp =  [NSString stringWithFormat:@"%x",b&0xff];
    if([stmp length] == 1){
        hs = [NSString stringWithFormat:@"0%@",stmp];
    }else {
        hs = stmp;
    }
    return hs;
}

#pragma mark - 将十六进制字符串转为带符号整型
+ (int)jx_hexStringChangeToIntWithHexStr:(NSString *)hexStr
{
    const char *char_content = [hexStr UTF8String];
    
    int len;
    int num = 0;
    int temp;
    int bits;
    int i;
    
    // 此例中 hex = "1de" 长度为3, hex是main函数传递的
    len = (int)strlen(char_content);
    
    for (i=0, temp=0; i<len; i++, temp=0)
    {
        // 第一次：i=0, *(hex + i) = *(hex + 0) = '1', 即temp = 1
        // 第二次：i=1, *(hex + i) = *(hex + 1) = 'd', 即temp = 13
        // 第三次：i=2, *(hex + i) = *(hex + 2) = 'd', 即temp = 14
        temp = C2I( *(char_content + i) );
        // 总共3位，一个16进制位用 4 bit保存
        // 第一次：'1'为最高位，所以temp左移 (len - i -1) * 4 = 2 * 4 = 8 位
        // 第二次：'d'为次高位，所以temp左移 (len - i -1) * 4 = 1 * 4 = 4 位
        // 第三次：'e'为最低位，所以temp左移 (len - i -1) * 4 = 0 * 4 = 0 位
        bits = (len - i - 1) * 4;
        temp = temp << bits;
        
        // 此处也可以用 num += temp;进行累加
        num = num | temp;
    }
    
    // 返回结果
    return num;
}


@end
