//
//  AddCameraVc.m
//  sHome
//
//  Created by Apple on 2017/6/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AddCameraVc.h"
#import "NetworkAssistant.h"
#import "NSSDKAPConfigModel.h"
#import "VideoLiveViewController.h"
#import "NSArray+JSONString.h"
#import "NSString+ArryValue.h"
#import "VideoDataBase.h"

@interface AddCameraVc ()<NSSDKAPConfigModelDelegate>

@property   (nonatomic ,strong) NSSDKAPConfigModel *apConfigModel;

@property (nonatomic, copy) NSString *https;

@end

@implementation AddCameraVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);

    // Do any additional setup after loading the view.
    self.ssidName.text = [NETWORKER getCurrentPhoneWifiSSID] ==nil||[[NETWORKER getCurrentPhoneWifiSSID] isEqual:[NSNull null]]?@"":[NETWORKER getCurrentPhoneWifiSSID];
    if(_type_qiang){
            self.title = NSLocalizedString(@"无线设置", nil);
    }else{
        self.title = NSLocalizedString(@"新增摄像头", nil);
    }

    [_wifiBtn setTitleColor:ThemeColor forState:UIControlStateNormal];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"camera+%@", self.ssidName.text]];
    if (pwd != nil && pwd.length != 0) {
        self.wifiPwd.text = pwd;
    }
    
    
}
- (IBAction)configWifi:(id)sender {
    NSLog(@"[RYAN] AddCameraVc > configWifi");
    
    //开始快速配置
    [self.view endEditing:YES];
    
    if (self.wifiPwd.text.length == 0) {
        [MBProgressHUD showMessage:NSLocalizedString(@"密码长度错误", nil) ToView:self.view RemainTime:1.5f];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.wifiPwd.text forKey:[NSString stringWithFormat:@"camera+%@", self.ssidName.text]];
    
    _apConfigModel = [self apConfigModela];
//    [_apConfigModel stopConfig];
    [MBProgressHUD showMessage:NSLocalizedString(@"请稍后...", nil) ToView:self.view];
    [_apConfigModel starAPConfigWithSSID:self.ssidName.text password:self.wifiPwd.text];
    
    if (_type_qiang) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showTimeoutFail) object:nil];
        [self performSelector:@selector(showTimeoutFail) withObject:nil afterDelay:90.0];
    }
}

- (void) showTimeoutFail {
    NSLog(@"[RYAN] AddCameraVc > showTimeout");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:NSLocalizedString(@"配置失败", nil) ToView:GetWindow];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_apConfigModel stopConfig];
}

-(NSSDKAPConfigModel *)apConfigModela{
    if (!_apConfigModel) {
        _apConfigModel = [[NSSDKAPConfigModel alloc]init];
        _apConfigModel.apConfigDelegate = self;
    }
    return _apConfigModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSSDKAPConfigModelDelegate
-(void)APDevice:(NSString*)name DevSn:(NSString*)sn deviceType:(int)type configResult:(int)result{
    
    if (sn!=nil&&![sn isEqual:[NSNull null]]&&[sn isKindOfClass:[NSString class]]&&result==244) {
        
        
        if(!_type_qiang){

            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            NSDictionary *responseObject = [config objectForKey:UserInfos];
            
            NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
            
            NSMutableArray *videos = nil;
            
            if (extraPropertiesDic[@"monitor"] !=nil) {
                
                videos = [[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
            }else{
                videos = [[NSMutableArray alloc] init];
            }
            
            [videos addObject:@{@"devid":sn,@"name":name}];
            
            //        VideoInfoModel *localVInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:sn];
            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
            VideoInfoModel *localVInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:sn andUserName:userName];
            
            if (localVInfo == nil||localVInfo.devid == nil||[localVInfo.devid isEqual:[NSNull class]]) {
                NSString *monitorStr = [videos JSONString];
                
                //修改昵称
                NSDictionary *monitorDic = @{@"monitor":monitorStr};
                NSDictionary *dic = @{
                                      @"extraProperties" : monitorDic,
                                      };
                
                [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"%@/user/profile", self.https] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [MBProgressHUD showSuccess:NSLocalizedString(@"配置成功", nil) ToView:self.view];
                    
                    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile", self.https] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                        [config setValue:responseObject forKey:UserInfos];
                        [config synchronize];
                        
                        NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
                        
                        if (extraPropertiesDic[@"monitor"] !=nil) {
                            
                            NSMutableArray *monitor = [(NSArray*)[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
                            
                            for (int i = 0; i < [monitor count]; i++) {
                                
                                NSDictionary *videoDic = (NSDictionary *)monitor[i];
                                VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
                                vInfo.devid = videoDic[@"devid"];
                                vInfo.name = videoDic[@"name"];
                                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
                                vInfo.userName = userName;
                                [[VideoDataBase sharedDataBase] updateVideoInfo:vInfo];
                            }
                        }
                        
                        //                    VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
                        //                    vInfo.devid = sn;
                        //                    vInfo.name = name;
                        //
                        //                    VideoLiveViewController *videoLive = [[VideoLiveViewController alloc] init];
                        //                    videoLive.vInfo = vInfo;
                        //                    [self.navigationController pushViewController:videoLive animated:YES];
                        
                        [MBProgressHUD showSuccess:NSLocalizedString(@"配置成功", nil) ToView:self.view];
                        [self performSelector:@selector(popPreView) withObject:nil afterDelay:2];
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [MBProgressHUD showError:NSLocalizedString(@"配置失败", nil) ToView:GetWindow];
                    }];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showError:NSLocalizedString(@"配置失败", nil) ToView:GetWindow];
                }];
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showSuccess:NSLocalizedString(@"连上WIFI，但已添加", nil) ToView:GetWindow];
                [self performSelector:@selector(popPreView) withObject:nil afterDelay:2];
                
            }
            
        }else{
            [MBProgressHUD showSuccess:NSLocalizedString(@"配置成功", nil) ToView:GetWindow];
            [self.navigationController popViewControllerAnimated:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showTimeoutFail) object:nil];
        }
            
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:NSLocalizedString(@"配置失败", nil) ToView:GetWindow];
        }
        

}

- (void)popPreView{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
