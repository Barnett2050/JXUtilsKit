//
//  HealthViewController.m
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/10.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import "HealthViewController.h"
#import "JXHealthTool.h"
@interface HealthViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation HealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = @[@"请求授权",
                     @"获取步数"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            HKObjectType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            NSSet *healthSet = [NSSet setWithObjects:stepType, nil];
            [[JXHealthTool sharedInstance] requestHealthAuthorizationWithShareTypes:nil readTypes:healthSet completion:^(JXHealthToolStatus status, NSSet * _Nonnull deniedShareSet, NSError * _Nonnull error) {
            }];
        }
            break;
        case 1:
        {
            [[JXHealthTool sharedInstance] getStepCount:^(double stepCount, NSError * _Nonnull error) {
                NSLog(@"步数：%f --- 错误：%@",stepCount,error);
            }];
        }
            break;
        
            break;
        default:
            break;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


@end
