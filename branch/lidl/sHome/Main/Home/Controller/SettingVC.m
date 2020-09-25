//
//  SettingVC.m
//  sHome
//
//  Created by shaop on 2016/12/16.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "SettingVC.h"
#import "DeviceDataBase.h"
#import "UINavigationBar+Awesome.h"
#import "LoginVC.h"
#import "addGatewayVC.h"
#import "SceneDataBase.h"
#import "SystemSceneDataBase.h"
#import "LanguageVC.h"
#import "AppDelegate.h"
#import "SettingTableViewCell.h"
#import "DeviceListModel.h"
#import "TimeScenedDataBase.h"
#import "VideoDataBase.h"
#import "WBQRCodeVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"设置", nil);
}
-(void)viewWillAppear:(BOOL)animated{
    if (@available(iOS 13.0, *)) {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
     } else {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
     }
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 0;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;//7; (Mark "Add IPC")
    }else if (section == 1){
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = NSLocalizedString(@"当前网关", nil);
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
                if (model) {
                    cell.subLabel.text = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(model.deviceName, nil),[model.devTid substringWithRange:NSMakeRange(model.devTid.length-4, 4)]];
                }
            }
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"修改密码", nil);
                break;
            case 2:
                cell.textLabel.text = NSLocalizedString(@"网关配置", nil);
                break;
            case 4:
                cell.textLabel.text = NSLocalizedString(@"定位设置", nil);
                break;
            case 5:
                cell.textLabel.text = NSLocalizedString(@"紧急号码", nil);
                break;
//            case 6:
//                cell.textLabel.text = NSLocalizedString(@"新增摄像头", nil);
//                break;

            default:
                break;
        }
        return cell;

    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 1) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            cell.textLabel.text = NSLocalizedString(@"关于", nil);
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:14];

        cell.textLabel.text = NSLocalizedString(@"系统说明书", nil);
        return cell;

    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loginoutCell" forIndexPath:indexPath];
        return cell;

    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section == 0){
        
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"toGateway" sender:nil];
                break;
            case 1:
                [self performSegueWithIdentifier:@"toChangePsd" sender:nil];
                break;
            case 2:
            {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
                addGatewayVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"addGatewayVC"];
                vc.isFromeSeeting = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
                LanguageVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LanguageVC"];
                vc.isSettingVC = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
                [self performSegueWithIdentifier:@"choose" sender:nil];
            
                break;
            case 5:
                [self performSegueWithIdentifier:@"toEmergent" sender:nil];

                break;
//            case 6:
//                //新增摄像头
//                [self performSegueWithIdentifier:@"toChooseConnectType" sender:nil];
//                break;
                

            default:
                break;
        }
        
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"toAbout" sender:nil];
        }else{
                
            NSString *url;
            NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *languageName = [appLanguages objectAtIndex:0];
            if ([languageName containsString:@"de"]) {
                url = @"https://www.elro.eu/de/elro-connects-app-upgrade";
            }else if ([languageName containsString:@"nl"]) {
                url = @"https://www.elro.eu/nl/elro-connects-app-upgrade";
            }else {
                url = @"https://www.elro.eu/en/elro-connects-app-upgrade";
            }
            
                UIApplication *application = [UIApplication sharedApplication];
                NSURL *URL = [NSURL URLWithString:url];
                
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:URL options:@{}
                       completionHandler:^(BOOL success) {
                           //NSLog(@"Open %@: %d",scheme,success);
                       }];
                }
        }
    }
    else{
        
        UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您确定退出账号吗？", nil) preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:nil];
        [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self logoutUser];
        }]];
        
    }
}

- (void)logoutUser {
    MJWeakSelf
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekreu.me":ApiMap[@"user-openapi.hekreu.me"]);
    
    NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
    if ([config objectForKey:AppClientID]) {
        NSDictionary *params = @{@"clientId": [config objectForKey:AppClientID],
                                 @"pushPlatform": @"GETUI"
                                 };
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/user/unbindPushAlias", https] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self logout];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf logoutUser];
        }];
    } else {
        [self logout];
    }
}

- (void)logout{
    //氦氪登出
    [[Hekr sharedInstance] logout];
    //删除NSUserDefaults数据
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    
    [config setObject:[config objectForKey:DeviceInfo] forKey:@"LastDeviceInfo"];
    [config setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"] forKey:@"USERNAMELOGOUT"];
    
    [config removeObjectForKey:DeviceInfo];
    [config removeObjectForKey:UserInfos];
    [config removeObjectForKey:selectSystemItem];
    //删除数据库数据
    [[DeviceDataBase sharedDataBase] deletDevice];
    [[SceneDataBase sharedDataBase] deletAllScene];
    [[SystemSceneDataBase sharedDataBase] deletAllSystemScene];
    [[TimeScenedDataBase sharedDataBase] deletAllTimerScene];
    [[VideoDataBase sharedDataBase] deletAllVideoInfo];
    //删除归档数据
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"] error:nil];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toChangeUserName"]) {
        
    }
}

@end
