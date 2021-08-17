//
//  JXGPSManager.h
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/5.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 在 iOS 12中，Always 可以接收定位、获取信标范围、在后台继续定位、在后台开启定位、监控位置变化、使用区域监控和访问监控。而 WhenInUse 只有前三者的功能。
 在 iOS 13中，Always 不论 App 是否处于in use，均可以使用 Core Location 的所有 API 。而 WhenInUse 只有在 App in use时才可以使用 API
 
 "允许一次"模式
 如果用户选择“允许一次”，则状态更改为kCLAuthorizationStatusAuthorizedWhenInUse，但是设置还是为"询问"状态，下次App启动的时候，还是status == kCLAuthorizationStatusNotDetermined需要进行授权弹窗。
 
 “使用期间定位”模式
 info.plist 配置 NSLocationWhenInUseUsageDescription
 
 “始终定位”模式
 info.plist 同时配置以下项目
 NSLocationAlwaysAndWhenInUseUsageDescription
 NSLocationWhenInUseUsageDescription
 需要支持 iOS10 的话需要配置 NSLocationAlawaysUsageDescription
 
 "模糊定位"，iOS14适配
 可以通过直接在 info.plist 中添加 NSLocationDefaultAccuracyReduced 为 true,app默认不使用精确定位。
 这样设置之后，即使用户想要为该 App 开启精确定位权限，也无法开启。配置该字段后，申请定位权限的小地图中不在有精确定位的开关，即为关。
 
 新增 desiredAccuracy = kCLLocationAccuracyReduced
 
 "临时一次精准定位弹窗" —— 每次调用会弹窗，iOS无限制,iOS14
 在 Info.plist 中配置NSLocationTemporaryUsageDescriptionDictionary字典中需要配置 key 和 value 表明使用位置的原因，以及具体的描述。 key为自定义的字段，在接口中传入PurposeKey。
 然后调用方法[self.mgr requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"purposeKey"];
 */

typedef enum : NSUInteger {
    JXGPSManagerAuthorizationNotDetermined = 0, // 用户第一次请求权限未授权
    JXGPSManagerAuthorizationRestricted    = 1, // 家长控制之类的活动限制
    JXGPSManagerAuthorizationDenied        = 2, // 用户明确拒绝
    JXGPSManagerServiceNotEnabled          = 3, // 定位功能不可用
    JXGPSManagerAuthorizationAdmitted      = 4, // 定位功能授权成功
} JXGPSManagerAuthorizationStatus;

typedef enum : NSUInteger {
    JXGPSManagerRequestWhenInUse = 0,
    JXGPSManagerRequestAlways    = 1,// iOS13时，即使App开始的时候就申请“始终允许”权限，但是弹框中并不会出现该选项，原因是iOS13 之后，iOS加入“升级权限弹框”策略，“始终允许”询问被被推迟。
} JXGPSManagerRequestType;

@interface JXGPSManager : NSObject

/// 指定用户活动的类型。当前影响行为，例如确定何时可以自动更新位置暂停。默认情况下使用CLActivityTypeOther。
@property(assign, nonatomic) CLActivityType activityType;
/// 指定最小更新距离（以米为单位）。除非准确度有所提高，否则客户不会收到低于规定值的变动通知。通过kCLDistanceFilterNone，通知所有移动。默认情况下，使用kCLDistanceFilterNone。
@property(assign, nonatomic) CLLocationDistance distanceFilter;
/// 所需的定位精度。定位服务将尽力达到您想要的准确度。然而，这并不能保证。要优化电源性能，请确保为您的使用场景指定适当的精度（例如，当只需要粗略的位置时，请使用较大的精度值）。使用kCallocationAccuracyBest可获得最佳的精度。使用kCLLocationAccuracyBestForNavigation进行导航。
@property(assign, nonatomic) CLLocationAccuracy desiredAccuracy;
/// 指定尽可能自动暂停位置更新。。对于与iOS 6.0或更高版本链接的应用程序，此选项为“是”。
@property(assign, nonatomic) BOOL pausesLocationUpdatesAutomatically;
/// 是否允许后台定位更新
@property(assign, nonatomic) BOOL allowsBackgroundLocationUpdates;
/// 指定应用程序使用连续后台位置更新时显示指示器。
@property(assign, nonatomic) BOOL showsBackgroundLocationIndicator API_AVAILABLE(ios(11.0));
/// 指定航向服务更新所需的最小度数变化量。如果更新小于指定的筛选值，则不会通知客户端。传入kCLHeadingFilterNone以通知所有更新。默认情况下，使用1度。
@property(assign, nonatomic) CLLocationDegrees headingFilter;
/// 指定引用航向计算的物理设备方向。默认情况下，使用CLDeviceOrientationPortrait。CLDeviceOrientationUnknown、CLDeviceOrientationFaceUp和CLDeviceOrientationFaceDown被忽略。
@property(assign, nonatomic) CLDeviceOrientation headingOrientation;
/// 返回调用应用程序的当前授权状态。
@property (nonatomic, assign, readonly) CLAuthorizationStatus authorizationStatus;
/// 返回定位精度权限。info.plist中NSLocationDefaultAccuracyReduced 设置为 true 默认请求大概位置。这样设置之后，即使用户想要为该 App 开启精确定位权限，也无法开启。
@property (nonatomic, assign, readonly) CLAccuracyAuthorization accuracyAuthorization API_AVAILABLE(ios(14.0));
/// 如果调用应用程序的小部件可以接收位置更新，则返回true。
@property (nonatomic, assign, readonly) BOOL authorizedForWidgetUpdates API_AVAILABLE(ios(14.0));
/// 返回收到的最新heading更新
@property (nonatomic, strong, readonly) CLHeading *heading;
/// 框架可以支持的最大区域大小（以距中心点的距离为单位）。
@property (nonatomic, assign, readonly) CLLocationDistance maximumRegionMonitoringDistance;
/// 检索当前正在监视的区域的一组对象。
@property (nonatomic, strong, readonly) NSSet<CLRegion *>* monitoredRegions;
/// 检索此位置管理器正在为其主动提供测距的一组信标约束。
@property (nonatomic, strong) NSSet<CLBeaconIdentityConstraint *> *rangedBeaconConstraints API_AVAILABLE(ios(13.0));

/// 单例，非绝对
+ (instancetype)sharedInstance;

/// 请求定位权限
/// @param requestType 类型
/// @param success 成功
/// @param fail 失败
- (void)requestLocationServicesWith:(JXGPSManagerRequestType)requestType success:(void(^)(void))success fail:(void(^)(JXGPSManagerAuthorizationStatus status))fail;

/// 临时一次精准定位请求,在app已经获得定位权限之后，并且当前用户选择的是模糊定位，则允许应用申请一次临时精确定位权限,注意：此API不能用于申请定位权限，只能用于从模糊定位升级为精确定位；申请定位权限只能调用requestWhen或requestAlways，如果没有获得定位权限，直接调用此API无效。
/// @param key 描述
/// @param completion 回调
- (void)requestTemporaryFullAccuracyOnceWith:(NSString *)key completion:(void(^ _Nullable)(NSError * _Nullable))completion API_AVAILABLE(ios(14.0), macos(11.0), watchos(7.0), tvos(14.0));

/// 定位更新
/// @param locationsBlock 定位回调
/// @param locationFailBlock 失败回调
- (void)updateLocations:(void(^)(CLLocationManager *locationManager,NSArray<CLLocation *> *locations))locationsBlock failError:(void(^)(CLLocationManager *locationManager,NSError *error))locationFailBlock;

/// 停止定位更新
- (void)stopUpdateLocations;

@end

NS_ASSUME_NONNULL_END
