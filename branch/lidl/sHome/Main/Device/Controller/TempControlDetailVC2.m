//
//  TempControlDetailVC2.m
//  sHome
//
//  Created by tracyhenry on 2018/11/8.
//  Copyright © 2018 shaop. All rights reserved.
//

#import "TempControlDetailVC2.h"
#import "UINavigationBar+Awesome.h"
#import "BatterHelp.h"
#import "DeviceListModel.h"
#import "deleteDeviceApi.h"
#import <LCActionSheet.h>
#import "RenameVC.h"
#import "AddDeviceVC.h"
#import "BaseNC.h"
#import "DeviceDataBase.h"
#import "CYCircularSlider.h"
#import "TempControlTimerListVC.h"
#import "PostControllerApi.h"
#import "MainDeviceApi.h"
#import "DeviceListModel.h"
#import "Encryptools.h"
#import "MyUdp.h"
#import "AppStatusHelp.h"
#import "TXScrollLabelView.h"
#import "NSString+CY.h"
#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)
@interface TempControlDetailVC2()<senderValueChangeDelegate>
@property (nonatomic) UIImageView *bgImageView;
@property (nonatomic) UILabel *MainLabel;
@property (nonatomic) UIImageView *wifiImgV;
@property (nonatomic) UIImageView *batteryImgV;
@property (nonatomic) UILabel *batterytext;
@property (nonatomic,strong)CYCircularSlider *circularSlider;
@property (nonatomic,strong) UIButton *timer_modeBtn;
@property (nonatomic,strong) UIButton *handler_modeBtn;
@property (nonatomic,strong) UIButton *fangdong_modeBtn;
@property (nonatomic,strong) UIImageView *imageline;
@property (nonatomic,strong) UIView *imageline_middle;
@property (nonatomic,strong) UIButton *valveimg;
@property (nonatomic,strong) UIButton *tongsuoimg;
@property (nonatomic,strong) UIButton *windowimg;
@property (nonatomic,strong) UISwitch *switch_valve;
@property (nonatomic,strong) UISwitch *switch_tongsuo;
@property (nonatomic,strong) UISwitch *switch_window;
@property (nonatomic,strong) UILabel *temp_setting_label;
@property (nonatomic,strong) UILabel *temp_shishi_label;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIAlertController *alert;
@property (nonatomic) TXScrollLabelView *titleLabel2;
@end

@implementation TempControlDetailVC2
{
        BOOL _isDeleting;
        int mode;
    BOOL _isSetting;
    float settemp_total;
    int height_of_5s;
}


#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    height_of_5s = [[AppStatusHelp getDeviceName] containsString:@"iPhone 5"]?0:40;
    [self setupBaseUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData:) name:@"updateDeviceSuccess" object:nil];
    
    NSString *autotemp = [[DeviceDataBase sharedDataBase] getGs361Autotemp:_data.devID];
    NSString *handtemp = [[DeviceDataBase sharedDataBase] getGs361Handtemp:_data.devID];
    NSString *fangtemp = [[DeviceDataBase sharedDataBase] getGs361Fangtemp:_data.devID];
    NSLog(@"三种设置温度缓存值为%@,%@,%@",autotemp,handtemp,fangtemp);
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    if([_data.customTitle isEqualToString:@""]){
        [self titleLabel2].scrollTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(_data.title, nil),_data.devID];
    }else{
        [self titleLabel2].scrollTitle = _data.customTitle;
    }
    if([self titleLabel2].upLabel.frame.size.width <=200){
        [[self titleLabel2] endScrolling];
    }else{
        [[self titleLabel2] beginScrolling];
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"管理",nil) withTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"back_icon" highImage:nil withTintColor:[UIColor whiteColor]];
    [self setPageBackground];
  
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma -mark method
- (void)setupBaseUI {
    
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:_bgImageView];
    [_bgImageView setImage:[UIImage imageNamed:@"sbodarkblue_bg"]];
    _MainLabel = [[UILabel alloc] init];
    _MainLabel.font = [UIFont systemFontOfSize:17];
    _MainLabel.textColor = [UIColor blackColor];
    _MainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_MainLabel];
    [_MainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(75+(kIPhoneX?24:0));
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
    
   CGRect sliderFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width-275)/2, 120+(kIPhoneX?24:0), 275,275);
    _circularSlider =[[CYCircularSlider alloc]initWithFrame:sliderFrame];
    [self.view addSubview:_circularSlider];
        _circularSlider.delegate = self;
    _circularSlider.handleColor = HEXCOLOR(0x33a7ff);
    _circularSlider.handleColor2 = HEXCOLOR(0xffffff);

    
    _timer_modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timer_modeBtn setImage:[UIImage imageNamed:@"ui361a_timer"] forState:UIControlStateNormal];
    [_timer_modeBtn setImage:[UIImage imageNamed:@"ui361a_timer_select"] forState:UIControlStateSelected];
    [_timer_modeBtn setTag:1];
    [_timer_modeBtn setBackgroundColor:HEXCOLOR(0xeaeaea)];
    [_timer_modeBtn addTarget:self action:@selector(modeselect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timer_modeBtn];
    [_timer_modeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(Main_Screen_Width/3);
        make.height.equalTo(70);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-110-height_of_5s);
    }];
    
    _handler_modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_handler_modeBtn setImage:[UIImage imageNamed:@"ui361a_handle"] forState:UIControlStateNormal];
    [_handler_modeBtn setImage:[UIImage imageNamed:@"ui361a_handle_select"] forState:UIControlStateSelected];
     [_handler_modeBtn setTag:2];
    [_handler_modeBtn setBackgroundColor:HEXCOLOR(0xeaeaea)];
    [_handler_modeBtn addTarget:self action:@selector(modeselect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_handler_modeBtn];
    [_handler_modeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(Main_Screen_Width/3);
        make.height.equalTo(70);
        make.left.equalTo(_timer_modeBtn.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-110-height_of_5s);
    }];
    
    _fangdong_modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fangdong_modeBtn setImage:[UIImage imageNamed:@"ui361a_fangdong"] forState:UIControlStateNormal];
    [_fangdong_modeBtn setImage:[UIImage imageNamed:@"ui361a_fangdong_select"] forState:UIControlStateSelected];
    [_fangdong_modeBtn setTag:0];
    [_fangdong_modeBtn setBackgroundColor:HEXCOLOR(0xeaeaea)];
    [_fangdong_modeBtn addTarget:self action:@selector(modeselect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fangdong_modeBtn];
    [_fangdong_modeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(Main_Screen_Width/3);
        make.height.equalTo(70);
        make.left.equalTo(_handler_modeBtn.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-110-height_of_5s);
    }];
    
    
    UIView *imagelinebg = [[UIView alloc] init];
    [imagelinebg setBackgroundColor:HEXCOLOR(0xeaeaea)];
    [self.view addSubview:imagelinebg];
    [imagelinebg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.left.equalTo(0);
        make.top.equalTo(_handler_modeBtn.mas_bottom);
        make.height.equalTo(5);
    }];
    
    _imageline = [[UIImageView alloc] init];
    [_imageline setImage:[UIImage imageNamed:@"ui361a_line"]];
    [self.view addSubview:_imageline];
    [_imageline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-50);
        make.left.equalTo(50);
        make.top.equalTo(_handler_modeBtn.mas_bottom);
        make.centerX.equalTo(self.view.centerX);
        make.height.equalTo(5);
    }];
    
    _valveimg = [UIButton buttonWithType:UIButtonTypeCustom];
    [_valveimg setImage:[UIImage imageNamed:@"ui361a_famen_normal"] forState:UIControlStateNormal];
    [_valveimg setImage:[UIImage imageNamed:@"ui361a_famen_disable"] forState:UIControlStateDisabled];
    [_valveimg setImage:[UIImage imageNamed:@"ui361a_famen_error"] forState:UIControlStateSelected];
    [_valveimg setBackgroundColor:HEXCOLOR(0xeaeaea)];
    [self.view addSubview:_valveimg];
    [_valveimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(Main_Screen_Width/3);
        make.height.equalTo(70);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(imagelinebg.mas_bottom);
    }];
    
    _tongsuoimg = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tongsuoimg setImage:[UIImage imageNamed:@"ui361a_suo_disable"] forState:UIControlStateNormal];
    [_tongsuoimg setImage:[UIImage imageNamed:@"ui361a_suo_select"] forState:UIControlStateSelected];
    [_tongsuoimg setBackgroundColor:HEXCOLOR(0xeaeaea)];
    [self.view addSubview:_tongsuoimg];
    [_tongsuoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(Main_Screen_Width/3);
        make.height.equalTo(70);
        make.left.equalTo(_valveimg.mas_right);
        make.top.equalTo(imagelinebg.mas_bottom);
    }];
    
    _windowimg = [UIButton buttonWithType:UIButtonTypeCustom];
    [_windowimg setImage:[UIImage imageNamed:@"ui361a_window_normal"] forState:UIControlStateNormal];
    [_windowimg setImage:[UIImage imageNamed:@"ui361a_window_disable"] forState:UIControlStateDisabled];
    [_windowimg setImage:[UIImage imageNamed:@"ui361a_window_open"] forState:UIControlStateSelected];
    [_windowimg setBackgroundColor:HEXCOLOR(0xeaeaea)];
    [self.view addSubview:_windowimg];
    [_windowimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(Main_Screen_Width/3);
        make.height.equalTo(70);
        make.left.equalTo(_tongsuoimg.mas_right);
        make.top.equalTo(imagelinebg.mas_bottom);
    }];
    
    UIView *hbtom = [[UIView alloc] init];
    [hbtom setBackgroundColor:HEXCOLOR(0xeaeaea)];
    [self.view addSubview:hbtom];
    [hbtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.left.equalTo(0);
        make.top.equalTo(_valveimg.mas_bottom);
        make.height.equalTo(40+height_of_5s);
    }];
    
    _switch_valve = [[UISwitch alloc] init];
    _switch_valve.tag = 1;
    _switch_valve.onTintColor = RGB(5, 128, 255);
    [self.view addSubview:_switch_valve];
    [_switch_valve mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_valveimg.mas_centerX);
        make.top.equalTo(_valveimg.mas_bottom);
    }];
    
    _switch_tongsuo = [[UISwitch alloc] init];
    _switch_tongsuo.tag = 2;
    _switch_tongsuo.onTintColor = RGB(5, 128, 255);
    [self.view addSubview:_switch_tongsuo];
    [_switch_tongsuo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tongsuoimg.mas_centerX);
        make.top.equalTo(_tongsuoimg.mas_bottom);
    }];
    
    _switch_window = [[UISwitch alloc] init];
    _switch_window.tag = 3;
    _switch_window.onTintColor = RGB(5, 128, 255);
    [self.view addSubview:_switch_window];
    [_switch_window mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_windowimg.mas_centerX);
        make.top.equalTo(_windowimg.mas_bottom);
    }];
    
    _imageline_middle = [[UIView alloc] initWithFrame:CGRectZero];
    [_imageline_middle setBackgroundColor:HEXCOLOR(0xcdcdcd)];
    [self.view addSubview:_imageline_middle];
    [_imageline_middle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(_circularSlider.mas_centerY);
        make.width.equalTo(150);
        make.height.equalTo(1);
    }];
    
    _temp_setting_label = [[UILabel alloc] initWithFrame:CGRectZero];
    [_temp_setting_label setFont:SYSTEMFONT(42)];
    [_temp_setting_label setTextColor:HEXCOLOR(0xde6459)];
    [_temp_setting_label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_temp_setting_label];
    [_temp_setting_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(150);
        make.height.equalTo(30);
        make.centerX.equalTo(_imageline_middle.mas_centerX);
        make.bottom.equalTo(_imageline_middle.mas_top).offset(-20);
    }];
    
    _temp_shishi_label = [[UILabel alloc] initWithFrame:CGRectZero];
    [_temp_shishi_label setFont:SYSTEMFONT(42)];
    [_temp_shishi_label setTextAlignment:NSTextAlignmentCenter];
    [_temp_shishi_label setTextColor:HEXCOLOR(0x0099ff)];
    [self.view addSubview:_temp_shishi_label];
    [_temp_shishi_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(150);
        make.centerX.equalTo(_imageline_middle.mas_centerX);
        make.height.equalTo(30);
        make.top.equalTo(_imageline_middle.mas_bottom).offset(20);
    }];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_saveBtn setBackgroundColor:ThemeColor];
    [_saveBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setFont:SYSTEMFONT(20)];
    _saveBtn.layer.cornerRadius = 10.5f;
    _saveBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    [_saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(_batteryImgV.mas_bottom).offset(10);
    }];

}

-(void)clickItem{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    deleteDeviceApi *deleteApi = [[deleteDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey mDeviceID:_data.devID];
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

/**
 设备背景图片
 */
-(void)setPageBackground{
    [_bgImageView setImage:[UIImage imageNamed:@"sbodarkblue_bg"]];
    if ([_data.status isEqualToString:@"no"]){
        _MainLabel.text = NSLocalizedString(@"离线",nil);
        [_bgImageView setImage:[UIImage imageNamed:@"sbgray_bg"]];
    }else if ([_data.status isEqualToString:@"aq"]) {
        _MainLabel.text = NSLocalizedString(@"正常",nil);
        [_bgImageView setImage:[UIImage imageNamed:@"sbodarkblue_bg"]];
    }
    else if ([_data.status isEqualToString:@"gz"]){
        _MainLabel.text = NSLocalizedString(@"低电压",nil);
        [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];
    }
    
    self.data = [[DeviceDataBase sharedDataBase] selectDevice:self.data.devID];
    if (![self.data.status isEqualToString:@"no"]) {
        NSString *signal = [_data.statuCode substringWithRange:NSMakeRange(0, 2)];
        
        NSNumber *num = [BatterHelp numberHexString:signal];
        int b = [num intValue];
        int a =(b&0x07);
        
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
        if ([battery isEqualToString:@"FF"]) {
        }
        else if ([battery isEqualToString:@"80"]){
            self.batterytext.text = @"0%";
            [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg40_icon"]];
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
    
    NSString *signal1 = [_data.statuCode substringWithRange:NSMakeRange(0, 2)];
    NSString *status1 = [_data.statuCode substringWithRange:NSMakeRange(4, 2)];
    NSString *status2 =[_data.statuCode substringWithRange:NSMakeRange(6, 2)];

  
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
    
    if(mode2==0){
        [_circularSlider setMaximumValue:15];
        [_fangdong_modeBtn setSelected:YES];
        [_timer_modeBtn setSelected:NO];
        [_handler_modeBtn setSelected:NO];
    }else if(mode2 == 1){
         [_circularSlider setMaximumValue:30];
        [_fangdong_modeBtn setSelected:NO];
        [_timer_modeBtn setSelected:YES];
        [_handler_modeBtn setSelected:NO];
    }else if(mode2 == 2){
        [_circularSlider setMaximumValue:30];
        [_fangdong_modeBtn setSelected:NO];
        [_timer_modeBtn setSelected:NO];
        [_handler_modeBtn setSelected:YES];
    }else {
        [_circularSlider setMaximumValue:30];
        [_fangdong_modeBtn setSelected:NO];
        [_timer_modeBtn setSelected:YES];
        [_handler_modeBtn setSelected:NO];
    }
    mode = mode2;
    float fa = (sta + (xiaoshu==0?0.0f:0.5f));
    if ([self.data.status isEqualToString:@"no"]) {
        [self setSetingTemp:5.0f];
        _temp_shishi_label.text = [NSString stringWithFormat:@"%d℃",0];
    }else{
        [self setSetingTemp:fa];
        _temp_shishi_label.text = [NSString stringWithFormat:@"%d℃",shishi_temp2 ];
    }

    if(status_tongsuo==0){
        [_tongsuoimg setSelected:NO];
        [_switch_tongsuo setOn:NO];
    }else{
        [_tongsuoimg setSelected:YES];
        [_switch_tongsuo setOn:YES];
    }
    
    if(shineng_window2!=0) {
        [_switch_window setOn:YES];
        if (status_window2 != 0) {
            [_windowimg setEnabled:YES];
            [_windowimg setSelected:YES];
        } else {
            [_windowimg setEnabled:YES];
            [_windowimg setSelected:NO];
        }
    }else {
        [_windowimg setEnabled:NO];
         [_switch_window setOn:NO];
    }
    if(shineng_valve2!=0) {
        [_switch_valve setOn:YES];
        if (status_valve2 != 0) {
             [_valveimg setEnabled:YES];
             [_valveimg setSelected:YES];
        } else {
             [_valveimg setEnabled:YES];
            [_valveimg setSelected:NO];
        }
    }else{
        [_valveimg setEnabled:NO];
        [_switch_valve setOn:NO];
    }
    
    if(mode2==3&&![self.data.status isEqualToString:@"no"]){
        _alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"温控器安装到阀门上后,请再一次按下旋钮", nil) preferredStyle:UIAlertControllerStyleAlert];
        [_alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:_alert animated:YES completion:^{
            
        }];
       
    }else{
        if(_alert!=nil){
          [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            _alert = nil;
        }
        if(mode2==0){
            [[DeviceDataBase sharedDataBase] UpdateGs361FangTemp:[NSString stringWithFormat:@"%.1f",fa] withDevId:_data.devID];
        }else if(mode2==1){
            [[DeviceDataBase sharedDataBase] UpdateGs361AutoTemp:[NSString stringWithFormat:@"%.1f",fa] withDevId:_data.devID];
        }else if(mode2==2){
            [[DeviceDataBase sharedDataBase] UpdateGs361HandTemp:[NSString stringWithFormat:@"%.1f",fa] withDevId:_data.devID];
        }
    }
    

         settemp_total = 0;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setSetingTemp:(float)temp{
    [_circularSlider setCurrentValue:temp];
    _temp_setting_label.text = [NSString stringWithFormat:@"%0.1f℃",temp ];
}

-(void)modeselect:(UIButton *)btn{
    NSInteger tag = btn.tag;
    if(tag==1){
        [_circularSlider setMaximumValue:30];
        if(mode!=1){
            [_timer_modeBtn setSelected:YES];
            [_handler_modeBtn setSelected:NO];
            [_fangdong_modeBtn setSelected:NO];
            
            NSString *temp= [[DeviceDataBase sharedDataBase] getGs361Autotemp:_data.devID];
            if([NSString isBlankString:temp]){
                [self setSetingTemp:21.0f];
            }else {
                [self setSetingTemp:[temp floatValue]];
            }
            
        }else{
            TempControlTimerListVC *vc = [[TempControlTimerListVC alloc] init];
            vc.devID = _data.devID;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        mode = 1;

    }else if(tag == 2){
        mode = 2;
        [_timer_modeBtn setSelected:NO];
        [_handler_modeBtn setSelected:YES];
        [_fangdong_modeBtn setSelected:NO];
        
        [_circularSlider setMaximumValue:30];
        
        NSString *temp= [[DeviceDataBase sharedDataBase] getGs361Handtemp:_data.devID];
        if([NSString isBlankString:temp]){
            [self setSetingTemp:21.0f];
        }else {
            [self setSetingTemp:[temp floatValue]];
        }
    }else if(tag == 0){
        mode = 0;
        [_timer_modeBtn setSelected:NO];
        [_handler_modeBtn setSelected:NO];
        [_fangdong_modeBtn setSelected:YES];
        
        [_circularSlider setMaximumValue:15];
        
        NSString *temp= [[DeviceDataBase sharedDataBase] getGs361Fangtemp:_data.devID];
        if([NSString isBlankString:temp]){
            [self setSetingTemp:5.0f];
        }else {
            [self setSetingTemp:[temp floatValue]];
        }
    }
}


-(NSString *)getCode{
    
    float settemp = _circularSlider.currentValue;
    NSString *setempxiaoshu = [NSString stringWithFormat:@"%f",settemp ];
    int xiaoshu = ([setempxiaoshu containsString:@".5"]? 1:0);
    int temp_total = (int)floorf(settemp);
    int tong = (_switch_tongsuo.isOn?1:0);
    int window= (_switch_window.isOn?1:0);
    int valve = (_switch_valve.isOn?1:0);
    
    int  ds= 0x00,ds2 = 0x00;
    
    ds= ((window==0?0x00:0x80)|ds);
    ds= ((valve==0?0x00:0x40)|ds);
    ds= ((xiaoshu==0?0x00:0x20)|ds);
    ds= ((temp_total&0x1F)|ds);
    
    ds2= ((tong==0?0x00:0x04)|ds2);
    ds2= ((mode&0x03)|ds2);
    
    NSString *str1 = [BatterHelp gethexBybinary:ds];
    NSString *str2 = [BatterHelp gethexBybinary:ds2];
    if (str1.length < 2) {
        str1 = [@"0" stringByAppendingString:str1];
    }
    if (str2.length < 2) {
        str2 = [@"0" stringByAppendingString:str2];
    }
    return [NSString stringWithFormat:@"%@%@%@",str1,str2,@"0000" ];
}

-(void)save{
    NSString *command = [self getCode];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    PostControllerApi *post = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[self.data.devID intValue] DeviceStatus:command];
    [MBProgressHUD showLoadToView:GetWindow];
    if (!_isSetting) {
        __block NSObject *obj = [[NSObject alloc] init];
        _isSetting = YES;
        settemp_total = _circularSlider.currentValue;
        [post startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
            [MBProgressHUD hideHUD];
            NSDictionary *dic = data;
            dic = [dic objectForKey:@"params"];
            dic = [dic objectForKey:@"data"];
            long isSuccess = [[dic objectForKey:@"answer_yes_or_no"] longValue];
            if (isSuccess == 2) {
                [MBProgressHUD showSuccess:NSLocalizedString(@"设置完成",nil) ToView:GetWindow];
            }else{
                [MBProgressHUD showError:NSLocalizedString(@"设置失败",nil) ToView:GetWindow];
            }
            obj = nil;
        } failure:^(id data, NSError *error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            _isSetting = NO;
            obj = nil;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isSetting) {
                [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                _isSetting = NO;
                obj = nil;
            }
        });
    }
    
}


-(void)lodaData:(NSNotification *)notification{
    NSNumber *getsendValue = [[notification userInfo] valueForKey:@"device_ID"];
    if( [getsendValue intValue] == [self.data.devID intValue] ){
        self.data = [[DeviceDataBase sharedDataBase] selectDevice:self.data.devID];
        [self setPageBackground];
    }

}


#pragma -mark delegate
-(void)senderVlueWithNum:(float)num{
   
    
}

-(void)senderMoveWithFloat:(float)num{
    _temp_setting_label.text = [NSString stringWithFormat:@"%.1f℃",num ];
}

#pragma -mark lazy
-(TXScrollLabelView *)titleLabel2{
    if(_titleLabel2 == nil){
        _titleLabel2 = [TXScrollLabelView scrollWithTitle:@"" type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
        /** Step4: 布局(Required) */
        _titleLabel2.frame = CGRectMake(30, 7, 200, 30);
        
        
        
        //偏好(Optional), Preference,if you want.
        _titleLabel2.tx_centerY = 22;
        _titleLabel2.userInteractionEnabled = NO;
        _titleLabel2.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
        _titleLabel2.scrollSpace = 10;
        _titleLabel2.font = [UIFont systemFontOfSize:15];
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
        _titleLabel2.scrollTitleColor = [UIColor whiteColor];
        _titleLabel2.backgroundColor = [UIColor clearColor];
        _titleLabel2.layer.cornerRadius = 5;
        self.navigationItem.titleView=_titleLabel2;
    }
    return _titleLabel2;
}
@end
