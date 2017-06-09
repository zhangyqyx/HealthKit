//
//  TFHealthManager.h
//  healthKit
//
//  Created by 张永强 on 17/5/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

typedef NS_ENUM(NSUInteger , TFQuantityType){
   TFQuantityTypeStep                   = 1 << 0, //步行
   TFQuantityTypeWalking                = 1 << 1,//跑步 + 步行
   TFQuantityTypeCycling                = 1 << 2,//骑行
   TFQuantityTypeSwimming               = 1 << 3,//游泳
   TFQuantityTypeHeight                 = 1 << 4,//身高
   TFQuantityTypeBodyMass               = 1 << 5 ,//体重
   TFQuantityTypeActiveEnergyBurned     = 1 << 6,//活动能量
   TFQuantityTypeBasalEnergyBurned      = 1 << 7,//膳食能量
   TFQuantityTypeBloodGlucose           = 1 << 8,//血糖
   TFQuantityTypeBloodPressureSystolic  = 1 << 9, // 收缩压
   TFQuantityTypeBloodPressureDiastolic = 1 << 10 //舒张压
};

typedef NS_ENUM(NSUInteger, TFHealthIntervalUnit) {
    TFHealthIntervalUnitDay,
    TFHealthIntervalUnitWeek,
    TFHealthIntervalUnitMonth,
    TFHealthIntervalUnitYear
};



@interface TFHealthManager : NSObject
+ (instancetype)TF_standardHealthManager;

/**
 *  判断设备是否支持健康应用
 *
 *  @return YES 支持  NO 不支持
 */
+ (BOOL)TF_isHealthDataAvailable;

/**
 判断是否授权分享数据
 @param type 设备类型
 @return 是否授权
 */
+ (BOOL)TF_isAuthorizationStatusForType:(HKObjectType *)type;


/**
 应用授权
 @param type 授权类型
 @param resultBlock 结果
 */
+ (void)TF_authorizeHealthKitWithType:(TFQuantityType)type
                               result:(void(^)(BOOL isAuthorizateSuccess ,NSError *error))resultBlock;
/**
 *  获得当天获取所有健康数据 (一个小时一次统计)  startDate:开始时间key 、endDate:结束时间key 、stepCount步数key
 */
+ (void)TF_fetchAllHealthDataByDay:(void (^)(NSArray *modelArray))queryResultBlock;
/**
 获得当天的所有步数
 */
+ (void)TF_getAllStepCount:(void(^)(NSUInteger stepCount))stepCountBlock;

/**
 获取健康应用步数信息
 @param unit 数据段类型
 @param queryResultBlock 返回数据 
 */
+ (void)TF_fetchAllHealthType:(TFHealthIntervalUnit)unit
             queryResultBlock:(void (^)(NSArray *queryResults))queryResultBlock;
/**
 获取健康应用步数信息
 @param startDate 开始时间
 @param endDate 结束时间
 @param hComponents NSDateComponents   例如： hComponents = [calendar components:NSCalendarUnitHour fromDate:endDate];  [hComponents setHour:1];  是每个小时统计一次
 @param queryResultBlock 返回数据
 */
+ (void)TF_fetchAllHealthStartDate:(NSDate *)startDate
                           endDate:(NSDate *)endDate
                       hComponents:(NSDateComponents *)hComponents
                  queryResultBlock:(void (^)(NSArray *queryResults))queryResultBlock;

#pragma mark -- 获取12点到现在的数据
/**
 获得今天0点到现在每个小时的步数
 @param queryResultBlock 返回结果
 */
+ (void)TF_getStepCountWithHourOf0ClockBlock:(void (^)(NSArray *queryResults))queryResultBlock;

#pragma mark -- 获取当天的数据

/**
 获取当天的数据
 @param unit 数据段类型
 @param queryResultBlock 返回数据
 */
+ (void)TF_getDayHealthWithType:(TFQuantityType)unit
               queryResultBlock:(void (^)(NSArray *queryResults))queryResultBlock;


#pragma mark -- 写入数据

/**
 保存healthKit数据

 @param type 要保存的类型
 @param startDate 开始时间
 @param endDate 结束时间
 @param number 数值
 @param block 是否成功回调
 */
+ (void)TF_saveHealthKitDataType:(TFQuantityType )type
                       startDate:(NSDate *)startDate
                         endDate:(NSDate *)endDate
                          number:(CGFloat)number
                         success:(void(^)(BOOL isSuccess , NSError *error))block;
@end
