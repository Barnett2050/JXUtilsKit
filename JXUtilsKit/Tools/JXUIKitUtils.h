//
//  JXUIKitUtils.h
//  JXUtilsKit
//
//  Created by Barnett on 2020/4/9.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXUIKitUtils : NSObject

#pragma mark - 设备型号系统版本判定
/// 输入版本等于当前iOS设备版本 14.4
bool system_version_equal(NSString *version);

/// 输入版本大于当前iOS设备版本
bool system_version_lessThan(NSString *version);

/// 输入版本小于当前iOS设备版本
bool system_version_moreThan(NSString *version);

/// 输入版本大于等于当前iOS设备版本
bool system_version_moreThanOrEqual(NSString *version);

/// 输入版本小于等于当前iOS设备版本
bool system_version_lessThanOrEqual(NSString *version);

bool is_iPhoneX(void);

bool is_iPhone5(void);

#pragma mark - 视图尺寸相关参数

float screen_width(void);
float screen_height(void);

CGRect screen_bounds(void);

/// 状态栏高度
float statusBar_height(void);
/// 底部安全区高度，iphonex以上为49，以下为0
float bottomSafeArea_height(void);
/// tabbar高度（安全区高度+49）
float tabBar_height(void);

/// 屏幕宽度比例，以375为基准
float screenWidth_scale(void);
/// 屏幕高度比例，以667为基准
float screenHeight_scale(void);

/// 根据宽度比例向上取整
float ceil_widthScale(float width);
/// 根据高度比例向上取整
float ceil_heightScale(float height);

/// 根据宽度比例向下取整
float floor_widthScale(float width);
/// 根据高度比例向下取整
float floor_heightScale(float height);

#pragma mark - 颜色相关参数设置

UIColor* colorWith_RGBA(float r,float g,float b,float a);
UIColor* colorWith_RGB(float r,float g,float b);

/// 根据十六进制色值返回颜色
UIColor* colorWith_RGBAHex(int rgbValue,float a);
UIColor* colorWith_hex(int rgbValue);

/// 获取随机颜色
UIColor* kAPRandomColor(void);

#pragma mark - Application，单例，通知 相关参数
UIApplication* kApplication(void);
UIWindow* keyWindow(void);
UIViewController* rootViewController(void);
NSUserDefaults* kUserDefaults(void);
NSNotificationCenter* kNotificationCenter(void);

#pragma mark - UI设置方法
void kViewBorderRadius(UIView *view,float radius,float borderWidth,UIColor *borderColor);

#pragma mark - 字体相关设置
UIFont* system_font(float value);
UIFont* system_scaleFont(float value);

UIFont* boldSystem_font(float value);
UIFont* boldSystem_scaleFont(float value);

UIFont* fontName_size(NSString *fontName,float size);
UIFont* fontName_scaleSize(NSString *fontName,float size);

#pragma mark - 快速生成对象
/// 图片
UIImage* image_named(NSString *name);
/// 随机数
int randomInt(int from,int to);
@end

NS_ASSUME_NONNULL_END
