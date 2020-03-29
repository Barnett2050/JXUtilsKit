
//
//  UIKitMacroHeader.h
//  BaseAndTools
//
//  Created by edz on 2019/10/17.
//  Copyright © 2019 edz. All rights reserved.
//

#ifndef UIKitMacroHeader_h
#define UIKitMacroHeader_h

/* ----------------------------------------  设备型号系统版本  ---------------------------------------*/

// 第一种 IPHONEX 判断
//#define IS_IPHONEX (KScreen_Width > KScreen_Height ? (KScreen_Width == 896 || KScreen_Width == 812):(KScreen_Height == 896 || KScreen_Height == 812))
// 第二种 IPHONEX 判断
#define IS_IPHONEX (SystemVersion_Same_Than_Same(@"11.0") && [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0)

#define IS_iPhone_5 (KScreen_Width > KScreen_Height ? (KScreen_Height == 320 || KScreen_Height == 320):(KScreen_Width == 320 || KScreen_Width == 320))
// 系统版本 =
#define System_Version_Equal(v)    [[UIDevice currentDevice].systemVersion compare:v options:NSNumericSearch] == NSOrderedSame
// <
#define System_Version_LessThan(v)    [[UIDevice currentDevice].systemVersion compare:v options:NSNumericSearch] == NSOrderedAscending
// >
#define System_Version_MoreThan(v)    [[UIDevice currentDevice].systemVersion compare:v options:NSNumericSearch] == NSOrderedDescending
// >=
#define System_Version_MoreThan_Equal(v)    [[UIDevice currentDevice].systemVersion compare:v options:NSNumericSearch] != NSOrderedAscending
// <=
#define System_Version_LessThan_Equal(v)    [[UIDevice currentDevice].systemVersion compare:v options:NSNumericSearch] != NSOrderedDescending

/* ----------------------------------------  设备型号系统版本  ---------------------------------------*/


/* ----------------------------------------  视图尺寸相关参数  ---------------------------------------*/
#define KScreen_Width ([[UIScreen mainScreen] bounds].size.width)
#define KScreen_Height ([[UIScreen mainScreen] bounds].size.height)
#define KScreen_Bounds [UIScreen mainScreen].bounds
#define KSCREEN_ORIGINY ([[UIApplication sharedApplication] statusBarFrame].size.height + 44.0f)
#define kStatusBar_Height (IS_IPHONEX ? 44:20)
#define kBottomSafeArea_Insets (IS_IPHONEX ? [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom:0)
#define kTabBar_Height (IS_IPHONEX ? ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom + 49):49)

#define JXWidthScale (KScreenWidth/375.0) // 以375为基准
#define JXHeightScale (KScreen_Height/667.0) // 以667为基准
#define JXCWidth(R) ceil(JXWidthScale*R) // 向上取整
#define JXCHeight(R) ceil(JXHeightScale*R)
#define JXFWidth(R) floor(JXWidthScale*R) // 向下取整
#define JXFHeight(R) floor(JXHeightScale*R)

/* ----------------------------------------  视图尺寸相关参数  ---------------------------------------*/


/* ----------------------------------------  颜色相关参数  ---------------------------------------*/

//颜色设置
#define kColorWith_RGBA(r, g, b, a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
#define kColorWith_RGB(r,g,b) kColorWith_RGBA(r,g,b,1.0f)
#define kColorWith_RGBA_Hex(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define kColorWith_RGB_Hex(rgbValue) kColorWith_RGBA_Hex(rgbValue, 1.0f)

// 随机颜色
#define KAPRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

/* ----------------------------------------  颜色相关参数  ---------------------------------------*/


/* ----------------------------------------  Application相关参数  ---------------------------------------*/

#define JXApplication [UIApplication sharedApplication]

#define JXAppWindow [UIApplication sharedApplication].delegate.window

#define JXRootViewController [UIApplication sharedApplication].delegate.window.rootViewController

#define JXUserDefaults [NSUserDefaults standardUserDefaults]

#define JXNotificationCenter [NSNotificationCenter defaultCenter]

/* ----------------------------------------  Application相关参数  ---------------------------------------*/


/* ----------------------------------------  UI设置  ---------------------------------------*/

//View圆角和加边框
#define ViewBorderRadius(View,Radius,Width,Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View圆角
#define ViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


/* ----------------------------------------  UI设置  ---------------------------------------*/


/* ----------------------------------------  字体设置  ---------------------------------------*/

#define System_Font(value) [UIFont systemFontOfSize:value]
#define System_ScaleFont(value) [UIFont systemFontOfSize:(value*JXWidthScale)]

#define BoldSystem_Font(value) [UIFont boldSystemFontOfSize:value]
#define BoldSystem_ScaleFont(value) [UIFont boldSystemFontOfSize:(value*JXWidthScale)]

#define FontName_Size(fontName,value) [UIFont fontWithName:fontName size:value]
#define FontName_ScaleSize(fontName,value) [UIFont fontWithName:fontName size:(value*JXWidthScale)]

/* ----------------------------------------  字体设置  ---------------------------------------*/

#endif /* UIKitMacroHeader_h */
