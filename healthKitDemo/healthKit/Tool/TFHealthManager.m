//
//  TFHealthManager.m
//  healthKit
//
//  Created by 张永强 on 17/5/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "TFHealthManager.h"


#import "NSDate+TFDate.h"

@interface TFHealthManager ()

/** healthStore */
@property (nonatomic , strong)HKHealthStore *healthStore;

@end

static TFHealthManager *_healthManager = nil;

@implementation TFHealthManager

- (HKHealthStore *)healthStore {
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
      
    }
    return _healthStore;
}

+ (instancetype)TF_standardHealthManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _healthManager = [[TFHealthManager alloc] init];
    });
    return _healthManager;
}
+ (BOOL)TF_isHealthDataAvailable {
    
    return [HKHealthStore isHealthDataAvailable];
}
+ (BOOL)TF_isAuthorizationStatusForType:(HKObjectType *)type {
    HKAuthorizationStatus  authorizationType = [[TFHealthManager TF_standardHealthManager].healthStore authorizationStatusForType:type];
    if (authorizationType == HKAuthorizationStatusSharingDenied) {
        return NO;
    }
    return YES;
}
+ (void)TF_authorizeHealthKitWithType:(TFQuantityType)type result:(void(^)(BOOL isAuthorizateSuccess ,NSError *error))resultBlock {
    NSMutableSet *readSet = [NSMutableSet set];
    if (type & TFQuantityTypeStep) {
       [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount]];
    }
    if (type & TFQuantityTypeWalking) {
         [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]];
    }
    if (type & TFQuantityTypeCycling) {
        [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling]];
    }
    if (type & TFQuantityTypeSwimming) {
        [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceSwimming]];
    }
    if (type & TFQuantityTypeHeight) {
        [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight]];
    }
    if (type & TFQuantityTypeBodyMass) {
       [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass]];
    }
    if (type & TFQuantityTypeActiveEnergyBurned) {
        [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned]];
    }
    if (type & TFQuantityTypeBasalEnergyBurned) {
        [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned]];
    }
    
    if (type & TFQuantityTypeBloodGlucose) {
        [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose]];
    }
    if (type & TFQuantityTypeBloodPressureSystolic) {
       [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic]];
    }
    if (type & TFQuantityTypeBloodPressureDiastolic) {
       [readSet addObject:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic]];
    }
   
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        [[TFHealthManager TF_standardHealthManager].healthStore requestAuthorizationToShareTypes:readSet readTypes:readSet completion:^(BOOL success, NSError * _Nullable error) {
            if (resultBlock) {
                resultBlock(success , error);
            }
        }];
//    });
    
}
#pragma mark -- 获取的数据一天中所有的步数
+ (void)TF_fetchAllHealthDataByDay:(void (^)(NSArray *modelArray))queryResultBlock {
    [self TF_fetchAllHealthType:TFHealthIntervalUnitDay queryResultBlock:^(NSArray *queryResults) {
        if (queryResultBlock) {
            queryResultBlock(queryResults);
        }
    }];
}
#pragma mark  获取一天中总共的步数
+ (void)TF_getAllStepCount:(void(^)(NSUInteger stepCount))stepCountBlock{
    [self TF_fetchAllHealthDataByDay:^(NSArray *modelArray) {
        NSUInteger stepCount = 0;
        for (NSDictionary *dic in modelArray) {
            NSNumber *count = dic[@"stepCount"];
            stepCount += [count integerValue];
        }
        stepCountBlock(stepCount);
    }];
}

#pragma mark -- 根据不同类型获取
+ (void)TF_fetchAllHealthType:(TFHealthIntervalUnit)unit
             queryResultBlock:(void (^)(NSArray *queryResults))queryResultBlock {
    
        __block NSCalendar *calendar    = [NSDate TF_sharedCalendar];
        NSDate *endDate                 = [NSDate TF_getCurrentDate];
        NSDateComponents *hComponents;
        NSDate *startDate ;
        switch (unit) {
            case TFHealthIntervalUnitDay:
            {
    //            间隔一小时统计一次
                startDate               = [NSDate TF_dateAfterDate:endDate day:-1];
                hComponents             = [calendar components:NSCalendarUnitHour fromDate:endDate];
                [hComponents setHour:1];
            }
                break;
            case TFHealthIntervalUnitWeek:
            {
    //            间隔一天统计一次
                startDate               = [NSDate TF_dateAfterDate:endDate day:-7];
                hComponents             = [calendar components:NSCalendarUnitDay fromDate:endDate];
                [hComponents setDay:1];
            }
                break;
            case TFHealthIntervalUnitMonth:
            {
    //            间隔一周统计一次
                startDate               = [NSDate TF_dateAfterDate:endDate month:-1];
                hComponents             = [calendar components:NSCalendarUnitDay fromDate:endDate];
                [hComponents setDay:6];
            }
                break;
            case TFHealthIntervalUnitYear:
            {
    //            间隔一月统计一次
                startDate               = [NSDate TF_dateAfterDate:endDate year:-1];
                hComponents             = [calendar components:NSCalendarUnitMonth fromDate:endDate];
                [hComponents setMonth:1];
            }
                break;
            default:
                
                break;
        }
    [self TF_fetchAllHealthStartDate:startDate endDate:endDate hComponents:hComponents queryResultBlock:^(NSArray *queryResults) {
        if (queryResultBlock) {
            queryResultBlock(queryResults);
        }
    }];
}
#pragma mark -- 根据不同时间获取
+ (void)TF_fetchAllHealthStartDate:(NSDate *)startDate
                           endDate:(NSDate *)endDate
                       hComponents:(NSDateComponents *)hComponents
                  queryResultBlock:(void (^)(NSArray *queryResults))queryResultBlock {
    [self TF_fetchAllHealthStartDate:startDate endDate:endDate hComponents:hComponents quantityType:TFQuantityTypeStep  type:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount] queryResultBlock:^(NSArray *queryResults) {
        if (queryResultBlock) {
            queryResultBlock(queryResults);
        }
    }];
}

#pragma mark -- 获取0点到现在的数据
+ (void)TF_getStepCountWithHourOf0ClockBlock:(void (^)(NSArray *queryResults))queryResultBlock{
    NSArray *dateArr = [self getAllDate];
    NSMutableArray *currentDateArray       = [NSMutableArray array];
    //获取要取得时间步数
    for (NSArray *dArr in dateArr) {
        NSDate *endDate = dArr[1];
//        NSDate *currentDate = [NSDate TF_getCurrentDate];
        NSDate *currentDate = [NSDate date];
        if ([NSDate TF_compareDate:endDate withAnotherDate:currentDate withIsIncludeSecond:YES ] == 1) {
            break;
        }else {
            [currentDateArray addObject:dArr];
        }
    }
    //获取每个小时的步数
    NSMutableArray *array       = [NSMutableArray array];
    for (NSArray *dArr in currentDateArray) {
        NSDate *startDate = dArr[0];
        NSDate *endDate = dArr[1];
         __block NSCalendar *calendar    = [NSDate TF_sharedCalendar];
        NSDateComponents *hComponents = [calendar components:NSCalendarUnitHour fromDate:endDate];
        [hComponents setHour:1];
        HKQuantityType *quantityType        = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        NSPredicate *predicate              = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
        NSUInteger op                       = HKStatisticsOptionCumulativeSum;
        HKStatisticsCollectionQuery  *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:op anchorDate:startDate intervalComponents:hComponents];
        query.initialResultsHandler         = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
            if (error){
                NSLog(@"统计update出错 %@", error);
                return;
            }else {

                for (HKStatistics *statist in result.statistics){
                    double sum4             = [statist.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
                    NSDictionary *dic       = @{@"stepCount":@(sum4),
                                                @"startDate":[NSDate TF_getNewTimeFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES] date:statist.startDate] ,
                                                @"endDate":[NSDate TF_getNewTimeFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES] date: statist.endDate]
                                                };
                    [array addObject:dic];
                }
                if (result.statistics.count == 0) {
                    NSDictionary *dic       = @{@"stepCount":@(0),
                                                @"startDate":[NSDate TF_getNewTimeFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES] date:startDate] ,
                                                @"endDate":[NSDate TF_getNewTimeFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES] date:endDate]
                                                };
                    [array addObject:dic];
                }
                if (queryResultBlock &&array.count == currentDateArray.count) {
                    queryResultBlock(array);
                }
            };
        };
        [[TFHealthManager TF_standardHealthManager].healthStore executeQuery:query];
    }
}
+ (NSArray *)getAllDate {
    NSString *dateStr               = [NSDate TF_getNewTimeFormat:[NSDate TF_ymdFormat]];
    NSString *startDateStr          = [NSString stringWithFormat:@"%@ 00:00:00" , dateStr];
    NSDate *startDate               = [NSDate TF_dateWithString:startDateStr format:[NSDate TF_ymd_hmsFormatIs24hour:YES]];
    NSMutableArray *endDateArray    = [NSMutableArray array];
    [endDateArray addObject:startDate];
    for (int i = 1; i < 25; i ++) {
      NSDate  *date                 = [NSDate TF_dateAfterDate:startDate hour:i];
        [endDateArray addObject:date];
    }
    NSMutableArray * allDatePeriods = [NSMutableArray array];
    for (int i = 0; i < endDateArray.count ; i++) {
        if (i+1 >= endDateArray.count) {
            break;
        }
        NSDate * startDate          = endDateArray[i];
        NSDate *endDate             = endDateArray[i+1];
        NSArray *arr = @[startDate,endDate];
        [allDatePeriods addObject:arr];
    }
    return [allDatePeriods copy];
}
#pragma mark -- 获取当天的数据
+ (void)TF_getDayHealthWithType:(TFQuantityType)unit
               queryResultBlock:(void (^)(NSArray *queryResults))queryResultBlock{
    __block NSCalendar *calendar    = [NSDate TF_sharedCalendar];
    NSDate *endDate                 = [NSDate TF_getCurrentDate];
    NSDate *startDate               = [NSDate TF_dateAfterDate:endDate day:-1];
    NSDateComponents *hComponents   = [calendar components:NSCalendarUnitHour fromDate:endDate];
    [hComponents setHour:1];
    HKQuantityType *quantityType;
    switch (unit) {
        case TFQuantityTypeStep:
        {
            quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            [self TF_fetchAllHealthStartDate:startDate endDate:endDate hComponents:hComponents quantityType:TFQuantityTypeStep type:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
            break;
        case TFQuantityTypeWalking:
        {   quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            [self TF_fetchAllHealthStartDate:startDate endDate:endDate hComponents:hComponents quantityType:TFQuantityTypeWalking type:quantityType  queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
            break;
        case TFQuantityTypeCycling:
        {
            quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
            [self TF_fetchAllHealthStartDate:startDate endDate:endDate hComponents:hComponents quantityType:TFQuantityTypeCycling type:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
            break;
        case TFQuantityTypeSwimming:
            
        {
            quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceSwimming];
            [self TF_fetchAllHealthStartDate:startDate endDate:endDate hComponents:hComponents quantityType:TFQuantityTypeSwimming type:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
            break;
        case TFQuantityTypeActiveEnergyBurned:
            
        {
            quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
            [self TF_fetchAllHealthStartDate:startDate endDate:endDate hComponents:hComponents quantityType:TFQuantityTypeActiveEnergyBurned type:quantityType  queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
            break;
        case TFQuantityTypeBasalEnergyBurned:
        {
            quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
            [self TF_fetchAllHealthStartDate:startDate endDate:endDate hComponents:hComponents quantityType:TFQuantityTypeBasalEnergyBurned type:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
            
            break;
        case TFQuantityTypeHeight:
        {
         quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
            [self TF_getBodyType:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
            break;
        case TFQuantityTypeBodyMass:
        {
           quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
            [self TF_getBodyType:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
        case TFQuantityTypeBloodGlucose:
        {
            quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
            [self TF_getBodyType:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
        case TFQuantityTypeBloodPressureSystolic:
        {
            quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
            [self TF_getBodyType:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }
        case TFQuantityTypeBloodPressureDiastolic:
        {
            quantityType  = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
            [self TF_getBodyType:quantityType queryResultBlock:^(NSArray *queryResults) {
                if (queryResultBlock) {
                    queryResultBlock(queryResults);
                }
            }];
        }

            break;
    }
}
//根据不同类型获取不同的数据,返回不同的数据
+ (void)TF_fetchAllHealthStartDate:(NSDate *)startDate
                           endDate:(NSDate *)endDate
                       hComponents:(NSDateComponents *)hComponents
                      quantityType:(TFQuantityType)unit
                              type:(HKQuantityType *)quantityType
                  queryResultBlock:(void (^)(NSArray *queryResults))queryResultBlock {
    NSPredicate *predicate              = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSUInteger op                       = HKStatisticsOptionCumulativeSum | HKStatisticsOptionNone;
    HKStatisticsCollectionQuery  *query = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:op anchorDate:startDate intervalComponents:hComponents];
    query.initialResultsHandler         = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
        if (error){
            NSLog(@"统计update出错 %@", error);
            return;
        }else {
            NSMutableArray *array       = [NSMutableArray array];
            for (HKStatistics *statist in result.statistics){
                
                double sum4;
                if (unit == TFQuantityTypeStep) {
                   sum4             = [statist.sumQuantity doubleValueForUnit:[HKUnit countUnit]];
                }else if (unit == TFQuantityTypeWalking || unit ==TFQuantityTypeCycling || unit == TFQuantityTypeSwimming) {
                   sum4             = [statist.sumQuantity doubleValueForUnit:[HKUnit meterUnit]];
                }else if (unit == TFQuantityTypeActiveEnergyBurned || unit ==TFQuantityTypeBasalEnergyBurned) {
                  sum4             = [statist.sumQuantity doubleValueForUnit:[HKUnit kilocalorieUnit]];
                }else if (unit == TFQuantityTypeBloodGlucose) {
                    sum4             = [statist.sumQuantity doubleValueForUnit:[HKUnit millimeterOfMercuryUnit]];
                }
                NSDictionary *dic       = @{@"stepCount":@(sum4),
                                            @"startDate":[NSDate TF_getNewTimeFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES] date:statist.startDate] ,
                                            @"endDate":[NSDate TF_getNewTimeFormat:[NSDate TF_ymd_hmsFormatIs24hour:YES] date: statist.endDate]
                                            };
                [array addObject:dic];
            }
            if (queryResultBlock) {
                queryResultBlock(array);
            }
        };
    };
   [[TFHealthManager TF_standardHealthManager].healthStore executeQuery:query];
}

+ (void)TF_getBodyType:(HKSampleType *)sampleType queryResultBlock:(void (^)(NSArray *queryResults))queryResultBlock  {
    NSPredicate *predicate              = [HKQuery predicateForSamplesWithStartDate:nil endDate:nil options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor    = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    HKSampleQuery *sampleQuery          = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
          NSMutableArray *array       = [NSMutableArray array];
        if(!error && results) {
            for(HKQuantitySample *samples in results) {
                NSDictionary *dic       = @{@"stepCount":samples.quantity,
                                            @"startDate":samples.startDate ,
                                            @"endDate":samples.endDate
                                            };
                [array addObject:dic];
            }
        }
        if (queryResultBlock) {
            queryResultBlock(array);
        }
    }];
    [[TFHealthManager TF_standardHealthManager].healthStore executeQuery:sampleQuery];
}
#pragma mark -- 写入数据
+ (void)TF_saveHealthKitDataType:(TFQuantityType )type
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate
                          number:(CGFloat)number
                         success:(void(^)(BOOL isSuccess , NSError *error))block{

    HKUnit *unit;
    HKQuantityType *quantityType;
    if (type == TFQuantityTypeStep) {
        quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        unit = [HKUnit countUnit];
    }
    if (type == TFQuantityTypeWalking) {
         quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
         unit = [HKUnit meterUnit];
    }
    if (type == TFQuantityTypeCycling) {
         quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceCycling];
         unit = [HKUnit meterUnit];
    }
    if (type == TFQuantityTypeSwimming) {
       quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceSwimming];
        unit = [HKUnit meterUnit];
    }
    if (type == TFQuantityTypeHeight) {
        quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
        unit = [HKUnit meterUnit];
    }
    if (type == TFQuantityTypeBodyMass) {
         quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
        unit = [HKUnit gramUnit];
    }
    if (type == TFQuantityTypeActiveEnergyBurned) {
        quantityType =[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
        unit = [HKUnit kilocalorieUnit];
    }
    if (type == TFQuantityTypeBasalEnergyBurned) {
         quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
        unit = [HKUnit kilocalorieUnit];
    }
    if (type == TFQuantityTypeBloodGlucose) {
        quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
         unit = [HKUnit unitFromString:@"mg/dl"];
    }
    if (type == TFQuantityTypeBloodPressureSystolic) {
        quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
        unit = [HKUnit millimeterOfMercuryUnit];
    }
    if (type == TFQuantityTypeBloodPressureDiastolic) {
        quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
        unit = [HKUnit millimeterOfMercuryUnit];
    }
    if (!unit || !quantityType) {
        return ;
    }
    HKQuantity *quantity    = [HKQuantity quantityWithUnit:unit doubleValue:number];
    HKQuantitySample *quantitySample = [HKQuantitySample quantitySampleWithType:quantityType quantity:quantity startDate:startDate endDate:endDate];
    [[TFHealthManager TF_standardHealthManager].healthStore saveObject:quantitySample withCompletion:^(BOOL success, NSError * _Nullable error) {
        block(success, error);
    }];
    
}

@end
