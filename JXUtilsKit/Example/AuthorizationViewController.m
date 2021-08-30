//
//  AuthorizationViewController.m
//  JXUtilsKit
//
//  Created by Barnett on 2021/8/3.
//  Copyright © 2021 Barnett. All rights reserved.
//

#import "AuthorizationViewController.h"
#import "JXAuthorizationTool.h"
#import "JXGPSManager.h"
#import "JXPhotoManager.h"

@interface AuthorizationViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArr = @[@"相机权限",
                     @"相册写入权限",
                     @"相册读写权限",
                     @"麦克风权限",
                     @"音乐媒体权限",
                     @"通讯录权限",
                     @"日历权限",
                     @"提醒事项权限",
                     @"语音识别",
                     @"请求使用期间定位",
                     @"请求长期定位",
                     @"临时一次精准定位"];
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
            [JXAuthorizationTool requestAuthorizationType:JXAuthorizationRequestCamera success:^(void) {
                
            } fail:^(JXAuthorizationFailStatus failType, NSError * _Nullable error) {
                
            }];
            
        }
            break;
        case 1:
        {
            [JXPhotoManager requestAuthorizationType:JXPhotoManagerRequest_AddOnly completion:^(JXPhotoManagerAuthorizationStatus status) {
                
            }];
        }
            break;
        case 2:
        {
            [JXPhotoManager requestAuthorizationType:JXPhotoManagerRequest_ReadWrite completion:^(JXPhotoManagerAuthorizationStatus status) {
                            
            }];
        }
            break;
        case 3:
        {
            [JXAuthorizationTool requestAuthorizationType:JXAuthorizationRequestAudio success:^(void) {
                
            } fail:^(JXAuthorizationFailStatus failType, NSError * _Nullable error) {
                
            }];
        }
            break;
        case 4:
        {
            [JXAuthorizationTool requestAuthorizationType:JXAuthorizationRequestMediaLibrary success:^(void) {
                
            } fail:^(JXAuthorizationFailStatus failType, NSError * _Nullable error) {
                
            }];
        }
            break;
        case 5:
        {
            [JXAuthorizationTool requestAuthorizationType:JXAuthorizationRequestContacts success:^(void) {
                
            } fail:^(JXAuthorizationFailStatus failType, NSError * _Nullable error) {
                
            }];
        }
            break;
        case 6:
        {
            [JXAuthorizationTool requestAuthorizationType:JXAuthorizationRequestCalendars success:^(void) {
                
            } fail:^(JXAuthorizationFailStatus failType, NSError * _Nullable error) {
                
            }];
        }
            break;
        case 7:
        {
            [JXAuthorizationTool requestAuthorizationType:JXAuthorizationRequestReminder success:^(void) {
                
            } fail:^(JXAuthorizationFailStatus failType, NSError * _Nullable error) {
                
            }];
        }
            break;
        case 8:
        {
            [JXAuthorizationTool requestAuthorizationType:JXAuthorizationRequestSpeechRecognition success:^(void) {
                
            } fail:^(JXAuthorizationFailStatus failType, NSError * _Nullable error) {
                
            }];
        }
            break;
        case 9:
        {
            [[JXGPSManager sharedInstance] requestLocationServicesWith:JXGPSManagerRequestWhenInUse success:^{
                [[JXGPSManager sharedInstance] updateLocations:^(CLLocationManager * _Nonnull locationManager, NSArray<CLLocation *> * _Nonnull locations) {
                    
                } failError:^(CLLocationManager * _Nonnull locationManager, NSError * _Nonnull error) {
                    
                }];
            } fail:^(JXGPSManagerAuthorizationStatus status) {
                
            }];
        }
            break;
        case 10:
        {
            [[JXGPSManager sharedInstance] requestLocationServicesWith:JXGPSManagerRequestAlways success:^{
                [[JXGPSManager sharedInstance] updateLocations:^(CLLocationManager * _Nonnull locationManager, NSArray<CLLocation *> * _Nonnull locations) {
                    
                } failError:^(CLLocationManager * _Nonnull locationManager, NSError * _Nonnull error) {
                    
                }];
            } fail:^(JXGPSManagerAuthorizationStatus status) {
                
            }];
        }
            break;
        case 11:
        {
            [[JXGPSManager sharedInstance] requestLocationServicesWith:JXGPSManagerRequestWhenInUse success:^{
                if (@available(iOS 14.0, *)) {
                    [[JXGPSManager sharedInstance] requestTemporaryFullAccuracyOnceWith:@"key" completion:^(NSError *error) {
                        NSLog(@"");
                    }];
                } else {
                    // Fallback on earlier versions
                }
            } fail:^(JXGPSManagerAuthorizationStatus status) {
            }];
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
