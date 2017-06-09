//
//  HealthKitDetailViewController.m
//  healthKit
//
//  Created by 张永强 on 17/6/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "HealthKitDetailViewController.h"
#import "TFHealthManager.h"
#import "NSDate+TFDate.h"

@interface HealthKitDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *dataShowTextView;
@property (weak, nonatomic) IBOutlet UITextField *whriteTextField;
/**授权类型 */
@property (nonatomic , assign)TFQuantityType  quantityType;

@end

@implementation HealthKitDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title;
    if ([self.type isEqualToString:@"TFQuantityTypeStep"]) {
        title = @"步行";
        self.quantityType = TFQuantityTypeStep;
    }else if ([self.type isEqualToString:@"TFQuantityTypeWalking"]) {
       title = @"跑步 + 步行";
        self.quantityType = TFQuantityTypeWalking;
    }else if ([self.type isEqualToString:@"TFQuantityTypeCycling"]) {
        title = @"骑行";
        self.quantityType = TFQuantityTypeCycling;
    }else if ([self.type isEqualToString:@"TFQuantityTypeSwimming"]) {
        title = @"游泳";
        self.quantityType = TFQuantityTypeSwimming;
    }else if ([self.type isEqualToString:@"TFQuantityTypeHeight"]) {
        title = @"身高";
        self.quantityType = TFQuantityTypeHeight;
    }else if ([self.type isEqualToString:@"TFQuantityTypeBodyMass"]) {
        title = @"体重";
        self.quantityType = TFQuantityTypeBodyMass;
    }else if ([self.type isEqualToString:@"TFQuantityTypeActiveEnergyBurned"]) {
        title = @"活动能量";
        self.quantityType = TFQuantityTypeActiveEnergyBurned;
    }else if ([self.type isEqualToString:@"TFQuantityTypeBasalEnergyBurned"]) {
        title = @"膳食能量";
        self.quantityType = TFQuantityTypeBasalEnergyBurned;
    }else if ([self.type isEqualToString:@"TFQuantityTypeBloodGlucose"]) {
        title = @"血糖";
        self.quantityType = TFQuantityTypeBloodGlucose;
    }else if ([self.type isEqualToString:@"TFQuantityTypeBloodPressureSystolic"]) {
        title = @"收缩压";
        self.quantityType = TFQuantityTypeBloodPressureSystolic;
    }else if ([self.type isEqualToString:@"TFQuantityTypeBloodPressureDiastolic"]) {
        title = @"舒张压";
        self.quantityType = TFQuantityTypeBloodPressureDiastolic;
    }
    self.navigationItem.title = title;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
//授权
- (IBAction)authorization:(id)sender {
    if ([TFHealthManager TF_isHealthDataAvailable]) {
        [TFHealthManager TF_authorizeHealthKitWithType:self.quantityType
                                                result:^(BOOL isAuthorizateSuccess, NSError *error) {
                                                    NSLog(@" success = %d,error =  %@" , isAuthorizateSuccess , error);
                                                }];
    }
}
//读取数据
- (IBAction)readData:(id)sender {
     self.dataShowTextView.text = @"";
    [TFHealthManager TF_getDayHealthWithType:self.quantityType queryResultBlock:^(NSArray *queryResults) {
        for (NSDictionary *dic in queryResults) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 self.dataShowTextView.text = [self.dataShowTextView.text stringByAppendingFormat:@"startDate = %@,endDate = %@ ,count = %@\n",dic[@"startDate"],dic[@"endDate"],dic[@"stepCount"]];
            });
        }
        if (queryResults.count == 0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataShowTextView.text = @"暂无数据";
            });
           
        }
    }];

    
}
//写入数据
- (IBAction)whriteData:(id)sender {
    NSDate *endDate         = [NSDate date];
    NSDate *startDate       = [NSDate TF_dateAfterDate:endDate hour:-3];
    CGFloat num =  [self.whriteTextField.text floatValue];
    if (num <= 0) return;
    //必须都加入收缩压和舒张压，健康数据才会有显示，但是提前最好判断一下数值范围
    [TFHealthManager TF_saveHealthKitDataType:self.quantityType startDate:startDate endDate:endDate number:num success:^(bool isSuccess, NSError *error) {
        NSLog(@"%d" ,isSuccess);
    }];
}


@end
