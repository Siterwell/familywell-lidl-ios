//
//  HomeVC.m
//  sHome
//
//  Created by shaop on 2016/12/13.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "HomeVC.h"
#import "HomeHeadView.h"
#import "SettingVC.h"
#import "UINavigationBar+Awesome.h"
#import "POP.h"
#import "HekrSDk.h"
#import "LoginVC.h"
#import "BaseNC.h"
#import "DeviceListModel.h"
#import "ScyDeviceModel.h"
#import "HekrAlarmModel.h"
#import "WeatherApi.h"
#import "AirApi.h"
#import "DeviceModel.h"
#import "YTKBatchRequest.h"
#import "addGatewayVC.h"
#import "ScynDeviceApi.h"
#import "GetAlarmsApi.h"
//#import "UploadTimeApi.h"
#import "DeviceDataBase.h"
#import "BatterHelp.h"
#import "VoiceHelp.h"
#import "MyUdp.h"
#import "CircleMenuVc.h"
#import "SystemSceneDataBase.h"
#import "AutoScrollLabel.h"
#import "PostControllerApi.h"
#import "TestObject.h"
#import "ChooseSystemSceneApi.h"
#import "NSString+ArryValue.h"
#import "VideoLiveViewController.h"
#import "VideoInfoModel.h"
#import "VideoDataBase.h"
#import <CoreLocation/CoreLocation.h>
#import "CYNetManager.h"
#import "HKNetManager.h"
#import "WarningListViewController.h"
#import "GatewayVC.h"
#import "NSString+CYTime.h"
#import "UserInfoModel.h"
#import "EditEmergentPhoneVC.h"
#import "GatewayVersionModel.h"
#import "UpdateDeviceApi.h"
#import "CYMarquee.h"
#import "LEEAlert.h"
#import "Encryptools.h"
#import "SceneDataBase.h"
#import "UploadTimeApi.h"
#import "AppStatusHelp.h"
#import "JhDownProgressController.h"
BOOL flag_checkfireware = NO;
@interface HomeVC ()<UIAlertViewDelegate,HomeHeadViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *addressView;
@property (strong, nonatomic) IBOutlet HomeHeadView *imageView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic) CLLocationManager *locationMgr;

@property (strong, nonatomic) IBOutlet UILabel *weatherLabel1;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel2;
@property (strong, nonatomic) IBOutlet UILabel *weatherLabel3;
@property (strong, nonatomic) IBOutlet UIImageView *homeSystemSceneImageView;
@property (weak, nonatomic) IBOutlet UILabel *sceneName;
@property (weak, nonatomic) IBOutlet UIView *sceneView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@property (strong, nonatomic) DeviceListModel *model;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) CircleMenuVc *menuVc;
@property (strong, nonatomic) NSArray *systemSceneListArray;
@property (strong, nonatomic) AutoScrollLabel *autoLbe;

//
//@property (assign, nonatomic) BOOL isShowAlert;
//@property (nonatomic) NSString *lastAlert;

@property (nonatomic) NSString *devTypeName;
@property (nonatomic) NSString *alarmName;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic) UIButton *titleView;

@property (nonatomic) CYMarquee *marquee;

@property (weak, nonatomic) IBOutlet UIImageView *headBg;

@property (nonatomic) NSMutableArray<ItemData *> *tempHumArray;

@property (nonatomic) BOOL canShowAlert;
@property (nonatomic, copy) NSString *lastAlertContent;
@property (nonatomic,assign) NSString *versionCode;
@property (nonatomic) GatewayVersionModel *verModel;
@property (strong,nonatomic) JhDownProgressController *vc;
@end

@implementation HomeVC
{
    CGPoint _bottomPoint;
    CGPoint _beginPoint;
    CGFloat _tableHeight;
    NSString *_city;
    BOOL _isTableTop;
    BOOL _isRow;
    TestObject *_obj;
}


- (UIButton *)titleView {
    if (!_titleView) {
        _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleView setBackgroundColor:[UIColor clearColor]];
        [self.navigationController.navigationBar addSubview:_titleView];
        [_titleView addTarget:self action:@selector(selectGateWays) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *pin = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(nettest)];
        pin.minimumPressDuration =1.0;
        [_titleView addGestureRecognizer:pin];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.centerX.equalTo(0);
            make.width.equalTo(200);
            make.height.equalTo(44);
        }];
    }
    return _titleView;
}

- (void)selectGateWays {
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
    GatewayVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GatewayVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getDeviceToken:(NSString *)str{
    if(![MyUdp shared].flag_en){
        if([str rangeOfString:@"NAME"].location != NSNotFound) {
            NSRange startRange1 = [str rangeOfString:@"NAME:"];
            NSRange endRange1 = [str rangeOfString:@"\n"];
            
            NSString *result1 = [str substringWithRange:NSMakeRange(startRange1.location+5, endRange1.location-(startRange1.location+5))];
            NSString *devTid = result1;
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            if ([devTid isEqualToString:model.devTid]) {
                _obj = nil;
                if (![[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]) {
                    //                //网内有数据，如果此时app是外网状态，则切换成内网
                    //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"检测到内网内设备，是否进入内网模式", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
                    //                alertView.tag = 1;
                    //                [alertView show];
                    
                    //自动切换
                    [config setObject:IntranetAppStatus forKey:AppStatus];
                    
                }
            }
        }
    }else{
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableLeaves
                                                              error:nil];
        NSString *devTid = dic[@"NAME"];
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        if ([devTid isEqualToString:model.devTid]) {
            _obj = nil;
            if (![[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]) {
                //                //网内有数据，如果此时app是外网状态，则切换成内网
                //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:[NSString stringWithFormat:NSLocalizedString(@"检测到内网内设备，是否进入内网模式", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
                //                alertView.tag = 1;
                //                [alertView show];
                
                //自动切换
                [config setObject:IntranetAppStatus forKey:AppStatus];
                
            }
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"[RYAN] HomeVC > viewDidLoad 1111");
    
//    self.isShowAlert = YES;
//    self.canShowAlert = YES;
    self.title = NSLocalizedString(@"首页", nil);
    [self titleView];
    //获取登陆通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocation) name:@"loginUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData) name:@"updateDeviceSuccess" object:nil];

    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    _model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"canListenAlert" object:nil userInfo:nil];
    
    /**
     *  发送IOT_KEY?+devTid，重发策略是：1秒3次；如果发现选定的网关在内网中，则转内网，否则转外网；
     */
//    _obj = [[TestObject alloc] init];
//    @weakify(self)
//    [[MyUdp shared] recvTokenObj:_obj Callback:^(id obj, id data, NSError *error) {
//        @strongify(self)
//        [_obj description];
//        [self getDeviceToken:data];
//    }];
//    //发三次udp
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (_obj) {
//            [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
//        }
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (_obj) {
//            [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
//        }
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (_obj) {
//            [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
//            _obj = nil;
//        }
//    });
    NSString *username = [config objectForKey:@"UserName"];
    NSString *password = [config objectForKey:@"Password"];
    //判断登陆状态
    if (![Hekr sharedInstance].user || username.length == 0 || password.length == 0) {
        //未登录
        [[Hekr sharedInstance] logout];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
        LoginVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LoginVC"];
        BaseNC *nav = [[BaseNC alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
//    }else if(_model == nil){
//        //没有设备
//        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//        addGatewayVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"addGatewayVC"];
//        BaseNC *nav = [[BaseNC alloc] initWithRootViewController:vc];
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
        //正常情况
        [self getLocation];
    }
    
    [self setView];
    //设置右上角的设置图标
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(setting) image:@"setting_icon" highImage:@"setting_icon" withTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];

    
    _sceneView.layer.cornerRadius = 60.0f/2;
    _sceneView.clipsToBounds = YES;
    [_sceneView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCircleMenu)]];
    _sceneView.userInteractionEnabled = YES;
    
    self.imageView.delegate = self;
    self.imageView.subVC = self;
    
    //紧急号码弹框
    
    NSString *nowTime = [NSString cy_getCurrentDateTransformTimeStamp];
    NSString *oldTime = [config objectForKey:@"onceAWeek"];
    if (oldTime != nil) {
        if (([nowTime longLongValue] - [oldTime longLongValue] >= 86400 * 7)) {
            [self alertConfigPhone];
        }
    }
    else {
        [self alertConfigPhone];
    }
    
    [self checkLanguageForBindGT];
}

- (void)checkLanguageForBindGT {
    WS(ws)
    
//    NSLog(@"[RYAN] HomeVC > checkLanguageForBindGT");
    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
//    NSLog(@"[RYAN] HomeVC > checkLanguage 222 > appLanguages : %@", languageName);
    
    NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
    NSString *language = [config stringForKey:CurrentLanguage];
//    NSLog(@"[RYAN] HomeVC > checkLanguage 111 > language : %@", language);
    
    if (language == nil || ![language isEqualToString:languageName]) {
//        NSLog(@"[RYAN] need to update");
        [config setValue:languageName forKey:CurrentLanguage];
        [ws bindGTId:languageName];
    }
}

- (void)bindGTId:(NSString*)languageName {
    MJWeakSelf
    NSString* lan;
    if ([languageName containsString:@"zh"]) {
        lan = @"zh";
    } else if ([languageName containsString:@"de"]) {
        lan = @"de";
    } else if ([languageName containsString:@"fr"]) {
        lan = @"fr";
    } else if ([languageName containsString:@"es"]) {
        lan = @"es";
    }else {
        lan = @"en";
    }
    
    NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
    [config setValue:languageName forKey:CurrentLanguage];
    
    if ([config objectForKey:AppClientID]) {
        NSDictionary *dic = @{
                              @"clientId" : [config objectForKey:AppClientID],
                              @"pushPlatform" : @"FCM",
                              @"locale" : lan
                              };
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/user/pushTagBind", (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"])] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"绑定成功！");
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginUser" object:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf bindGTId:languageName];
        }];
    }
}

- (void)alertConfigPhone {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:[config objectForKey:UserInfos] error:nil];
    if (!model.user_des || model.user_des.length <= 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"请设置紧急联系号码", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
            EditEmergentPhoneVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"EditEmergentPhoneVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:^{
            NSString *nowTime = [NSString cy_getCurrentDateTransformTimeStamp];
            [config setObject:nowTime forKey:@"onceAWeek"];
        }];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
//    NSLog(@"[RYAN] HomeVC > viewDidAppear 1111");
    
    self.titleView.hidden = NO;
    //圆形菜单
    _menuVc = [[CircleMenuVc alloc] initWithButtonCount:[_systemSceneListArray count]
                                                            menuSize:kKYCircleMenuSize
                                                          buttonSize:kKYCircleMenuButtonSize
                                               buttonImageNameFormat:kKYICircleMenuButtonImageNameFormat
                                                    centerButtonSize:kKYCircleMenuCenterButtonSize
                                               centerButtonImageName:kKYICircleMenuCenterButton
                                     centerButtonBackgroundImageName:kKYICircleMenuCenterButtonBackground
                                                         centerPoint:_sceneView.center
                                           sysSceneArry:_systemSceneListArray];
    _menuVc.view.frame = self.tabBarController.view.frame;
    [[UIApplication sharedApplication].keyWindow addSubview:_menuVc.view];

    _menuVc.view.hidden = YES;
    
    __weak typeof (self) weakSelf = self;
    _menuVc.closedCircleMenu = ^{
        weakSelf.menuVc.view.hidden = YES;
    };
    _menuVc.clickedMenu = ^(NSInteger tag) {
        
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        int mselectSystem = tag - 1;
        
        weakSelf.menuVc.view.hidden = YES;
        
        //模式切换、发送到服务端
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        
        __block TestObject *obj = [[TestObject alloc] init];
        
        ChooseSystemSceneApi *api = [[ChooseSystemSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneGroup:[NSString stringWithFormat:@"%d",mselectSystem]];
        [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
            
            [config setObject:[NSString stringWithFormat:@"%d",mselectSystem] forKey:selectSystemItem];
            [weakSelf mselectSystemChange:mselectSystem];
//            [obj setValue:@"1" forKey:@"1"];
            obj = nil;
            
        } failure:^(id data, NSError *error) {
//            [obj setValue:@"1" forKey:@"1"];
            obj = nil;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (obj) {
                obj = nil;
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
                    [config setObject:NetworkAppStatus forKey:AppStatus];
                }
            }
        });
    };
    
    if(flag_checkfireware==NO){
        [self checkFirmwareVersion];
    }
    [self lodaData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [_menuVc.view removeFromSuperview];
    
//    NSLog(@"[RYAN] HomeVC > viewDidDisappear 1111");
}

- (void)showCircleMenu{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if (model != nil && [model.online isEqualToString:@"1"]) {
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        
        if (model != nil) {
            _menuVc.view.hidden = NO;
            [_menuVc open];
        }
    } else {
        [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"当前网关为:%@", nil),NSLocalizedString(@"离线", nil) ] ToView:self.view];
    }
}

/**
 获取网关信息
 */
-(void)getGatewayStatus{
    @weakify(self)

    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device",(ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"])] parameters:@{@"page":@(0),@"size":@(10)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSArray *arr = responseObject;
        if (arr.count>0) {
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setValue:arr forKey:Devices];
            //判断之前选中的网关是否在线，如果没有，则切换网关
            bool haveDevice = NO;
            for (int i = 0; i<arr.count; i++) {
                DeviceListModel *mmodel = [[DeviceListModel alloc] initWithDictionary:arr[i] error:nil];
                if([mmodel.devTid isEqualToString:_model.devTid] && [mmodel.ctrlKey isEqualToString:_model.ctrlKey] && [mmodel.bindKey isEqualToString:_model.bindKey]){
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"当前网关为:%@", nil),NSLocalizedString(mmodel.deviceName, nil) ] ToView:self.view];
                    NSString *online = [mmodel.online isEqualToString:@"1"] ? NSLocalizedString(@"在线", nil)  : NSLocalizedString(@"离线", nil);
                    if ([mmodel.deviceName isEqualToString:@"报警器"]) {
                        self.navigationItem.title = [NSString stringWithFormat:@"%@  (%@)", NSLocalizedString(@"我的家", nil),online];
                    }else{
                        self.navigationItem.title =[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(mmodel.deviceName, nil),online];
                    }
                    
                    haveDevice = YES;
                    [config setValue:arr[i] forKey:DeviceInfo];
                }
            }
            if (!haveDevice) {
                [config setValue:arr[0] forKey:DeviceInfo];
                DeviceListModel *mmodel = [[DeviceListModel alloc] initWithDictionary:arr[0] error:nil];
                [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"网关修改为:%@", nil),mmodel.devTid] ToView:self.view];
            }
            [config synchronize];
        }
//        else{
//            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//            addGatewayVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"addGatewayVC"];
//            BaseNC *nav = [[BaseNC alloc] initWithRootViewController:vc];
//            [self.navigationController presentViewController:nav animated:YES completion:nil];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD showError:NSLocalizedString(@"网络错误", nil) ToView:self.view];
    }];
}

-(void) uploadTime{
    __block NSObject *obj = [[NSObject alloc] init];
    UploadTimeApi *api = [[UploadTimeApi alloc] initWithDrivce:_model.devTid andCtrlKey:_model.ctrlKey];
    [api startWLanWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
        
        obj = nil;
    } failure:^(id data, NSError *error) {
        obj = nil;
    }];
}

///**
// 报警设备监听
// */
- (void)AlarmDeviceListener{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    _model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if(_model!=nil){
        NSDictionary *dic = @{
                              @"action" : @"devSend",
                              @"params" : @{
                                      @"devTid" : _model.devTid,
                                      @"data" : @{
                                              @"cmdId" : @25
                                              }
                                      }
                              };
        
        NSDictionary *dic2 = @{
                               @"action" : @"devSend",
                               @"params" : @{
                                       @"data" : @{
                                               @"cmdId" : @25
                                               }
                                       }
                               };
        
        NSDictionary *loginin = @{
                                  @"action":@"devLogin",
                                  @"params":@{
                                          @"devTid":_model.devTid
                                          }
                                  };
        NSDictionary *loginout = @{
                                   @"action":@"devLogout",
                                   @"params":@{
                                           @"devTid":_model.devTid
                                           }
                                   };
        
        @weakify(self)
        
        [[Hekr sharedInstance] recv:loginin obj:self callback:^(id obj, id data, NSError *error) {
            @strongify(self)
            if(!error){
                if ([_model.deviceName isEqualToString:@"报警器"]) {
                    self.navigationItem.title = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"我的家", nil),NSLocalizedString(@"在线", nil)];
                    
                }else{
                    self.navigationItem.title =[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(_model.deviceName, nil),NSLocalizedString(@"在线", nil)];
                }
                
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *ddd = [[NSMutableDictionary alloc] initWithDictionary:[config objectForKey:DeviceInfo]];
                [ddd setValue:@"1" forKey:@"online"];
                [config setValue:ddd forKey:DeviceInfo];
                //            [config synchronize];
            }
        }];
        
        [[Hekr sharedInstance] recv:loginout obj:self callback:^(id obj, id data, NSError *error) {
            @strongify(self)
            if(!error){
                if ([_model.deviceName isEqualToString:@"报警器"]) {
                    self.navigationItem.title = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"我的家", nil),NSLocalizedString(@"离线", nil)];
                }else{
                    self.navigationItem.title =[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(_model.deviceName, nil),NSLocalizedString(@"离线", nil)];
                }
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *ddd = [[NSMutableDictionary alloc] initWithDictionary:[config objectForKey:DeviceInfo]];
                [ddd setValue:@"0" forKey:@"online"];
                [config setValue:ddd forKey:DeviceInfo];
                //            [config synchronize];
            }
        }];
        

            [[Hekr sharedInstance] recv:dic2 obj:self callback:^(id obj, id data, NSError *error) {
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

/**
 告警
 
 @param data 内容
 */
- (void)doAlert:(NSDictionary *)data{
    BOOL flag = NO;
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
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model2 = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    NSString * sss= dic[@"params"][@"devTid"];
    if(model2!=nil && [sss isEqualToString:model2.devTid]){
        flag = YES;
    }

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

            NSString *content;
        if (flag == YES) {
              ItemData *item = [[DeviceDataBase sharedDataBase] selectDevice:deviceid];
            [VoiceHelp playMainBoundAudioWithName:@"phonering"];
            [[DeviceDataBase sharedDataBase] updateDevice:model];
            if([item.customTitle isEqualToString:@""]){
                content = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(item.title, nil),item.devID];
            }else{
                content = item.customTitle;
            }
        }else if(flag == NO) {
            NSDictionary *names = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"]] valueForKey:@"names"];
            NSString * aaa = NSLocalizedString([names objectForKey:[model.device_name substringFromIndex:1] ],nil);
            content = [aaa stringByAppendingString:[NSString stringWithFormat:@"%d",model.device_ID]];
            [VoiceHelp playMainBoundAudioWithName:@"phonering"];
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
            
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)
                                                                       message:[NSString stringWithFormat:NSLocalizedString(@"请注意，%@(%@) 的 %@告警", nil),gatewayId ,lastFour , content]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        UIAlertAction* silenceAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"静音", nil)
                                                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [VoiceHelp disposeSystemSoundIDWithName:@"phonering"];
            
            //发送静音指令
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *devmodel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            
            if ([self.devTypeName isEqualToString:@"0005"]) {
                NSString *deviceStatus = [self.alarmName stringByAppendingString:@"000000"];
                
                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:deviceStatus];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
            } else {
                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:@"000000"];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
            }
            
        }];
        
        [alert addAction:defaultAction];
        [alert addAction:silenceAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
       
        
    } else if (model.answer_content.length > 8 && [[model.answer_content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"AC"]){
        [VoiceHelp playMainBoundAudioWithName:@"phonering"];
        NSString *total = @"";
        NSString *scenecontent = @"";
        if(flag == YES){
            NSString *sceneid = [model.answer_content substringWithRange:NSMakeRange(6, 2)];
            sceneid = [NSString stringWithFormat:@"%d",(int)strtoul([sceneid UTF8String],0,16)];
            SceneModel *scenemodel = [[SceneDataBase sharedDataBase] selectScene:sceneid];
            if(scenemodel.scene_name!=nil && (![scenemodel.scene_name isEqualToString:@""])){
                scenecontent = scenemodel.scene_name;
            }else{
                scenecontent = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"情景", nil),sceneid ];
            }
        }else{
            NSString *sceneid = [model.answer_content substringWithRange:NSMakeRange(6, 2)];
            sceneid = [NSString stringWithFormat:@"%d",(int)strtoul([sceneid UTF8String],0,16)];
            scenecontent = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"情景", nil),sceneid ];
        }
            
            total = [NSString stringWithFormat:NSLocalizedString(@"%@(%@)的%@触发了", nil),gatewayId,lastFour,scenecontent ];
        if(flag == NO){
            total = [NSString stringWithFormat:@"%@\n%@",total,NSLocalizedString(@"请切换到相应网关", nil) ];
        }
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:total preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"静音", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [VoiceHelp disposeSystemSoundIDWithName:@"phonering"];
            
            //发送静音指令
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *devmodel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            
            if ([self.devTypeName isEqualToString:@"0005"]) {
                NSString *deviceStatus = [self.alarmName stringByAppendingString:@"000000"];
                
                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:deviceStatus];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
            } else {
                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:@"000000"];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
            }
            
        }]];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)lodaData {
    [self.tempHumArray removeAllObjects];
    NSArray<ItemData *> *array = [[DeviceDataBase sharedDataBase] selectDevice];
    [array enumerateObjectsUsingBlock:^(ItemData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.title isEqualToString:@"温湿度探测器"]) {
            [self.tempHumArray addObject:obj];
        }
    }];
    
    /** 调起marquee显示温湿度信息的方法 */
    self.marquee.tempAndHumArray = self.tempHumArray;
}

/**
 监听设备状态
 */
-(void) divceStatusListener{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    _model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    //氦氪云接口获取设备状态
    ScynDeviceApi *api = [[ScynDeviceApi alloc] initWithDrivce:_model.devTid andCtrlKey:_model.ctrlKey DeviceStatus:[[DeviceDataBase sharedDataBase] selectDevice]];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        if (!error) {
            //TODO: 在这里init方法里面做限制
            NSNumber *msgId=data[@"msgId"];
            NSNumber *cmdId = data[@"params"][@"data"][@"cmdId"];
                    DeviceListModel *model2 = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            NSString * devrev = [[data objectForKey:@"params"] objectForKey:@"devTid"];
            if(model2!=nil && [devrev isEqualToString:model2.devTid]){
            DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
                if([cmdId intValue] == 119){
                    int newa = [Encryptools getDescryption:model.device_ID withMsgId:[msgId intValue]];
                    [model setDevice_ID:newa];
                }
            //数据库更新设备
            if ([model.device_name isEqualToString:@"DEL"]) {
                [[DeviceDataBase sharedDataBase] deletDevice:model.device_ID];
            }else if([model.device_status isEqualToString:@"OVER"]){
                //获取结束位置符号
                [config setObject:@"1" forKey:DeviceSycStatus];
                [config synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceOver" object:nil];
                    
            }else{
                [[DeviceDataBase sharedDataBase] updateDevice:model];
            }
                
            }
            

        }
    } failure:^(id data, NSError *error) {
        
    }];
    
}

- (CYMarquee *)marquee {
    if (!_marquee) {
        _marquee = [[CYMarquee alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.headBg.frame.size.height)];
        [self.view addSubview:_marquee];
        
        [self.view bringSubviewToFront:_sceneView];
    }
    return _marquee;
}

- (NSMutableArray<ItemData *> *)tempHumArray {
    if (!_tempHumArray) {
        _tempHumArray = [[NSMutableArray<ItemData *> alloc] init];
    }
    return _tempHumArray;
}

/**
 设备同步
 */
//- (void)deviceSycn{
//    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//    _model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
//
//    NSMutableArray *array = [[DeviceDataBase sharedDataBase] selectDevice];
//
//    int maxId = 0;
//    for (ItemData *data in array) {
//        if (data.devID && [data.devID intValue] > maxId) {
//            maxId = [data.devID intValue];
//        }
//    }
//    NSString *content = @"";
//
//    content = [NSString stringWithFormat:@"%@",[BatterHelp gethexBybinary:(maxId*2 +2)]];
//    int length = (int)content.length;
//    for (int i = 0; i < 4 - length; i++) {
//        content = [@"0" stringByAppendingString:content];
//    }
//    for (int i = 1 ; i<=maxId; i++) {
//        bool hasDevice = NO;
//        for (ItemData *data in array) {
//            if (data.devID && [data.devID intValue] == i) {
//                content = [content stringByAppendingString:data.crcCode];
//                hasDevice = YES;
//                break;
//            }
//        }
//        if (!hasDevice) {
//            content = [content stringByAppendingString:@"0000"];
//        }
//    }
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        ScynDeviceApi *api = [[ScynDeviceApi alloc] initWithDrivce:_model.devTid andCtrlKey:_model.ctrlKey DeviceStatus:[[DeviceDataBase sharedDataBase] selectDevice]];
//        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
//            if (!error) {
//                //TODO: 在这里init方法里面做限制
//                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
//                //数据库更新设备
//                if ([model.device_name isEqualToString:@"DEL"]) {
//                    [[DeviceDataBase sharedDataBase] deletDevice:model.device_ID];
//                }else if([model.device_status isEqualToString:@"OVER"]){
//                    //获取结束位置符号
//                    [config setObject:@"1" forKey:DeviceSycStatus];
//                    [config synchronize];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceOver" object:nil];
//
//                }else{
//                    [[DeviceDataBase sharedDataBase] updateDevice:model];
//                }
//            }
//        } failure:^(id data, NSError *error) {
//
//        }];
//
//    });
//}

-(void)viewWillDisappear:(BOOL)animated{
    self.titleView.hidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

    _isRow = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    
    //获取系统情景数据
    [self lodaSystemData];
    
    self.tabBarController.tabBar.alpha = 1;
    //设置透明标题栏
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    int mselectSystemItem = 0;
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    _model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    NSString *online = [_model.online isEqualToString:@"1"] ? NSLocalizedString(@"在线", nil)  : NSLocalizedString(@"离线", nil);
    if ([_model.deviceName isEqualToString:@"报警器"]) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"我的家", nil),online];
    }else{
        self.navigationItem.title =[NSString stringWithFormat:@"%@(%@)", NSLocalizedString(_model.deviceName, nil),online];
    }
    
    if ([config objectForKey:selectSystemItem]) {
        mselectSystemItem = [[config objectForKey:selectSystemItem] intValue];
    }
    
    if (_autoLbe == nil) {
        _autoLbe = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(0, 0, 42, 21)];
        _autoLbe.font = [UIFont systemFontOfSize:13.0f];
        _sceneName.text = @"";
        _autoLbe.textColor = RGB(40, 184, 215);
        [_sceneName addSubview:_autoLbe];
    }
    
    [self mselectSystemChange:mselectSystemItem];
    
    
    //获取视频信息
    [self getVideoInfo];
    [self getUserIonfo];
    
}

//每次回到页面时都判断下目前的系统情景状态
- (void)mselectSystemChange:(int)mselectSystemItem{
    switch (mselectSystemItem) {
        case 0:
            _homeSystemSceneImageView.image = [UIImage imageNamed:NSLocalizedString(@"home01_icon", nil)];
            _autoLbe.text = NSLocalizedString(@"在家", nil);
            break;
        case 1:
            _homeSystemSceneImageView.image = [UIImage imageNamed:NSLocalizedString(@"away01_icon", nil)];
            _autoLbe.text = NSLocalizedString(@"离家", nil);
            break;
        case 2:
            _homeSystemSceneImageView.image = [UIImage imageNamed:NSLocalizedString(@"sleep01_icon", nil)];
            _autoLbe.text = NSLocalizedString(@"睡眠", nil);
            break;
        default:{
            SystemSceneModel *sysModel = [_systemSceneListArray objectAtIndex:mselectSystemItem];
            _homeSystemSceneImageView.image = [UIImage imageNamed:NSLocalizedString(@"other01_icon", nil)];
            _autoLbe.text = sysModel.scene_name;
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 设置视图
 */
-(void)setView{
    WS(ws)
    [self initNoVideo];
    
//    _addressView.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_icon"]];
    _addressView.enabled = NO;
    _addressView.leftViewMode = UITextFieldViewModeAlways;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.bottomView addGestureRecognizer:recognizer];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottom:)];
    [self.bottomView addGestureRecognizer:tap];
}

/**
 点击设置按钮
 */
-(void)setting{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
    SettingVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SettingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    WarningListViewController *wl = [[WarningListViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wl];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 点击底部的蓝条
 */
-(void)tapBottom:(UITapGestureRecognizer *)sender{
    //弹动一下
    BOOL animated = [self.bottomView.layer pop_animationKeys] > 0;
    if (!animated) {
        POPDecayAnimation *scollerTop = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        scollerTop.velocity = @(-30);
        [_bottomView.layer pop_addAnimation:scollerTop forKey:@"scollerTop"];
        
        WS(ws)
        scollerTop.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            POPSpringAnimation *dropAnamation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
            dropAnamation.toValue = @(0);
            dropAnamation.springBounciness = 20;
            [ws.bottomView.layer pop_addAnimation:dropAnamation forKey:@"dropAnamation"];
        };
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self getLocationWeather];
}

/**
 获取本地地址
 */
-(void)getLocation{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    _model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if(_model!=nil){
        /**
         *  发送IOT_KEY?+devTid，重发策略是：1秒3次；如果发现选定的网关在内网中，则转内网，否则转外网；
         */
        _obj = [[TestObject alloc] init];
        @weakify(self)
        [[MyUdp shared] recvTokenObj:_obj Callback:^(id obj, id data, NSError *error) {
            @strongify(self)
            [_obj description];
            [self getDeviceToken:data];
        }];
        
        //发三次udp
        [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_obj) {
                [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
            }
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_obj) {
                [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
            }
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(_model!=nil){
                [self uploadTime];
            }
            [self divceStatusListener];
            AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateInterface) name:AFNetworkingReachabilityDidChangeNotification object:nil];//这个可以放在需要侦听的页面
            [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
               
            }];
            [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
        });
        
        
        
        
    }
    
    [self getGatewayStatus];
//    [self AlarmDeviceListener];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationMgr = [[CLLocationManager alloc] init];
        self.locationMgr.delegate = self;
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyKilometer;
        [self.locationMgr requestAlwaysAuthorization];
        self.locationMgr.distanceFilter = 10.0f;
        [self.locationMgr startUpdatingLocation];
    }
}


- (void)getLocationWeather {
    NSString *lan;
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if ([languageName containsString:@"zh"]) {
        lan = @"zh";
    } else if ([languageName containsString:@"cs"]) {
        lan = @"cs";
    } else if ([languageName containsString:@"de"]) {
        lan = @"de";
    }else if ([languageName containsString:@"es"]) {
        lan = @"es";
    }else if ([languageName containsString:@"nl"]) {
        lan = @"nl";
    }else if ([languageName containsString:@"fr"]) {
        lan = @"fr";
    }else if ([languageName containsString:@"it"]) {
        lan = @"it";
    }else if ([languageName containsString:@"sl"]) {
        lan = @"sl";
    }else if ([languageName containsString:@"fi"]) {
        lan = @"fi";
    } else {
        lan = @"en";
    }
    
    int subtract = 100;
    double nowTime =  [self getNowTimeTimestamp];
    double lateTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"latestTime"];
    if (lateTime != 0) {
        subtract = (int)(nowTime - lateTime);
    }
    if (subtract < 60) {
        NSDictionary *weatherDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"weatherDict"];
        NewWeatherModel *model = [[NewWeatherModel alloc] init];
        model.weather = weatherDict[@"weather"];
        model.humidity = weatherDict[@"humidity"];
        model.icon = weatherDict[@"icon"];
        model.temp = weatherDict[@"temp"];
    
        NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
        self.marquee.model = model;
        self.marquee.address = address;
        return;
    }
    
    NSDictionary *params = @{@"lat": @(self.locationMgr.location.coordinate.latitude),
                             @"lon": @(self.locationMgr.location.coordinate.longitude),
                             @"appid": @"b45eb4739891c226b7a36613ce3d1dbd",
                             @"lang" : lan };
    [CYNetManager getWeatherWithParams:params handler:^(NewWeatherModel *model, NSError *error) {
        if (!error) {
            double latestTime = [self getNowTimeTimestamp];
            NSLog(@"latestTime = %f", latestTime);
            [[NSUserDefaults standardUserDefaults] setDouble:latestTime forKey:@"latestTime"];
            NSDictionary *modelDict = @{@"weather": model.weather,
                                        @"humidity": model.humidity,
                                        @"icon": model.icon,
                                        @"temp": model.temp
                                        };
            [[NSUserDefaults standardUserDefaults] setObject:modelDict forKey:@"weatherDict"];
            self.marquee.model = model;
        }
    }];

//    NSDictionary *parames = @{@"latlng": [NSString stringWithFormat:@"%f,%f",self.locationMgr.location.coordinate.latitude, self.locationMgr.location.coordinate.longitude],
//                              @"sensor": @"true",
//                              @"language": lan
//                              };
//    [CYNetManager getLocationWithParams:parames handler:^(NSString *address, NSString *errorStr) {
//        if ([errorStr isEqualToString:@"OK"]) {
//            self.marquee.address = address;
//            [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"address"];
//        } else {
//        }
//    }];

}

- (NSTimeInterval)getNowTimeTimestamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    return a;
}

- (void)getUserIonfo{
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile", https]
 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        [config setValue:responseObject forKey:UserInfos];
        [config synchronize];
        
        NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
    
        NSLog(@"koyang===koyang====%@",extraPropertiesDic);
     
        NSLog(@"[RYAN] getUserIonfo > extraPropertiesDic");
        if (extraPropertiesDic[@"monitor"] !=nil) {
            
            NSMutableArray *monitor = [(NSArray*)[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
            
            for (int i = 0; i < [monitor count]; i++) {
                
                if (![[monitor objectAtIndex:i][@"devid"] isEqualToString:@"lbt_01"]&&[monitor objectAtIndex:i][@"devid"]!=nil&&[[monitor objectAtIndex:i][@"devid"] isEqual:[NSNull null]]) {
                    
                    NSDictionary *videoDic = (NSDictionary *)monitor[i];
                    VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
                    vInfo.devid = videoDic[@"devid"];
                    vInfo.name = videoDic[@"name"];
                    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
                    vInfo.userName = userName;
                    [[VideoDataBase sharedDataBase] updateVideoInfo:vInfo];
                }
            }
            
            [self setVideoArray:monitor];

        }else{
            [self initNoVideo];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.domain);
    }];
}

//- (void)upTime{
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UploadTimeApi *api = [[UploadTimeApi alloc] initWithDrivce:_model.devTid andCtrlKey:_model.ctrlKey];
//        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
//        } failure:^(id data, NSError *error) {
//        }];
//    });
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
////    if (alertView.tag == 0) {
//        [VoiceHelp disposeSystemSoundIDWithName:@"phonering"];
//        if (buttonIndex == 1) {
//
//            //发送静音指令
//            DeviceListModel *devmodel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
//
//            if ([self.devTypeName isEqualToString:@"0005"]) {
//                NSString *deviceStatus = [self.alarmName stringByAppendingString:@"000000"];
//
//                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:deviceStatus];
//                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
//            } else {
//                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:devmodel.devTid CtrlKey:devmodel.ctrlKey DeviceId:0 DeviceStatus:@"000000"];
//                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
//            }
//        }
////        self.lastAlert = nil;
//}

- (NSString *)transform:(NSString *)chinese{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}

- (void)cycleScrollView:(HomeHeadView *)cycleScrollView didSelectImageView:(NSInteger)index videoInfos:(NSArray *)videosArray{
    NSLog(@"[RYAN] HomeVC > cycleScrollView > index: %d", index);
    
    VideoInfoModel *vInfo = [videosArray objectAtIndex:index];
    if ([vInfo.devid isEqualToString:@"dev_list"]) {
        
    } else if ([vInfo.devid isEqualToString:@"lbt_01"]) {
        //新增摄像头
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
        [self.navigationController pushViewController:[board instantiateViewControllerWithIdentifier:@"ChooseConnectTypeVC"]
                                             animated:YES];
    }else{
        VideoLiveViewController *videoLive = [[VideoLiveViewController alloc] init];
        videoLive.vInfo = vInfo;
        videoLive.videoArray = _imageView.videoArray;
        videoLive.selectIndex = index;
        [self.navigationController pushViewController:videoLive animated:YES];
    }
}

- (void)getVideoInfo{
    NSLog(@"[RYAN] getVideoInfo");

    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *responseObject = [config objectForKey:UserInfos];
    
    NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
    
    NSMutableArray *videos = nil;
    
    if (extraPropertiesDic[@"monitor"] !=nil) {
        
        videos = [[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
    }
    
    if (videos != nil&&[videos count]>0) {
        
        NSMutableArray *monitor = [(NSArray*)[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
        
        for (int i = 0; i < [monitor count]; i++) {
            
            if (![[monitor objectAtIndex:i][@"devid"] isEqualToString:@"lbt_01"]&&[monitor objectAtIndex:i][@"devid"]!=nil&&[[monitor objectAtIndex:i][@"devid"] isEqual:[NSNull null]]) {
                
                NSDictionary *videoDic = (NSDictionary *)monitor[i];
                VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
                vInfo.devid = videoDic[@"devid"];
                vInfo.name = videoDic[@"name"];
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
                vInfo.userName = userName;
                [[VideoDataBase sharedDataBase] updateVideoInfo:vInfo];
            }
        }
        
        [self setVideoArray:monitor];
    }
}

- (void)initNoVideo {
    NSLog(@"[RYAN] HomeVC > initNoVideo ");
    _imageView.videoArray = @[@{@"devid":@"dev_list",@"name":NSLocalizedString(@"dev_list", nil)},
                              @{@"devid":@"lbt_01",@"name":NSLocalizedString(@"无视频，点击添加", nil)}];
}

- (void)setVideoArray:(NSMutableArray *) monitor {
    NSLog(@"[RYAN] HomeVC > setVideoArray ");
    if (monitor != nil&&[monitor count] > 0) {
        [monitor insertObject:@{@"devid":@"dev_list",@"name":NSLocalizedString(@"dev_list", nil)} atIndex:0];
        _imageView.videoArray = monitor;
    }else{
        [self initNoVideo];
    }
}

/**
 从数据库读取系统情景数据
 */
- (void)lodaSystemData{
    _systemSceneListArray = [[SystemSceneDataBase sharedDataBase] selectScene];
}



#pragma mark - checkfireware
//检测固件版本
- (void)checkFirmwareVersion {
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    self.model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if(self.model){
        flag_checkfireware = YES;
        self.versionCode = self.model.binVersion;
        
        NSDictionary *dic = @{
                              @"devTid":self.model.devTid,
                              @"productPublicKey":self.model.productPublicKey,
                              @"binType":self.model.binType,
                              @"binVer":self.model.binVersion,
                              };
        
        @weakify(self)
        NSString *https = (ApiMap==nil?@"https://console-openapi.hekr.me":ApiMap[@"console-openapi.hekr.me"]);
        
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/external/device/fw/ota/check", https] parameters:@[dic] progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self)
            
            _verModel = [[GatewayVersionModel alloc] initWithDictionary:responseObject[0] error:nil];
            if (_verModel.update == YES) {
                
                [LEEAlert alert].config
                .LeeAddTitle(^(UILabel *label) {
                    label.text = [NSString stringWithFormat:NSLocalizedString(@"当前网关固件版本%@，有可用更新%@, 是否升级", nil),self.model.binVersion, _verModel.devFirmwareOTARawRuleVO.latestBinVer];
                    label.textColor = RGB(57, 166, 240);
                    label.font = [UIFont systemFontOfSize:15];
                })
                .LeeAddAction(^(LEEAction *action) {
                    action.type = LEEActionTypeCancel;
                    action.title = NSLocalizedString(@"暂不升级", nil);
                    action.titleColor = [UIColor lightGrayColor];
                    action.font = [UIFont systemFontOfSize:14];
                })
                .LeeAddAction(^(LEEAction *action) {
                    action.type = LEEActionTypeDefault;
                    action.title = NSLocalizedString(@"确定", nil);
                    action.titleColor = RGB(57, 166, 240);
                    action.font = [UIFont systemFontOfSize:14];
                    //__weak typeof(self) weakSelf = self;
                    action.clickBlock = ^{
                        [self showFireLoading];
                        UpdateDeviceApi *api = [[UpdateDeviceApi alloc] initWithGatewayVersionModel:_verModel];
                        [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
                        } failure:^(id data, NSError *error) {
                        }];
                    };
                })
                .LeeShow();
                
                
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(NSLocalizedString(@"读取失败",nil));
            //[MBProgressHUD showError: NSLocalizedString(@"读取失败",nil) ToView:GetWindow];
        }];
    }
    
    
}

-(void) closefirem{
    _vc.success = YES;
}


-(void)showFireLoading{
    @weakify(self)
    _vc=[[JhDownProgressController alloc] init];
    _vc.timer1 = 1.0f;
    _vc.timerApi = 5.0f;
    _vc.hintMessage = NSLocalizedString(@"正在升级", nil);
    _vc.finish = ^(BOOL flag) {
        if(!flag){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"更新失败", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"暂不升级", nil) style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重试", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self)
                [self showFireLoading];
                
                UpdateDeviceApi *api = [[UpdateDeviceApi alloc] initWithGatewayVersionModel:self.verModel];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
                } failure:^(id data, NSError *error) {
                }];
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }else{
            [MBProgressHUD showSuccess:NSLocalizedString(@"固件更新成功!", nil) ToView:GetWindow];
        }
        
    };
    _vc.getApi = ^{
        @strongify(self)
        
        NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
        
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device?devTid=%@&ctrlKey=%@", https,self.model.devTid,self.model.ctrlKey] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DeviceListModel *mmodel = [[DeviceListModel alloc] initWithDictionary:responseObject[0] error:nil];
            if (![mmodel.binVersion isEqualToString:self.model.binVersion]) {
                [self closefirem];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    };
    GetWindow.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    _vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [GetWindow.rootViewController presentViewController:_vc animated:NO completion:^{
        
    }];
    
}

-(void)nettest{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *status = [config objectForKey:AppStatus];
    [MBProgressHUD showSuccess:status ToView:self.view];
}


- (void)updateInterface {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config setObject:NetworkAppStatus forKey:AppStatus];
    
    _model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if ([AppStatusHelp getWifiIP].length > 0) {
        _obj = [[TestObject alloc] init];
        @weakify(self)
        [[MyUdp shared] recvTokenObj:_obj Callback:^(id obj, id data, NSError *error) {
            @strongify(self)
            [_obj description];
            [self getDeviceToken:data];
        }];
        //发三次udp
        [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_obj) {
                [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
            }
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_obj) {
                [[MyUdp shared] sendGetTokenWithDeviceID:_model.devTid];
            }
        });
    }
}

@end
