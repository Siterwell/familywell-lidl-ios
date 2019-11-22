//
//  TempControlDetailVC.m
//  sHome
//
//  Created by TracyHenry on 2018/9/3.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "TempControlDetailVC.h"
#import "UINavigationBar+Awesome.h"
#import "BatterHelp.h"
#import "DeviceListModel.h"
#import "deleteDeviceApi.h"
#import <LCActionSheet.h>
#import "replaceDeviceApi.h"
#import "RenameVC.h"
#import "AddDeviceVC.h"
#import "BaseNC.h"
#import "DeviceDataBase.h"
#import "TempControlSettingVC.h"

@interface TempControlDetailVC()


@property (nonatomic) UIImageView *bgImageView;
@property (nonatomic) UILabel *MainLabel;
@property (nonatomic) UIImageView *wifiImgV;
@property (nonatomic) UIImageView *batteryImgV;
@property (nonatomic) UILabel *batterytext;

@property (nonatomic, assign) BOOL isClickButton;

@property (nonatomic) UIButton *setting_btn;
@property (nonatomic) UIButton *shishitemp_btn;
@property (nonatomic) UIButton *window_btn;
@property (nonatomic) UIButton *valve_btn;
@property (nonatomic) UIButton *workmode_btn;
@property (nonatomic) UIButton *tongsuo_btn;

@property (nonatomic) UILabel *label_setting;
@property (nonatomic) UILabel *label_shishi;
@property (nonatomic) UILabel *window_status;
@property (nonatomic) UILabel *valve_status;
@property (nonatomic) UILabel *workmode_status;
@property (nonatomic) UILabel *tongsuo_status;

@end

@implementation TempControlDetailVC{
    BOOL _isReplcing;
    BOOL _isDeleting;
}

#pragma -mark life
-(void)viewDidLoad{
        [super viewDidLoad];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData) name:@"updateDeviceSuccess" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    [self setupBaseUI];
    
    if([_data.customTitle isEqualToString:@""]){
        self.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(_data.title, nil),_data.devID];
    }else{
        self.title = _data.customTitle;
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"管理",nil) withTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"back_icon" highImage:nil withTintColor:[UIColor whiteColor]];
    [self setPageBackground];
    [self analysisStatus];
}

#pragma -mark method

- (void)setupBaseUI {
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:_bgImageView];
    
    _MainLabel = [[UILabel alloc] init];
    _MainLabel.font = [UIFont systemFontOfSize:17];
    _MainLabel.textColor = [UIColor blackColor];
    _MainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_MainLabel];
    [_MainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(75);
        make.height.equalTo(30);
        make.width.equalTo(100);
    }];
    
    _wifiImgV = [[UIImageView alloc] init];
    [self.view addSubview:_wifiImgV];
    [_wifiImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.centerY.equalTo(_MainLabel);
    }];
    
    
    _batteryImgV = [[UIImageView alloc] init];
    [self.view addSubview:_batteryImgV];
    [_batteryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-50);
        make.centerY.equalTo(_MainLabel);
    }];
    
    _batterytext = [[UILabel alloc] init];
    [self.view addSubview:_batterytext];
    [_batterytext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_batteryImgV.mas_left).offset(-10);
        make.centerY.equalTo(_MainLabel);
    }];
    
    _setting_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setting_btn setBackgroundColor:[UIColor clearColor]];
    [_setting_btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_setting_btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_setting_btn addTarget:self action:@selector(gotosetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_setting_btn];
    [_setting_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.MainLabel.mas_bottom).offset(30);
        make.width.equalTo(Main_Screen_Width/2);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(40);
    }];
    [_setting_btn setTitle:NSLocalizedString(@"设定温度", nil) forState:UIControlStateNormal];
    
    _shishitemp_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shishitemp_btn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_shishitemp_btn];
    [_shishitemp_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.MainLabel.mas_bottom).offset(30);
        make.width.equalTo(Main_Screen_Width/2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(40);
    }];
    [_shishitemp_btn setTitle:NSLocalizedString(@"实时温度", nil) forState:UIControlStateNormal];
    
    _label_setting = [[UILabel alloc] init];
    _label_setting.textColor = [UIColor whiteColor];
    _label_setting.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_label_setting];
    [_label_setting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setting_btn.mas_bottom).offset(5);
        make.width.equalTo(Main_Screen_Width/2);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(40);
    }];
    
    _label_shishi = [[UILabel alloc] init];
    _label_shishi.textColor = [UIColor whiteColor];
    _label_shishi.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_label_shishi];
    [_label_shishi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shishitemp_btn.mas_bottom).offset(5);
        make.width.equalTo(Main_Screen_Width/2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(40);
    }];
    
    
    _window_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_window_btn setBackgroundColor:[UIColor clearColor]];
    [_window_btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_window_btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_window_btn addTarget:self action:@selector(gotosetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_window_btn];
    [_window_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label_setting.mas_bottom).offset(30);
        make.width.equalTo(Main_Screen_Width/2);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(40);
    }];
    [_window_btn setTitle:NSLocalizedString(@"窗户状态", nil) forState:UIControlStateNormal];
    
    _valve_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_valve_btn setBackgroundColor:[UIColor clearColor]];
    [_valve_btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_valve_btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_valve_btn addTarget:self action:@selector(gotosetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_valve_btn];
    [_valve_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label_shishi.mas_bottom).offset(30);
        make.width.equalTo(Main_Screen_Width/2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(40);
    }];
    [_valve_btn setTitle:NSLocalizedString(@"阀门状态", nil) forState:UIControlStateNormal];
    
    _window_status= [[UILabel alloc] init];
    _window_status.textColor = [UIColor whiteColor];
    _window_status.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_window_status];
    [_window_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.window_btn.mas_bottom).offset(5);
        make.width.equalTo(Main_Screen_Width/2);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(40);
    }];
    
    _valve_status = [[UILabel alloc] init];
    _valve_status.textColor = [UIColor whiteColor];
    _valve_status.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_valve_status];
    [_valve_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valve_btn.mas_bottom).offset(5);
        make.width.equalTo(Main_Screen_Width/2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(40);
    }];
    
    //第三排布局
    _workmode_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_workmode_btn setBackgroundColor:[UIColor clearColor]];
    [_workmode_btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_workmode_btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_workmode_btn addTarget:self action:@selector(gotosetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_workmode_btn];
    [_workmode_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.window_status.mas_bottom).offset(30);
        make.width.equalTo(Main_Screen_Width/2);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(40);
    }];
    [_workmode_btn setTitle:NSLocalizedString(@"工作模式", nil) forState:UIControlStateNormal];
    
    _tongsuo_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tongsuo_btn setBackgroundColor:[UIColor clearColor]];
    [_tongsuo_btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [_tongsuo_btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tongsuo_btn addTarget:self action:@selector(gotosetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tongsuo_btn];
    [_tongsuo_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valve_status.mas_bottom).offset(30);
        make.width.equalTo(Main_Screen_Width/2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(40);
    }];
    [_tongsuo_btn setTitle:NSLocalizedString(@"童锁", nil) forState:UIControlStateNormal];
    
    _workmode_status= [[UILabel alloc] init];
    _workmode_status.textColor = [UIColor whiteColor];
    _workmode_status.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_workmode_status];
    [_workmode_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workmode_btn.mas_bottom).offset(5);
        make.width.equalTo(Main_Screen_Width/2);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(40);
    }];
    
    _tongsuo_status = [[UILabel alloc] init];
    _tongsuo_status.textColor = [UIColor whiteColor];
    _tongsuo_status.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_tongsuo_status];
    [_tongsuo_status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tongsuo_btn.mas_bottom).offset(5);
        make.width.equalTo(Main_Screen_Width/2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(40);
    }];
}

/**
 设备背景图片
 */
-(void)setPageBackground{
    if ([_data.status isEqualToString:@"aq"]) {
        [_bgImageView setImage:[UIImage imageNamed:@"sbgreen_bg"]];
        _MainLabel.text = NSLocalizedString(@"正常",nil);
    }
    else if ([_data.status isEqualToString:@"gz"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];
        _MainLabel.text = NSLocalizedString(@"低电压",nil);
    }
    else if ([_data.status isEqualToString:@"no"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sbgray_bg"]];
        _MainLabel.text = NSLocalizedString(@"离线",nil);
    }
}

- (void)analysisStatus{
    self.data = [[DeviceDataBase sharedDataBase] selectDevice:self.data.devID];
    if (![self.data.status isEqualToString:@"no"]) {
        NSString *signal = [_data.statuCode substringWithRange:NSMakeRange(0, 2)];
        
        NSNumber *num = [BatterHelp numberHexString:signal];
        Byte a =((Byte)[num intValue])&0x03;
        
        if (a == 4) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi04"]];
        }
        else if (a == 3) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi03"]];
        }
        else if (a == 2){
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi02"]];
        }
        else if (a == 1) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        }
        else{
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        }
    }
    else {
        [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];

    }
    NSString *battery = [_data.statuCode substringWithRange:NSMakeRange(2, 2)];
    if (![self.data.title containsString:@"插座"] && ![self.data.title containsString:@"双路开关"]) {
        if ([battery isEqualToString:@"FF"]) {
        }
        else if ([battery isEqualToString:@"80"]){
            self.batterytext.text = @"0%";
        }
        else if ([battery isEqualToString:@"64"]){
            self.batterytext.text = @"100%";
            [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg100_icon"]];
            
        }else{
            self.batterytext.text = [NSString stringWithFormat:@"%@%%",[BatterHelp getBatterFormDevice:battery]];
            if ([[BatterHelp getBatterFormDevice:battery] intValue]<100 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 80) {
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg80_icon"]];
            } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<80 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 60) {
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg60_icon"]];
            } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<60 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 40) {
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg40_icon"]];
            } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<40) {
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg40_icon"]];
            }
        }
    }
    
    NSString *signal1 = [_data.statuCode substringWithRange:NSMakeRange(0, 2)];
    NSString *status1 = [_data.statuCode substringWithRange:NSMakeRange(4, 2)];
    NSString *status2 =[_data.statuCode substringWithRange:NSMakeRange(6, 2)];
    
    if([status1 isEqualToString:@"FF"]){
        _window_status.text = @"";
        _valve_status.text = @"";
        _workmode_status.text = @"";
        _tongsuo_status.text = @"";
        _label_setting.text = @"";
        _label_shishi.text =@"";
    }else{
        int ds = [[BatterHelp numberHexString:status1] intValue];
        int ds2 = [[BatterHelp numberHexString:status2] intValue];
        int ds3 = [[BatterHelp numberHexString:signal1] intValue];
        
        int shineng_window2 = (0x80) & ds3;
        int shineng_valve2 = (0x40) & ds3;
        int  shishi_temp2= (0x3F) & (ds2>>2);
        int mode2 = (0x03) & (ds2);
        int status_window2 = (0x80) & ds;
        int status_valve2 = (0x40) & ds;
        int status_tongsuo = (0x20) & ds3;
        int xiaoshu = (0x20) & ds;
        int sta =  ((0x1F) & ds);
        
        if(shineng_window2!=0) {
            if (status_window2 != 0) {
                _window_status.text = NSLocalizedString(@"开", nil);
            } else {
                _window_status.text = NSLocalizedString(@"关", nil);
            }
        }else {
            _window_status.text = NSLocalizedString(@"不使能", nil);
        }
        if(shineng_valve2!=0) {
            if (status_valve2 != 0) {
                _valve_status.text = NSLocalizedString(@"开", nil);
            } else {
               _valve_status.text = NSLocalizedString(@"关", nil);
            }
        }else{
            _valve_status.text = NSLocalizedString(@"不使能", nil);
        }
        
        if (status_tongsuo != 0) {
            _tongsuo_status.text = NSLocalizedString(@"开", nil);
        } else {
            _tongsuo_status.text = NSLocalizedString(@"关", nil);
        }
        
        switch (mode2){
            case 0:
                _workmode_status.text = NSLocalizedString(@"防冻模式", nil);
                break;
            case 1:
                _workmode_status.text = NSLocalizedString(@"自动模式", nil);
                break;
            case 2:
                _workmode_status.text = NSLocalizedString(@"手动模式", nil);
                break;
            case 3:
                _workmode_status.text = NSLocalizedString(@"安装模式", nil);
                break;
                
        }
        
       _label_setting.text =  [NSString stringWithFormat:@"%d%@%@",sta,(xiaoshu==0?@".0":@".5"),@"℃"];
       _label_shishi.text =[NSString stringWithFormat:@"%d%@",shishi_temp2,@"℃"];
    }
    

    
    
    
}

-(void)clickItem{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    deleteDeviceApi *deleteApi = [[deleteDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey mDeviceID:_data.devID];
    replaceDeviceApi *replaceApi = [[replaceDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey mDeviceID:_data.devID];
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        WS(ws)
        if (buttonIndex == 2) {
            if (!_isDeleting) {
                __block NSObject *obj = [[NSObject alloc] init];
                _isDeleting = YES;
                [deleteApi startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
                    _isDeleting = NO;
                    
                    NSDictionary *dic = data;
                    dic = [dic objectForKey:@"params"];
                    dic = [dic objectForKey:@"data"];
                    long isSuccess = [[dic objectForKey:@"answer_yes_or_no"] longValue];
                    if (isSuccess == 2) {
                        [ws deleteDevice];
                        [ws.navigationController popViewControllerAnimated:YES];
                    }else{
                        [MBProgressHUD showError:NSLocalizedString(@"删除失败",nil) ToView:ws.view];
                    }
                    //                    [obj setValue:@"1" forKey:@"1"];
                    obj = nil;
                } failure:^(id data, NSError *error) {
                    _isDeleting = NO;
                    //                    [obj setValue:@"1" forKey:@"1"];
                    obj = nil;
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_isDeleting) {
                        _isDeleting = NO;
                        [MBProgressHUD showError:NSLocalizedString(@"删除失败",nil) ToView:ws.view];
                        obj = nil;
                        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                        if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
                            [config setObject:NetworkAppStatus forKey:AppStatus];
                        }
                    }
                });
            }
            
        }else if (buttonIndex == 1){
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"DeviceStoryboard" bundle:nil];
            AddDeviceVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddDeviceVC"];
            vc.devID = ws.data.devID;
            BaseNC *nav = [[BaseNC alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [ws.navigationController presentViewController:nav animated:YES completion:nil];
            [ws.navigationController popToRootViewControllerAnimated:YES];
            
        }else if(buttonIndex == 3){
            UIStoryboard *deviceStoryboard = [UIStoryboard storyboardWithName:@"DeviceStoryboard" bundle:nil];
            RenameVC *vc = [deviceStoryboard instantiateViewControllerWithIdentifier:@"RenameVC"];
            vc.deviceId = self.data.devID;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
        }
    } otherButtonTitles:NSLocalizedString(@"替换设备",nil),NSLocalizedString(@"删除设备",nil),NSLocalizedString(@"重命名",nil), nil];
    actionSheet.buttonFont = [UIFont systemFontOfSize:14];
    actionSheet.buttonHeight = 44.0f;
    actionSheet.buttonColor = RGB(36, 155, 255);
    actionSheet.unBlur = YES;
    [actionSheet show];
}

- (void)deleteDevice{
    [[DeviceDataBase sharedDataBase] deletDevice:[_data.devID intValue]];
    [MBProgressHUD showSuccess:NSLocalizedString(@"删除成功",nil) ToView:self.view];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotosetting{
    TempControlSettingVC *vc = [[TempControlSettingVC alloc] init];
    vc.data = self.data;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lodaData{
    self.data = [[DeviceDataBase sharedDataBase] selectDevice:self.data.devID];
    [self setPageBackground];
    [self analysisStatus];
}

@end
