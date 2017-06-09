//
//  ViewController.m
//  healthKit
//
//  Created by 张永强 on 17/5/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"

#import "HealthKitDetailViewController.h"

@interface ViewController ()<UITableViewDelegate , UITableViewDataSource>

/**数据列表 */
@property (nonatomic , strong)NSArray *list;

@end

@implementation ViewController

- (NSArray *)list {
    if (!_list) {
        _list = @[@"TFQuantityTypeStep",
                  @"TFQuantityTypeWalking",
                  @"TFQuantityTypeCycling",
                  @"TFQuantityTypeSwimming",
                  @"TFQuantityTypeHeight",
                  @"TFQuantityTypeBodyMass",
                  @"TFQuantityTypeActiveEnergyBurned",
                  @"TFQuantityTypeBasalEnergyBurned",
                  @"TFQuantityTypeBloodGlucose",
                  @"TFQuantityTypeBloodPressureSystolic",
                  @"TFQuantityTypeBloodPressureDiastolic"];
    }
    return _list;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.frame = self.view.frame;
    [self.view addSubview:tableView];
}

- (IBAction)authorizeHealth:(id)sender {

//    [TFHealthManager TF_fetchAllHealthType:TFHealthIntervalUnitMonth queryResultBlock:^(NSArray *queryResults) {
//        for (NSDictionary *dic in queryResults) {
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
//     [TFHealthManager TF_getDayHealthWithType:TFQuantityTypeBloodPressureDiastolic queryResultBlock:^(NSArray *queryResults) {
//         NSLog(@"%@" , queryResults);
//     }];
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
#pragma mark --UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.list[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthKitDetailViewController *nextVc = [[HealthKitDetailViewController alloc] init];
    nextVc.type = self.list[indexPath.row];
    [self.navigationController pushViewController:nextVc animated:YES];
}

@end
