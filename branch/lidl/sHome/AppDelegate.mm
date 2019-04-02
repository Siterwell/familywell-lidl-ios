//
//  AppDelegate.m
//  sHome
//
//  Created by shaop on 2016/12/5.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "AppDelegate.h"
#import "HekrAPI.h"
#import "UIWindow+Hierarchy.h"
#import "addWifiCell.h"
#import "LoginVC.h"
#import "BaseNC.h"
#import "addGatewayVC.h"
#import "connectWifiVC.h"
#import "NSBundle+Language.h"

#import "GeTuiSdk.h"
#import "JSONHelp.h"
#import "ScyDeviceModel.h"
#import "DeviceModel.h"
#import "DeviceDataBase.h"
#import "VoiceHelp.h"
#import "XMNetInterface/Reachability.h"
#import "AppStatusHelp.h"
#import "DeviceListModel.h"
#import "MyUdp.h"
#import "TestObject.h"
#import "CheckVersionApi.h"
#import "VersionModel.h"
#import "PostControllerApi.h"
//#import "FunSupport.h"
#import <HekrSimpleTcpClient.h>
#import "DeviceListModel.h"
#import "InitVC.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Firebase/Firebase.h>
// iOS10 及以上需导入 UserNotifications.framework

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

//extern NSDictionary * ApiMap;

@interface AppDelegate ()<GeTuiSdkDelegate, FIRMessagingDelegate, UNUserNotificationCenterDelegate, UIAlertViewDelegate>

@property (nonatomic) HekrSimpleTcpClient *tcpClient;

@property (nonatomic) BOOL canShowAlert;
@property (nonatomic, copy) NSString *lastAlertContent;

@property (nonatomic) NSString *devTypeName;
@property (nonatomic) NSString *alarmName;

@end

@implementation AppDelegate
{
    BOOL _isChangeAppStatus;
    NSString *_trackViewURL;
    TestObject *_obj;
    DeviceListModel *_deviceListModel;
}

/**
 报警设备监听
 */
- (void)AlarmDeviceListener{
    NSLog(@"[RYAN] AppDelegate >> AlarmDeviceListener >> ");
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if (model) {
        NSDictionary *dic = @{
                              @"action" : @"devSend",
                              @"params" : @{
                                      @"devTid" : model.devTid,
                                      @"data" : @{
                                              @"cmdId" : @25
                                              }
                                      }
                              };
        @weakify(self)
        if (![[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
            [[Hekr sharedInstance] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
                @strongify(self)
                if (!error) {
                    if (![self.lastAlertContent isEqualToString:data[@"params"][@"data"][@"answer_content"]]) {
                        self.canShowAlert = YES;
                        if (self.canShowAlert == YES) {
                            self.canShowAlert = NO;
                            [self doAlert:data];
                            self.lastAlertContent = data[@"params"][@"data"][@"answer_content"];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.canShowAlert = YES;
                            self.lastAlertContent = nil;
                        });
                    }
                }
            }];
            
        } else {
            [[MyUdp shared] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
                @strongify(self)
                if (!error) {
                    if (![self.lastAlertContent isEqualToString:data[@"params"][@"data"][@"answer_content"]]) {
                        self.canShowAlert = YES;
                        if (self.canShowAlert == YES) {
                            self.canShowAlert = NO;
                            [self doAlert:data];
                            self.lastAlertContent = data[@"params"][@"data"][@"answer_content"];
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            self.canShowAlert = YES;
                            self.lastAlertContent = nil;
                        });
                    }
                }
            }];
        }
    }
}


/**
 告警
 
 @param data 内容
 */
- (void)doAlert:(NSDictionary *)data{
    NSLog(@"[RYAN] AppDelegate >> doAlert >> ");
    
    NSDictionary *dic = data;
    ScyDeviceModel *model = [[ScyDeviceModel alloc] initWithDivicedictionary:dic error:nil];
    
    __block NSString *gatewayId = dic[@"params"][@"devTid"];
    NSString *lastFour = [gatewayId substringWithRange:NSMakeRange(gatewayId.length - 4, 4)];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray *array = [def valueForKey:Devices];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"devTid"] isEqualToString:gatewayId]) {
            if ([obj[@"deviceName"] isEqualToString:@"报警器"]) {
                gatewayId = NSLocalizedString(@"我的家", nil);
            } else {
                gatewayId = obj[@"deviceName"];
            }
        }
    }];
    
    if (model.answer_content.length > 8 && [[model.answer_content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"AD"]) {
        NSString *deviceid = [model.answer_content substringWithRange:NSMakeRange(6, 4)];
        
        deviceid = [NSString stringWithFormat:@"%d",(int)strtoul([deviceid UTF8String],0,16)];
        NSString *deviceName = [model.answer_content substringWithRange:NSMakeRange(10, 4)];
        NSString *deviceStatus = [model.answer_content substringWithRange:NSMakeRange(14, 8)];
        NSString *alarmType = [model.answer_content substringWithRange:NSMakeRange(18, 2)];
        
        DeviceModel *model = [[DeviceModel alloc] init];
        model.device_ID = [deviceid intValue];
        model.device_name = deviceName;
        model.device_status = deviceStatus;
        [[DeviceDataBase sharedDataBase] updateDevice:model];
        
        ItemData *item = [[DeviceDataBase sharedDataBase] selectDevice:deviceid];
        
        if (item) {
            [VoiceHelp playMainBoundAudioWithName:@"phonering"];
            NSString *content;
            if([item.customTitle isEqualToString:@""]){
                content = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(item.title, nil),item.devID];
            }else{
               content = item.customTitle;
            }
            
            self.devTypeName = deviceName;
            self.alarmName = alarmType;
            if ([deviceName isEqualToString:@"0000"]) {
                if([deviceStatus isEqualToString:@"00000000"]){
                    content = NSLocalizedString(@"市电断开", nil);
                }else if([deviceStatus isEqualToString:@"00000001"]){
                    content = NSLocalizedString(@"市电恢复", nil);
                }else if([deviceStatus isEqualToString:@"00000002"]){
                    content = NSLocalizedString(@"电池正常", nil);
                }else if([deviceStatus isEqualToString:@"00000003"]){
                    content = NSLocalizedString(@"电池异常", nil);
                }else if([deviceStatus isEqualToString:@"00000004"]){
                    content = NSLocalizedString(@"老人可能长时间未移动", nil);
                }
            }
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"请注意，%@(%@) 的 %@告警", nil),gatewayId ,lastFour , content] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil),NSLocalizedString(@"静音", nil),nil];
//            alertView.tag = 0;
//            [alertView show];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"请注意，%@(%@) 的 %@告警", nil),gatewayId ,lastFour , content] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"静音", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [VoiceHelp disposeSystemSoundIDWithName:@"phonering"];
                
                //发送静音指令
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                DeviceListModel *devmodel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
                
                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:@"000000"];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
                } failure:^(id data, NSError *error) {
                }];
                
            }]];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        
    } else if (model.answer_content.length > 8 && [[model.answer_content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"AC"]){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"我的情景触发了，请注意", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil),NSLocalizedString(@"静音", nil),nil];
//        [alertView show];
        [VoiceHelp playMainBoundAudioWithName:@"phonering"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"我的情景触发了，请注意", nil)] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"静音", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [VoiceHelp disposeSystemSoundIDWithName:@"phonering"];
            
            //发送静音指令
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *devmodel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            
            PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:@"000000"];
            [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
            } failure:^(id data, NSError *error) {
            }];
            
        }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

static void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"%@\n%@", exception, [exception callStackSymbols]);
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    NSString *lan;
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = [appLanguages objectAtIndex:0];
        if ([languageName containsString:@"zh"]) {
            lan = @"zh";
        } else if ([languageName containsString:@"de"]) {
            lan = @"de";
        } else if ([languageName containsString:@"fr"]) {
            lan = @"fr";
        } else if ([languageName containsString:@"es"]) {
            lan = @"es";
        }else if ([languageName containsString:@"cs"]) {
            lan = @"cs";
        }else if ([languageName containsString:@"it"]) {
            lan = @"it";
        }else if ([languageName containsString:@"nl"]) {
            lan = @"nl";
        }else if ([languageName containsString:@"sl"]) {
            lan = @"sl";
        }else if ([languageName containsString:@"fi"]) {
            lan = @"fi";
        }else {
            lan = @"en";
        }
        [NSBundle setLanguage:lan];
// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlarmDeviceListener) name:@"canListenAlert" object:nil];
//    [AMapServices sharedServices].apiKey =@"220b5789aca2c33b1a1fb608b334d6a8";
    
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"]];
    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    [[Hekr sharedInstance] config:config startPage:nil launchOptions:launchOptions];
    [[Hekr sharedInstance] firstPage];
//    self.tcpClient = [[HekrSimpleTcpClient alloc] init];
//    [self.tcpClient createTcpSocket:@"info.hekr.me" onPort:91 connect:^(HekrSimpleTcpClient *client ,BOOL isConnect) {
//        if (isConnect) {
//            [client writeDict:@{@"action":@"getAppDomain"}];
//        }else{
////            NSLog(@"get domain error:TCP连接不成功");
//            NSString* domain = [[NSUserDefaults standardUserDefaults] objectForKey:@"hekr_domain"];
//            if(domain.length != 0 && [domain containsString:@"hekr"]){
//                ApiMap = @{@"user-openapi.hekr.me":[@"https://user-openapi." stringByAppendingString:domain],
//                           @"user.openapi.hekr.me":[@"https://user-openapi." stringByAppendingString:domain],
//                           @"uaa-openapi.hekr.me":[@"https://uaa-openapi." stringByAppendingString:domain],
//                           @"uaa.openapi.hekr.me":[@"https://uaa-openapi." stringByAppendingString:domain],
//                           @"console-openapi.hekr.me":[@"https://console-openapi." stringByAppendingString:domain]};
//            }else{
//                ApiMap = @{@"user-openapi.hekr.me":@"https://user-openapi.hekreu.me",
//                           @"user.openapi.hekr.me":@"https://user-openapi.hekreu.me",
//                           @"uaa-openapi.hekr.me":@"https://uaa-openapi.hekreu.me",
//                           @"uaa.openapi.hekr.me":@"https://uaa-openapi.hekreu.me",
//                           @"console-openapi.hekr.me":@"https://console-openapi.hekreu.me"};
//            }
//        }
//    } successCallback:^(HekrSimpleTcpClient *client, NSDictionary *data) {
        NSString* domain = @"hekreu.me"; // [[data objectForKey:@"dcInfo"] objectForKey:@"domain"];
    
//        自己本地保存domain的参数
        [[NSUserDefaults standardUserDefaults] setObject:domain forKey:@"hekr_domain"];

        ApiMap = @{@"user-openapi.hekr.me":[@"https://user-openapi." stringByAppendingString:domain],
                   @"user.openapi.hekr.me":[@"https://user-openapi." stringByAppendingString:domain],
                   @"uaa-openapi.hekr.me":[@"https://uaa-openapi." stringByAppendingString:domain],
                   @"uaa.openapi.hekr.me":[@"https://uaa-openapi." stringByAppendingString:domain],
                   @"console-openapi.hekr.me":[@"https://console-openapi." stringByAppendingString:domain]};

        NSLog(@"[RYAN] application >> domain = %@", domain);
//    }];

    
//    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    
    //统一处理一些为数组、集合等对nil插入会引起闪退
    [SYSafeCategory callSafeCategory];
    
    //键盘统一收回处理
    [self configureBoardManager];
    
    //网络监听
//    [self isWiFiConnected];
//    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInterface) name:AFNetworkingReachabilityDidChangeNotification object:nil];//这个可以放在需要侦听的页面
//    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
////        switch (status) {
////            case AFNetworkReachabilityStatusReachableViaWiFi:{
////                NSLog(@"网络通过WIFI连接：%@",@(status));
////                break;
////            }
////        }
////        if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
////            NSLog(@"=====================================================================================================================================================================================");
////        }
//    }];
//    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    [self checkVersion];
    
    //网络摄像头
    [self launchSomething];
//    FunSupport *funSup = [[FunSupport alloc] init];
//    [funSup initSDK];
    
//    NSString *storyboardName = @"Main";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//    self.window.rootViewController = [storyboard instantiateInitialViewController];
    
    InitVC *newViewController = [[InitVC alloc] init];
    self.window.rootViewController = newViewController;
//    [self AlarmDeviceListener];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
//    NSLog(@"[RYAN] AppDelegate > applicationWillResignActive");
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [GeTuiSdk resetBadge];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [GeTuiSdk resetBadge];
    
//    NSLog(@"[RYAN] AppDelegate > applicationWillEnterForeground");
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
//    NSLog(@"[RYAN] AppDelegate > applicationDidBecomeActive");
    
    //++ [RYAN] login again when Home page appear (for checking password changed)
    [self checkUserLoginState];
    //-- [RYAN]
}
- (void)applicationWillTerminate:(UIApplication *)application {
//    [GeTuiSdk resetBadge];
}

- (void)checkUserLoginState {
    WS(ws);
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *username = [config objectForKey:@"UserName"];
    NSString *password = [config objectForKey:@"Password"];
    if([Hekr sharedInstance].user && username.length != 0 && password.length != 0){
        [[Hekr sharedInstance] login:username password:password callbcak:^(id user, NSError *error) {

            if (!error) {
                NSLog(@"[RYAN] login success");
            }else{
                if (error.code == -1011) {
                    [[Hekr sharedInstance] logout];
                    NSLog(@"[RYAN] login failed : password incorrect");
                    
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:NSLocalizedString(@"登出", nil)
                                              message:NSLocalizedString(@"用户名密码错误", nil)
                                              delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
                    
                    alertView.tag = 2;
                    [alertView show];
                    
                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
                    LoginVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
                    BaseNC *nav = [[BaseNC alloc] initWithRootViewController:vc];
//                    self.window.rootViewController =nil;
                    self.window.rootViewController = nav;
                    [self.window makeKeyAndVisible];
                }
            }
        }];
    }
}

- (void)updateInterface {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setObject:NetworkAppStatus forKey:AppStatus];
    
    _deviceListModel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
//    NetworkStatus netStatus = [reachability currentReachabilityStatus];
//    if (netStatus == ReachableViaWiFi) {
        if ([AppStatusHelp getWifiIP].length > 0) {
            _obj = [[TestObject alloc] init];
            @weakify(self)
            [[MyUdp shared] recvTokenObj:_obj Callback:^(id obj, id data, NSError *error) {
                @strongify(self)
                [_obj description];
                [self getDeviceToken:data];
            }];
            //发三次udp
            [[MyUdp shared] sendGetTokenWithDeviceID:_deviceListModel.devTid];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_obj) {
                    [[MyUdp shared] sendGetTokenWithDeviceID:_deviceListModel.devTid];
                }
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_obj) {
                    [[MyUdp shared] sendGetTokenWithDeviceID:_deviceListModel.devTid];
                }
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _obj = nil;
                if (_isChangeAppStatus == YES) {
                    _isChangeAppStatus = NO;
                } else {
                    //进入wifi，但是没有受到消息，表示内网内没有设备，如果此时是内网模式，则进入外网模式
                    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                    //                    [config removeObjectForKey:@"ipV4"];
                    if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]) {
                        //                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:[NSString stringWithFormat:@"进入到外网模式，切换成外网模式"] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
                        //                        alertView.tag = 2;
                        //                        [alertView show];
                        [config setObject:NetworkAppStatus forKey:AppStatus];
                        //                        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>切换成了外网>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//                        NSString *storyboardName = @"Main";
//                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//                        self.window.rootViewController = [storyboard instantiateInitialViewController];
                        
                    }
                }
            });
        }
//    }
//    else {
//
//        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//        //        [config removeObjectForKey:@"ipV4"];
//
//        if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]) {
//            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"进入到外网模式，切换成外网模式",nil)] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//            //            alertView.tag = 2;
//            //            [alertView show];
//        }
//        [config setObject:NetworkAppStatus forKey:AppStatus];
//    }
}

- (void)launchSomething{
    //和对讲有关
    //声音开关
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSError* error;
    
    //切换成扬声器（默认听筒模式声音太小）
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AVAudioSession *audioSession; // get your audio session somehow
//    BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    
}

- (void)checkVersion{

    CheckVersionApi *api = [[CheckVersionApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        VersionModel *model = [[VersionModel alloc] initWithString:request.responseString error:nil];
        if (model.results != nil && ![model.results isKindOfClass:[NSNull class]] && model.results.count != 0){
            VersionResult *resulet = model.results[0];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//            CGFloat f_newVersion = [resulet.version floatValue];
//            CGFloat f_currentVersion = [currentVersion floatValue];
            
            bool needUpdate = [self checkNeedToUpdate:resulet.version curVer:currentVersion];
            if (needUpdate) {
                _trackViewURL = resulet.trackViewUrl;
                UIAlertView* alertview =[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"版本升级",nil) message:[NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"新版本",nil),resulet.version, NSLocalizedString(@"是否升级？",nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"稍后升级",nil) otherButtonTitles:NSLocalizedString(@"马上升级",nil), nil];
                alertview.tag = 4;
                [alertview show];
            }
     }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (BOOL) checkNeedToUpdate:(NSString*)newVer curVer:(NSString*)curVer {
    int newVersion = [self versionStringToInt:newVer];
    int currentVersion = [self versionStringToInt:curVer];
//    NSLog(@"[RYAN] newVersion >> version:%d", newVersion);
//    NSLog(@"[RYAN] currentVersion >> version:%d", currentVersion);
    
    if (newVersion > currentVersion) {
        return true;
    }
    return false;
}

- (int) versionStringToInt:(NSString *) version {
    NSArray *array = [version componentsSeparatedByString:@"."];
//    NSLog(@"[RYAN] version >> major:%@, minor:%@", array[0], array[1]);
    
    int major = [array[0] intValue];
    int minor = [array[1] intValue];
    return major*100 + minor;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [[Hekr sharedInstance] didRegisterUserNotificationSettings:notificationSettings];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"[RYAN] AppDelegate >> didRegisterForRemoteNotificationsWithDeviceToken >> token = %@", token);
    // 向个推服务器注册deviceToken
//    [GeTuiSdk registerDeviceToken:token];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
//    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"[RYAN] AppDelegate >> didReceiveRemoteNotification >> %@", [userInfo description]);
    [[Hekr sharedInstance] didReceiveRemoteNotification:userInfo];
    
    //++ do alert by push notification
    [self showAlert:userInfo];
    //-- do alert by push notification
}

-(void) showAlert:(NSDictionary *)userInfo {
    NSString * apsData = userInfo[@"data"];
    NSData *webData = [apsData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:webData options:0 error:&error];
    NSDictionary *data = @{
                           @"action" : @"devSend",
                           @"msgId" : jsonDict[@"cmdId"],
                           @"params" : @{
                                   @"devTid" : userInfo[@"devTid"],
                                   @"data" : @{
                                           @"cmdId" : jsonDict[@"cmdId"],
                                           @"answer_content" : jsonDict[@"answer_content"]
                                           }
                                   }
                           };
    
    NSLog(@"[RYAN] AppDelegate >> didReceiveRemoteNotification >>  data : %@", data);
    if (![self.lastAlertContent isEqualToString:jsonDict[@"answer_content"]]) {
        self.canShowAlert = YES;
        if (self.canShowAlert == YES) {
            self.canShowAlert = NO;
            [self doAlert:data];
            self.lastAlertContent = jsonDict[@"answer_content"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.canShowAlert = YES;
            self.lastAlertContent = nil;
        });
    }
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[Hekr sharedInstance] openURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark 键盘收回管理
-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField = 60;
    manager.enableAutoToolbar = NO;
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    //收到个推消息
//    NSString *payloadMsg = nil;
//    if (payloadData) {
//        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
//    }
//    
//    NSDictionary *dic = [JSONHelp dictionaryWithJsonString:payloadMsg];
//    
//    if (dic[@"devTid"]!=nil) {
//        
//        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//        DeviceListModel *devmodel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
//        
//        if (![dic[@"devTid"] isEqualToString:devmodel.devTid]&&devmodel!=nil&&![devmodel isEqual:[NSNull null]]){
//            if (![dic[@"devTid"] isEqualToString:self.lastAlert]) {
//                [VoiceHelp playMainBoundAudioWithName:@"phonering"];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"请切换到相应网关", nil),dic[@"devTid"]] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//                alertView.tag = 5;
//                [alertView show];
//            }
//            self.lastAlert = dic[@"devTid"];
//        }
//    }
    
//    ScyDeviceModel *model = [[ScyDeviceModel alloc] initWithDivicedictionary:dic error:nil];
//
//    if (model.answer_content.length > 8 && [[model.answer_content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"AD"]) {
//        NSString *deviceid = [model.answer_content substringWithRange:NSMakeRange(6, 4)];
//
//        deviceid = [NSString stringWithFormat:@"%d",(int)strtoul([deviceid UTF8String],0,16)];
//        ItemData *item = [[DeviceDataBase sharedDataBase] selectDevice:deviceid];
//
//        if (item) {
//            [VoiceHelp playMainBoundAudioWithName:@"phonering"];
            //现在说是不要了。但是不敢删掉，只敢注释
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"请注意，%@告警", nil),NSLocalizedString(item.customTitle, nil)] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil),NSLocalizedString(@"静音", nil),nil];
//            alertView.tag = 0;
//            [alertView show];
//        }
    
//    }else if(model.answer_content.length > 8 && [[model.answer_content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"AC"]){
//        [VoiceHelp playMainBoundAudioWithName:@"phonering"];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"我的情景触发了，请注意", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil),NSLocalizedString(@"静音", nil),nil];
//        alertView.tag = 0;
//        [alertView show];
//    }
    
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
//                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
                                                                       UIRemoteNotificationTypeSound |
                                                                       UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setObject:clientId forKey:AppClientID];
    [config synchronize];
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"[RYAN] FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setObject:fcmToken forKey:AppClientID];
    [config synchronize];
}

#pragma mark - wifi
- (void)isWiFiConnected {
    //添加一个系统通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //初始化
    Reachability *internetReachability=[Reachability reachabilityForInternetConnection];
    //通知添加到Run Loop
    [internetReachability startNotifier];
    [self updateInterfaceWithReachability:internetReachability];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability  {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setObject:NetworkAppStatus forKey:AppStatus];
    
    _deviceListModel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if (netStatus == ReachableViaWiFi) {
        if ([AppStatusHelp getWifiIP].length > 0) {
            _obj = [[TestObject alloc] init];
            @weakify(self)
            [[MyUdp shared] recvTokenObj:_obj Callback:^(id obj, id data, NSError *error) {
                @strongify(self)
                [_obj description];
                [self getDeviceToken:data];
            }];
            //发三次udp
            [[MyUdp shared] sendGetTokenWithDeviceID:_deviceListModel.devTid];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_obj) {
                    [[MyUdp shared] sendGetTokenWithDeviceID:_deviceListModel.devTid];
                }
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_obj) {
                    [[MyUdp shared] sendGetTokenWithDeviceID:_deviceListModel.devTid];
                }
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _obj = nil;
                if (_isChangeAppStatus == YES) {
                    _isChangeAppStatus = NO;
                } else {
                    //进入wifi，但是没有受到消息，表示内网内没有设备，如果此时是内网模式，则进入外网模式
                    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//                    [config removeObjectForKey:@"ipV4"];
                    if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]) {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注意", nil) message:[NSString stringWithFormat:@"进入到外网模式，切换成外网模式"] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//                        alertView.tag = 2;
//                        [alertView show];
                        [config setObject:NetworkAppStatus forKey:AppStatus];
//                        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>切换成了外网>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//                        NSString *storyboardName = @"Main";
//                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//                        self.window.rootViewController = [storyboard instantiateInitialViewController];
                        
                    }
                }
            });
        }
    }
    else {
        
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//        [config removeObjectForKey:@"ipV4"];
        
        if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"进入到外网模式，切换成外网模式",nil)] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//            alertView.tag = 2;
//            [alertView show];
        }
        [config setObject:NetworkAppStatus forKey:AppStatus];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    if (alertView.tag == 0) {
        [VoiceHelp disposeSystemSoundIDWithName:@"phonering"];
        
        if (buttonIndex == 1) {
            
            //发送静音指令
            DeviceListModel *devmodel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            
            if ([devmodel.deviceName isEqualToString:@"复合型烟感"]) {

            }
            
            PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:@"0000000"];
            [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
        }
        
    }else if (alertView.tag == 1 && buttonIndex == 1){
        _isChangeAppStatus = YES;
        [config setObject:IntranetAppStatus forKey:AppStatus];
//        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>切换成了内网>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    }else if (alertView.tag == 2){
        [config setObject:NetworkAppStatus forKey:AppStatus];
//        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>切换成了外网>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    }else if (alertView.tag == 4){
        if (buttonIndex==1)
        {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:_trackViewURL]];
        }
    }
    [config synchronize];
    
//    self.lastAlert = @"";
}


-(void)getDeviceToken:(NSString *)str{
    if([str rangeOfString:@"NAME"].location != NSNotFound)
    {
        NSRange startRange1 = [str rangeOfString:@"NAME:"];
        NSRange endRange1 = [str rangeOfString:@"\n"];
        
        NSString *result1 = [str substringWithRange:NSMakeRange(startRange1.location+5, endRange1.location-(startRange1.location+5))];
        NSString *devTid = result1;
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        if ([devTid isEqualToString:model.devTid]) {
            
            _obj = nil;
            
            if (![[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]) {
                //网内有数据，如果此时app是外网状态，则切换成内网
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"检测到内网内设备，是否进入内网模式", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//                alertView.tag = 1;
//                [alertView show];
                
                //自动切换
                _isChangeAppStatus = YES;
                [config setObject:IntranetAppStatus forKey:AppStatus];
//                NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>切换成了内网>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//                NSString *storyboardName = @"Main";
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//                self.window.rootViewController = [storyboard instantiateInitialViewController];
                
            }else{
                //网内有数据，如果此时app是内网状态，则不变
                _isChangeAppStatus = YES;
            }
        }
    }
}

@end
