//
//  JXHealthTool.m
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/10.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import "JXHealthTool.h"
#import <CoreMotion/CoreMotion.h>

@interface JXHealthTool ()

/// 健康数据查询类
@property (nonatomic, strong) HKHealthStore *healthStore;
/// 协处理器类
@property (nonatomic, strong) CMPedometer *pedometer;

@end

@implementation JXHealthTool

- (void)requestHealthAuthorizationWithShareTypes:(nullable NSSet<HKSampleType *> *)typesToShare
                                       readTypes:(nullable NSSet<HKObjectType *> *)typesToRead
                                      completion:(void(^)(JXHealthToolStatus status, NSSet *deniedShareSet,NSError *error))completion
{
    if (![HKHealthStore isHealthDataAvailable]) {
        completion(JXHealthToolStatus_NotAvailable,nil,nil);
        return;
    }
    if (!completion) {
        return;
    }
    
    self.healthStore = [[HKHealthStore alloc] init];
    [self.healthStore requestAuthorizationToShareTypes:typesToShare readTypes:typesToRead completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSMutableSet *deniedShareMutableSet = [[NSMutableSet alloc] init];
            if (typesToShare.count != 0) {
                for (HKObjectType *types in typesToShare) {
                    HKAuthorizationStatus authorizationStatus = [self.healthStore authorizationStatusForType:types];
                    if (authorizationStatus == HKAuthorizationStatusSharingDenied) {
                        [deniedShareMutableSet addObject:types];
                    }
                }
            }
            if (deniedShareMutableSet.count == 0) {
                completion(JXHealthToolStatus_Success,nil,nil);
            } else {
                completion(JXHealthToolStatus_ShareDenied,deniedShareMutableSet,nil);
            }
        } else {
            completion(JXHealthToolStatus_Error,nil,error);
        }
    }];
}

#pragma mark - public
/// 获取当天健康数据(步数)
- (void)getStepCount:(void (^)(double stepCount, NSError *error))queryResultBlock {
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc]initWithQuantityType:quantityType quantitySamplePredicate:[self predicateForSamplesToday] options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery * _Nonnull query, HKStatistics * _Nullable result, NSError * _Nullable error) {
        if (error) {
            [self getCMPStepCount: queryResultBlock];
        } else {
            double stepCount = [result.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
            if(stepCount > 0){
                if (queryResultBlock) {
                    queryResultBlock(stepCount,nil);
                }
            } else {
                [self getCMPStepCount: queryResultBlock];
            }
        }
        
    }];
    [self.healthStore executeQuery:query];
}

#pragma mark - private
/// 获取协处理器步数
- (void)getCMPStepCount:(void(^)(double stepCount, NSError *error))completion
{
    if ([CMPedometer isStepCountingAvailable] && [CMPedometer isDistanceAvailable]) {
        if (!_pedometer) {
            _pedometer = [[CMPedometer alloc]init];
        }
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
        // 开始时间
        NSDate *startDate = [calendar dateFromComponents:components];
        // 结束时间
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        __weak typeof(self) weakSelf = self;
        [_pedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (error) {
                if(completion) completion(0 ,error);
            
            } else {
                double stepCount = [pedometerData.numberOfSteps doubleValue];
                if(completion)
                    completion(stepCount ,error);
            }
            [weakSelf.pedometer stopPedometerUpdates];
        }];
    }
}
/// 构造当天时间段查询参数
- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}

#pragma mark - init
static JXHealthTool *sharedSingleton = nil;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(sharedSingleton == nil) {
            sharedSingleton = [super allocWithZone:zone];
        }
    });
    return sharedSingleton;
}
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
+ (instancetype)sharedInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(sharedSingleton == nil) {
            sharedSingleton = [[self alloc] init];
        }
    });
    return sharedSingleton;
}
- (id)copy
{
    return self;
}
- (id)mutableCopy
{
    return self;
}

#pragma mark - getter
- (HKHealthStore *)healthStore {
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}
@end
