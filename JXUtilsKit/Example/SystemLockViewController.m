//
//  SystemLockViewController.m
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/9.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import "SystemLockViewController.h"
#import "JXSystemLockTool.h"

@interface SystemLockViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation SystemLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = @[@"系统锁定类型",
                     @"生物锁定验证",
                     @"生物锁定和密码验证",
                     @""];
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
            NSLog(@"系统锁定类型：%ld",[JXSystemLockTool sharedInstance].lockSupportType);
        }
            break;
        case 1:
        {
            [[JXSystemLockTool sharedInstance] showSystemBiometricsLockWithDescribe:@"验证已有面容" success:^{
                NSLog(@"成功");
            } fail:^(JXSystemLockFailState failType) {
                NSLog(@"失败：%ld",failType);
            }];
        }
            break;
        case 2:
        {
            [[JXSystemLockTool sharedInstance] showSystemLockWithDescribe:@"验证已有面容" fallbackTitle:nil success:^{
                NSLog(@"成功");
            } fail:^(JXSystemLockFailState failType) {
                NSLog(@"失败：%ld",failType);
            }];
        }
            break;
        case 3:
        {
        }
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
