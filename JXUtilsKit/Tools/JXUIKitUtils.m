//
//  JXUIKitUtils.m
//  JXUtilsKit
//
//  Created by Barnett on 2020/4/9.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import "JXUIKitUtils.h"

@implementation JXUIKitUtils

bool system_version_equal(NSString *version) {
    return jxSystem_Version_Comparison(version) == NSOrderedSame;
}

bool system_version_lessThan(NSString *version) {
    return jxSystem_Version_Comparison(version) == NSOrderedAscending;
}

bool system_version_moreThan(NSString *version) {
    return jxSystem_Version_Comparison(version) == NSOrderedDescending;
}

bool system_version_moreThanOrEqual(NSString *version) {
    return jxSystem_Version_Comparison(version) != NSOrderedAscending;
}

bool system_version_lessThanOrEqual(NSString *version) {
    return jxSystem_Version_Comparison(version) != NSOrderedDescending;
}

bool is_iPhoneX(void) {
//    return (KScreen_Width() > KScreen_Height() ? (KScreen_Width() == 896 || KScreen_Width() == 812):(KScreen_Height() == 896 || KScreen_Height() == 812));
    bool flag = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0;
    return flag;
}

bool is_iPhone5(void) {
    return (screen_width() > screen_height() ? (screen_height() == 320 || screen_height() == 320):(screen_width() == 320 || screen_width() == 320));
}

float screen_width(void) {
    return UIScreen.mainScreen.bounds.size.width;
}

float screen_height(void) {
    return UIScreen.mainScreen.bounds.size.height;
}
CGRect screen_bounds(void) {
    return UIScreen.mainScreen.bounds;
}

float statusBar_height(void) {
    return is_iPhoneX() ? 44.0 : 20;
}
float bottomSafeArea_height(void) {
    CGFloat height = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom;
    return height;
}
float tabBar_height(void) {
    return (is_iPhoneX() ? (bottomSafeArea_height() + 49):49);
}
float screenWidth_scale(void) {
    return screen_width()/375.0;
}
float screenHeight_scale(void) {
    return screen_height()/667.0;
}
float ceil_widthScale(float width) {
    return ceil(width*screenWidth_scale());
}
float ceil_heightScale(float height) {
    return ceil(height*screenHeight_scale());
}

float floor_widthScale(float width) {
    return floor(width*screenWidth_scale());
}
float floor_heightScale(float height) {
    return floor(height*screenHeight_scale());
}

UIColor* colorWith_RGBA(float r,float g,float b,float a) {
    return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a];
}
UIColor* colorWith_RGB(float r,float g,float b) {
    return colorWith_RGBA(r, g, b, 1.0);
}
UIColor* colorWith_RGBAHex(int rgbValue,float a) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a];
}
UIColor* colorWith_hex(int rgbValue) {
    return colorWith_RGBAHex(rgbValue, 1.0);
}
UIColor* kAPRandomColor(void) {
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
}

UIApplication* kApplication(void) {
    return [UIApplication sharedApplication];
}
UIWindow* keyWindow(void) {
    return [UIApplication sharedApplication].delegate.window;
}
UIViewController* rootViewController(void) {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}
NSUserDefaults* kUserDefaults(void) {
    return [NSUserDefaults standardUserDefaults];
}
NSNotificationCenter* kNotificationCenter(void) {
    return [NSNotificationCenter defaultCenter];
}

void kViewBorderRadius(UIView *view,float radius,float borderWidth,UIColor *borderColor) {
    [view.layer setCornerRadius:(radius)];
    [view.layer setMasksToBounds:true];
    [view.layer setBorderWidth:(borderWidth)];
    [view.layer setBorderColor:[borderColor CGColor]];
}

UIFont* system_font(float value) {
    return [UIFont systemFontOfSize:value];
}
UIFont* system_scaleFont(float value) {
    return [UIFont systemFontOfSize:(value*screenWidth_scale())];
}
UIFont* boldSystem_font(float value) {
    return [UIFont boldSystemFontOfSize:value];
}
UIFont* boldSystem_scaleFont(float value) {
    return [UIFont boldSystemFontOfSize:(value*screenWidth_scale())];
}
UIFont* fontName_size(NSString *fontName,float size) {
    return [UIFont fontWithName:fontName size:size];
}
UIFont* fontName_scaleSize(NSString *fontName,float size) {
    return [UIFont fontWithName:fontName size:(size*screenWidth_scale())];
}


UIImage* image_named(NSString *name) {
    return [UIImage imageNamed:name];
}

int randomInt(int from,int to) {
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - private
NSComparisonResult jxSystem_Version_Comparison(NSString *version) {
    return [[UIDevice currentDevice].systemVersion compare:version options:NSNumericSearch];
}

@end
