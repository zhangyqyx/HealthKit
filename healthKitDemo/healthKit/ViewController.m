//
//  ViewController.m
//  healthKit
//
//  Created by 张永强 on 17/5/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "TFHealthManager.h"
#import "NSDate+TFDate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (IBAction)authorizeHealth:(id)sender {
    if ([TFHealthManager TF_isHealthDataAvailable]) {
        [TFHealthManager TF_authorizeHealthKitWithType:
         TFQuantityTypeStep |
         TFQuantityTypeWalking|
         TFQuantityTypeCycling |
         TFQuantityTypeSwimming|
         TFQuantityTypeHeight|
         TFQuantityTypeBodyMass|
         TFQuantityTypeActiveEnergyBurned|
         TFQuantityTypeBasalEnergyBurned |
         TFQuantityTypeBloodGlucose      |
         TFQuantityTypeBloodPressureSystolic|
         TFQuantityTypeBloodPressureDiastolic
                                                result:^(BOOL isAuthorizateSuccess, NSError *error) {
            NSLog(@" success = %d,error =  %@" , isAuthorizateSuccess , error);
        }];
    }
//    [TFHealthManager TF_fetchAllHealthType:TFHealthIntervalUnitMonth queryResultBlock:^(NSArray *queryResults) {
//        for (NSDictionary *dic in queryResults) {
//            NSLog(@"----startDate = %@" ,dic[@"startDate"]);
//            NSLog(@"----endDate = %@" , dic[@"endDate"]);
//            NSLog(@"----count = %@" , dic[@"stepCount"]);
//        }
//    }];
    
    
//    [TFHealthManager TF_fetchAllHealthDataByDay:^(NSArray *modelArray) {
//        for (NSDictionary *dic in modelArray) {
//            NSLog(@"----startDate = %@" ,dic[@"startDate"]);
//            NSLog(@"----endDate = %@" , dic[@"endDate"]);
//            NSLog(@"----count = %@" , dic[@"stepCount"]);
//        }
//    }];
//     [TFHealthManager TF_getAllStepCount:^(NSUInteger stepCount) {
//         NSLog(@"%lu" , (unsigned long)stepCount);
//     }];
//    [TFHealthManager TF_getStepCountWithHourOf0ClockBlock:^(NSArray *queryResults) {
//        NSLog(@"%@" , queryResults);
//    }];
     [TFHealthManager TF_getDayHealthWithType:TFQuantityTypeBloodPressureDiastolic queryResultBlock:^(NSArray *queryResults) {
         NSLog(@"%@" , queryResults);
     }];
//    NSDate *endDate         = [NSDate TF_getCurrentDate];
//    NSDate *startDate       = [NSDate TF_dateAfterDate:endDate day:-1];
//    //必须都加入收缩压和舒张压，健康数据才会有显示，但是提前最好判断一下数值范围
//    [TFHealthManager TF_saveHealthKitDataType:TFQuantityTypeBloodPressureSystolic startDate:startDate endDate:endDate number:45.0f success:^(bool isSuccess, NSError *error) {
//        NSLog(@"%d" ,isSuccess);
//    }];
//    [TFHealthManager TF_saveHealthKitDataType:TFQuantityTypeBloodPressureDiastolic startDate:startDate endDate:endDate number:110.0f success:^(bool isSuccess, NSError *error) {
//        NSLog(@"%d" ,isSuccess);
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
