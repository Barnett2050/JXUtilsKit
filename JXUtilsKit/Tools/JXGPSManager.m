//
//  JXGPSManager.m
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/5.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import "JXGPSManager.h"
#import <UIKit/UIKit.h>

static NSString *kLocationWhenInUseUsageKey = @"NSLocationWhenInUseUsageDescription"; // 定位使用期间权限key
static NSString *kLocationAlwaysUsageKey = @"NSLocationAlwaysAndWhenInUseUsageDescription"; // 定位always期间权限key
@interface JXGPSManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) void (^requestLocationSuccessBlock)(void);
@property (nonatomic, copy) void (^requestLocationFailBlock)(JXGPSManagerAuthorizationStatus status);
@property (nonatomic, copy) void (^locationsBlock)(CLLocationManager *locationManager,NSArray<CLLocation *> *locations);
@property (nonatomic, copy) void (^locationFailBlock)(CLLocationManager *locationManager,NSError *error);

@end

@implementation JXGPSManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onestoken;
    static JXGPSManager *manager;
    dispatch_once(&onestoken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.delegate = self;
    }
    return self;
}

#pragma mark - set,get
- (void)setActivityType:(CLActivityType)activityType
{
    self.locationManager.activityType = activityType;
}
- (CLActivityType)activityType
{
    return self.locationManager.activityType;
}
- (void)setDistanceFilter:(CLLocationDistance)distanceFilter
{
    self.locationManager.distanceFilter = distanceFilter;
}
- (CLLocationDistance)distanceFilter
{
    return self.locationManager.distanceFilter;
}
- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
    self.locationManager.desiredAccuracy = desiredAccuracy;
}
- (CLLocationAccuracy)desiredAccuracy
{
    return self.locationManager.desiredAccuracy;
}
- (void)setPausesLocationUpdatesAutomatically:(BOOL)pausesLocationUpdatesAutomatically
{
    self.locationManager.pausesLocationUpdatesAutomatically = pausesLocationUpdatesAutomatically;
}
- (BOOL)pausesLocationUpdatesAutomatically
{
    return self.locationManager.pausesLocationUpdatesAutomatically;
}
- (void)setAllowsBackgroundLocationUpdates:(BOOL)allowsBackgroundLocationUpdates
{
    self.locationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates;
}
- (BOOL)allowsBackgroundLocationUpdates
{
    return self.locationManager.allowsBackgroundLocationUpdates;
}
- (void)setShowsBackgroundLocationIndicator:(BOOL)showsBackgroundLocationIndicator
{
    self.locationManager.showsBackgroundLocationIndicator = showsBackgroundLocationIndicator;
}
- (BOOL)showsBackgroundLocationIndicator
{
    return self.locationManager.showsBackgroundLocationIndicator;
}
- (void)setHeadingFilter:(CLLocationDegrees)headingFilter
{
    self.locationManager.headingFilter = headingFilter;
}
- (CLLocationDegrees)headingFilter
{
    return self.locationManager.headingFilter;
}
- (void)setHeadingOrientation:(CLDeviceOrientation)headingOrientation
{
    self.locationManager.headingOrientation = headingOrientation;
}
- (CLDeviceOrientation)headingOrientation
{
    return self.locationManager.headingOrientation;
}

- (CLAuthorizationStatus)authorizationStatus
{
    if (@available(iOS 14.0,*)) {
        return self.locationManager.authorizationStatus;
    } else {
        return [CLLocationManager authorizationStatus];
    }
}

- (CLAccuracyAuthorization)accuracyAuthorization
{
    return self.locationManager.accuracyAuthorization;
}

- (BOOL)authorizedForWidgetUpdates
{
    return self.locationManager.isAuthorizedForWidgetUpdates;
}

- (CLHeading *)heading
{
    return self.locationManager.heading;
}

- (CLLocationDistance)maximumRegionMonitoringDistance
{
    return self.locationManager.maximumRegionMonitoringDistance;
}

- (NSSet<CLRegion *> *)monitoredRegions
{
    return self.locationManager.monitoredRegions;
}

- (NSSet<CLBeaconIdentityConstraint *> *)rangedBeaconConstraints
{
    return self.locationManager.rangedBeaconConstraints;
}

#pragma mark - public

- (void)requestLocationServicesWith:(JXGPSManagerRequestType)requestType success:(void(^)(void))success fail:(void(^)(JXGPSManagerAuthorizationStatus status))fail
{
    if (![self infoPlistContainWith:requestType]) { return; }
    
    if (![CLLocationManager locationServicesEnabled]) {
        if (fail) {
            fail(JXGPSManagerServiceNotEnabled);
        }
        return;
    }
    
    if (self.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        if (success) {
            self.requestLocationSuccessBlock = success;
        }
        if (fail) {
            self.requestLocationFailBlock = fail;
        }
        if (requestType == JXGPSManagerRequestWhenInUse) {
            [self.locationManager requestWhenInUseAuthorization];
        } else if (requestType == JXGPSManagerRequestAlways) {
            [self.locationManager requestAlwaysAuthorization];
        }
    } else {
        switch (self.authorizationStatus) {
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            case kCLAuthorizationStatusAuthorizedAlways:
                if (success) {
                    success();
                }
                break;
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
                if (fail) {
                    fail([self getAuthorizationStatusWith:self.authorizationStatus]);
                }
                break;
            default:
                break;
        }
    }
}

- (void)requestTemporaryFullAccuracyOnceWith:(NSString *)key completion:(void(^ _Nullable)(NSError * _Nullable))completion API_AVAILABLE(ios(14.0), macos(11.0), watchos(7.0), tvos(14.0))
{
    [self.locationManager requestTemporaryFullAccuracyAuthorizationWithPurposeKey:key completion:^(NSError * error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)updateLocations:(void(^)(CLLocationManager *locationManager,NSArray<CLLocation *> *locations))locationsBlock failError:(void(^)(CLLocationManager *locationManager,NSError *error))locationFailBlock
{
    [self.locationManager startUpdatingLocation];
    if (locationsBlock) {
        self.locationsBlock = locationsBlock;
    }
    if (locationFailBlock) {
        self.locationFailBlock = locationFailBlock;
    }
}

- (void)stopUpdateLocations
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
/// 定位授权变化
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager
{
    if (self.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
               self.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        if (self.requestLocationSuccessBlock) {
            self.requestLocationSuccessBlock();
        }
    } else if (self.authorizationStatus != kCLAuthorizationStatusNotDetermined) {
        if (self.requestLocationFailBlock) {
            self.requestLocationFailBlock([self getAuthorizationStatusWith:self.authorizationStatus]);
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (self.locationsBlock) {
        self.locationsBlock(manager,locations);
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.locationFailBlock) {
        self.locationFailBlock(manager,error);
    }
}

#pragma mark - private
- (JXGPSManagerAuthorizationStatus)getAuthorizationStatusWith:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            return JXGPSManagerAuthorizationAdmitted;
            break;
        case kCLAuthorizationStatusDenied:
            return JXGPSManagerAuthorizationDenied;
            break;
        case kCLAuthorizationStatusRestricted:
            return JXGPSManagerAuthorizationRestricted;
            break;
        default:
            return JXGPSManagerAuthorizationNotDetermined;
            break;
    }
}

- (BOOL)infoPlistContainWith:(JXGPSManagerRequestType)requestType
{
    NSString *content;
    NSString *message;
    switch (requestType) {
        case JXGPSManagerRequestWhenInUse:
            content = kLocationWhenInUseUsageKey;
            message = @"info.plist文件缺少定位WhenInUse权限相关描述";
            break;
        case JXGPSManagerRequestAlways:
            content = kLocationAlwaysUsageKey;
            message = @"info.plist文件缺少定位Always权限相关描述";
            break;
        default:
            break;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    BOOL flag = false;
    if ([infoDictionary.allKeys containsObject:content]) {
        NSString *stringValue = [infoDictionary objectForKey:content];
        if (stringValue.length != 0) {
            flag = true;
        }
    }
    if (!flag) {
        [JXGPSManager showAlertWithTitle:@"提示" message:message confirm:@"确定" cancle:nil confirmBlock:nil cancleBlock:nil];
    }
    return flag;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirmStr cancle:(NSString *)cancleStr confirmBlock:(void(^)(void))confirm cancleBlock:(void(^)(void))cancle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        if (confirmStr != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:confirmStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (confirm) {
                    confirm();
                }
            }]];
        }
        if (cancleStr != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:cancleStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (cancle) {
                    cancle();
                }
            }]];
        }
        [[JXGPSManager visibleViewController] presentViewController:alertController animated:YES completion:nil];
    });
}

+ (UIViewController *)visibleViewController
{
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [JXGPSManager getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [JXGPSManager getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [JXGPSManager getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [JXGPSManager getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}
@end
