//
//  SuccessVC.m
//  sHome
//
//  Created by shaop on 2017/1/12.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SuccessVC.h"
#import "SuccessView.h"
#import "DeviceDataBase.h"
#import "SceneDataBase.h"
#import "SystemSceneDataBase.h"
#import "TimeScenedDataBase.h"
#import "AppDelegate.h"
#import "HomeVC.h"
@interface SuccessVC ()

@end

@implementation SuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    SuccessView *suc = [[SuccessView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    suc.center = self.view.center;
    [self.view addSubview:suc];
    //获取设备列表。
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
    flag_checkfireware = NO;
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device", https]
 parameters:@{@"page":@(0),@"size":@(10)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject;
        if (arr.count>0) {
            NSArray *arr = responseObject;
            
            NSMutableSet *dcs = [NSMutableSet set];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *connectHost = [[obj objectForKey:@"dcInfo"] objectForKey:@"connectHost"];
                [dcs addObject:connectHost == nil ? @"hub.hekr.me": connectHost];
            }];
            [[Hekr sharedInstance] setCloudControlWithGlobals:dcs.allObjects];
            
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            
            //删除NSUserDefaults数据
            [config removeObjectForKey:DeviceInfo];
            [config removeObjectForKey:selectSystemItem];
            //删除数据库数据
            [[DeviceDataBase sharedDataBase] deletDevice];
            [[SceneDataBase sharedDataBase] deletAllScene];
            [[SystemSceneDataBase sharedDataBase] deletAllSystemScene];
            [[TimeScenedDataBase sharedDataBase] deletAllTimerScene];
            //删除归档数据
            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"] error:nil];
            
            int x = 0;
            
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                NSString *devTid = dic[@"devTid"];
                if ([devTid isEqualToString:self.deviceName]) {
                    x = i;
                }
            }
            
            [config setValue:arr forKey:Devices];
            [config setValue:arr[x] forKey:DeviceInfo];
            [config synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginUser" object:nil];
            //储存设备
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0* NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                if (_isFromeSeeting) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    NSString *storyboardName = @"Main";
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
                }else{
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }else{
            [self performSegueWithIdentifier:@"toAddGateway" sender:nil];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:NSLocalizedString(@"网络错误",nil) ToView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
