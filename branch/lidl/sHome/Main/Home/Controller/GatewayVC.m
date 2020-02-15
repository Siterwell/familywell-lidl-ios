//
//  GatewayVC.m
//  sHome
//
//  Created by shaop on 2016/12/17.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "GatewayVC.h"
#import "DeviceListModel.h"
#import "GatewayCell.h"
#import "BaseNC.h"
#import "addGatewayVC.h"
#import "DeviceDataBase.h"
#import "SceneDataBase.h"
#import "SystemSceneDataBase.h"
#import "TimeScenedDataBase.h"
#import "MainDeviceApi.h"
#import "AppDelegate.h"
#import "ChangeGatewaysNameVC.h"
#import "HomeVC.h"
#import "ErrorCodeUtil.h"
@interface GatewayVC ()
@property (strong, nonatomic) DeviceListModel *nowModel;
@property (strong, nonatomic) NSMutableArray *deviceArray;
@property (nonatomic) UIImageView *nilImgV;

@property (nonatomic, copy) NSString *https;

@end

@implementation GatewayVC

- (UIImageView *)nilImgV {
    if (!_nilImgV) {
        _nilImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_empty"]];
        [self.view addSubview:_nilImgV];
        [_nilImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-40);
        }];
    }
    return _nilImgV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.https = (ApiMap==nil?@"https://user-openapi.hekreu.me":ApiMap[@"user-openapi.hekreu.me"]);


}

-(void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device", self.https]
 parameters:@{@"page":@(0),@"size":@(5)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject;
        if (arr.count>0) {
            _deviceArray = [arr mutableCopy];
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            
            for (int i = 0; i<arr.count; i++) {
                if ([[arr[i] objectForKey:@"devTid"] isEqualToString:_nowModel.devTid] && [[arr[i] objectForKey:@"ctrlKey"] isEqualToString:_nowModel.ctrlKey] && [[arr[i] objectForKey:@"bindKey"] isEqualToString:_nowModel.bindKey]) {
                    [config setValue:arr[i] forKey:DeviceInfo];
                }
            }
            
            
            [config setValue:arr forKey:Devices];
            [config synchronize];
            self.nilImgV.hidden = YES;
            [self.tableView reloadData];
        }else{
            self.nilImgV.hidden = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
    }];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    _nowModel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deviceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GatewayCell" forIndexPath:indexPath];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:_deviceArray[indexPath.row] error:nil];
    cell.nameTitle.text = NSLocalizedString(model.deviceName, nil);
    cell.titleLabel.text = model.devTid;
    if ([model.devTid isEqualToString:self.nowModel.devTid] && [model.ctrlKey isEqualToString:self.nowModel.ctrlKey] && [model.bindKey isEqualToString:self.nowModel.bindKey]) {
        cell.clickImage.hidden = NO;
    }else{
        cell.clickImage.hidden = YES;
    }
    
    
    //获取设备信息，查看是否在线
    if ([model.online isEqualToString:@"1"]) {
        cell.subTitleLabel.text = @"online";
    }else{
        cell.subTitleLabel.text = @"offline";
    }
    return cell;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"解绑", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        [self deleteAction:indexPath];
    }];
    
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"修改名字", nil)handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:_deviceArray[indexPath.row] error:nil];

        [self performSegueWithIdentifier:@"toChangeGateName" sender:model];
    }];
    return @[deleteRowAction,topRowAction];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    flag_checkfireware = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *smodel = [[DeviceListModel alloc] initWithDictionary:_deviceArray[indexPath.row] error:nil];
    [config setObject:_deviceArray[indexPath.row] forKey:DeviceInfo];
    [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"网关修改为:%@", nil),smodel.devTid] ToView:self.view];
    //清空NSUD数据
    [config synchronize];
    
    //进入外网模式
//    [config removeObjectForKey:@"ipV4"];
    [config setObject:NetworkAppStatus forKey:AppStatus];

    //清空数据信息
    [[DeviceDataBase sharedDataBase] deletDevice];
    [[SceneDataBase sharedDataBase] deletAllScene];
    [[SystemSceneDataBase sharedDataBase] deletAllSystemScene];
    [[TimeScenedDataBase sharedDataBase] deletAllTimerScene];
    //清空归档数据
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"] error:nil];
//    [self requestDevice:smodel];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

-(void)deleteAction:(NSIndexPath *)indexPath {
    UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您确定删除该设备吗？", nil) preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVc animated:YES completion:nil];
    
    //弹出框确认
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:_deviceArray[indexPath.row] error:nil];

//        NSString *url = [NSString stringWithFormat:@"http://user.openapi.hekreu.me/device/%@",model.devTid];
        NSString *url = [NSString stringWithFormat:@"%@/device/%@", self.https, model.devTid];

        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] DELETE:url parameters:@{@"bindKey":model.bindKey} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setObject:_deviceArray forKey:Devices];
            [self.deviceArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            //如果目前设备删除后只剩一个了，那就重新添加设备
            if (_deviceArray.count == 0) {
                
                //清空数据库信息，本地数据信息，重制设备获取接口。
                //清空NSUD数据
                [config removeObjectForKey:DeviceInfo];
                [config synchronize];
                //清空数据信息
                [[DeviceDataBase sharedDataBase] deletDevice];
                [[SceneDataBase sharedDataBase] deletAllScene];
                [[SystemSceneDataBase sharedDataBase] deletAllSystemScene];
                [[TimeScenedDataBase sharedDataBase] deletAllTimerScene];
                //切换成外网模式
//                [config removeObjectForKey:@"ipV4"];
                [config setObject:NetworkAppStatus forKey:AppStatus];

                //清空归档数据
                [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"] error:nil];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSString *storyboardName = @"Main";
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                delegate.window.rootViewController = [storyboard instantiateInitialViewController];
                return ;
            }
            //判读是否是当前使用的网关，如果是的，那就切换为另一个，如果不是则不做判断。
            if ([model.devTid isEqualToString:_nowModel.devTid]) {
                flag_checkfireware = NO;
                [config setObject:_deviceArray[0] forKey:DeviceInfo];
                DeviceListModel *smodel = [[DeviceListModel alloc] initWithDictionary:_deviceArray[0] error:nil];
                [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"网关修改为:%@", nil),smodel.devTid] ToView:self.view];
                //清空数据库信息，本地数据信息，重制设备获取接口。
                //清空NSUD数据
                [config synchronize];
                //清空数据信息
                [[DeviceDataBase sharedDataBase] deletDevice];
                [[SceneDataBase sharedDataBase] deletAllScene];
                [[SystemSceneDataBase sharedDataBase] deletAllSystemScene];
                [[TimeScenedDataBase sharedDataBase] deletAllTimerScene];
                //进入外网模式
//                [config removeObjectForKey:@"ipV4"];
                [config setObject:NetworkAppStatus forKey:AppStatus];
                //清空归档数据
                [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"] error:nil];
                [self requestDevice:smodel];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSString *storyboardName = @"Main";
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
                delegate.window.rootViewController = [storyboard instantiateInitialViewController];

            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
            [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
        }];
        
        
    }]];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];

}

- (void)requestDevice:(DeviceListModel *)model{
    MainDeviceApi *api = [[MainDeviceApi alloc] initWithDrivce:model.devTid andCtrlKey:model.ctrlKey];
    [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
    } failure:^(id data, NSError *error) {
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DeviceListModel *model = sender;
    
    ChangeGatewaysNameVC *vc = segue.destinationViewController;
    vc.model = model;
    
}
@end
