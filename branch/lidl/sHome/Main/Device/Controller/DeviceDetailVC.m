//
//  DeviceDetailVC.m
//  sHome
//
//  Created by shaop on 2016/12/19.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "DeviceDetailVC.h"
#import "UINavigationBar+Awesome.h"
#import "WarningTableView.h"
#import "POP.h"
#import "BaseNC.h"
#import "AddDeviceVC.h"
#import "LCActionSheet.h"
#import "BatterHelp.h"
#import "DeviceListModel.h"
#import "DeviceModel.h"
//#import "DeviceMapHelp.h"
#import "PostControllerApi.h"
#import "deleteDeviceApi.h"
#import "replaceDeviceApi.h"
#import "DeviceDataBase.h"
#import "RenameVC.h"
#import "UserInfoModel.h"
#import "MyUdp.h"
#import "GetAlarmsApi.h"
#import "HekrAlarmModel.h"
#import "EquipmentState.h"

#import "MainDeviceApi.h"
#import "LEEAlert.h"
#import "Encryptools.h"
#import "TXScrollLabelView.h"
#import "DeviceWarningListViewController.h"
#import "LCAlertViewController.h"
#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)
@interface DeviceDetailVC ()<WarningTableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *borderView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *MainLabel;
@property (strong, nonatomic) IBOutlet UIView *centerLine;
@property (strong, nonatomic) IBOutlet UIButton *TestBtn;
@property (strong, nonatomic) IBOutlet UIButton *PhoneBtn;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) WarningTableView *table;
//@property (strong, nonatomic) UILabel *signalLabel;
@property (strong, nonatomic) UILabel *batteryLabel;
@property (strong, nonatomic) IBOutlet UISwitch *deviceSwitch;

@property (nonatomic) UIImageView *wifiImgV;
@property (nonatomic) UIImageView *batteryImgV;

@property (nonatomic) UITextField *textf;

//@property (nonatomic, assign) BOOL isShowTip;

@property (nonatomic) UISwitch *switch1;
@property (nonatomic) UISwitch *switch2;
@property (nonatomic) TXScrollLabelView *titleLabel2;

@property (nonatomic,strong) UIView *bottomview;

@property (strong,nonatomic) IBOutlet UIButton *AutoBtn;
@property (strong,nonatomic) IBOutlet UIButton *SilenceBtn;
@property (strong,nonatomic) IBOutlet UIButton *Test2Btn;
@property(strong) LCAlertViewController * alertVC;
@end

@implementation DeviceDetailVC
{
    CGPoint _bottomPoint;
    CGPoint _beginPoint;
    
    BOOL _isReplcing;
    BOOL _isDeleting;
    BOOL _isSwitching;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bottomview];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.bottomview addGestureRecognizer:recognizer];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottom:)];
    [self.bottomview addGestureRecognizer:tap];
    _switch1 = [[UISwitch alloc] init];
    _switch1.tag = 11;
    _switch1.hidden = YES;
    _switch1.onTintColor = RGB(5, 128, 255);
    [self.view addSubview:_switch1];
    [_switch1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.borderView.mas_bottom).offset(44);
    }];
    [_switch1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    _switch2 = [[UISwitch alloc] init];
    _switch2.tag = 22;
    _switch2.hidden = YES;
    _switch2.onTintColor = RGB(5, 128, 255);
    [self.view addSubview:_switch2];
    [_switch2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.switch1.mas_bottom).offset(44);
    }];
    [_switch2 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData) name:@"updateDeviceSuccess" object:nil];
    
    self.navigationController.navigationBar.alpha = 1;
    
    
    if([_data.customTitle isEqualToString:@""]){
        //self.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(_data.title, nil),_data.devID];
        [self titleLabel2].scrollTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(_data.title, nil),_data.devID];
    }else{
        //self.title = _data.customTitle;
        [self titleLabel2].scrollTitle = _data.customTitle;
    }
    if([self titleLabel2].upLabel.frame.size.width <=200){
        [[self titleLabel2] endScrolling];
    }else{
        [[self titleLabel2] beginScrolling];
    }
    
    
    _borderView.layer.cornerRadius = 100.0f;
    _borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _borderView.layer.borderWidth = 1.0f;
    
    _bgView.layer.cornerRadius = 90.0f;
    
    _TestBtn.layer.cornerRadius = 22.0f;
    _PhoneBtn.layer.cornerRadius = 22.0f;
    
    [self setDevice];
    
    [self setPageBackground];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"管理",nil) withTintColor:[UIColor whiteColor]];
    
//    _table = [[WarningTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
//    _table.mdelegate = self;
//    [self.view addSubview:_table];
//    WS(ws)
//    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(ws.view.mas_left);
//        make.right.equalTo(ws.view.mas_right);
//        make.top.equalTo(ws.bottomView.mas_bottom);
//        make.height.equalTo(ws.view.mas_height);
//    }];
    
//    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                 action:@selector(handlePan:)];
//    [self.bottomView addGestureRecognizer:recognizer];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottom:)];
//    [self.bottomView addGestureRecognizer:tap];
    
    [self analysisStatus];
    [self currentDevice];
    
    //弹动一下
    BOOL animated = [self.bottomview.layer pop_animationKeys] > 0;
    if (!animated) {
        POPDecayAnimation *scollerTop = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        scollerTop.velocity = @(-30);
        [_bottomview.layer pop_addAnimation:scollerTop forKey:@"scollerTop"];

        WS(ws)
        scollerTop.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            POPSpringAnimation *dropAnamation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
            dropAnamation.toValue = @(0);
            dropAnamation.springBounciness = 20;
            [ws.bottomview.layer pop_addAnimation:dropAnamation forKey:@"dropAnamation"];
        };
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.isShowTip = NO;
}


/**
 管理按钮点击
 */
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
            [self performSegueWithIdentifier:@"toRename" sender:nil];
        }else{
        }
        
    } otherButtonTitles:NSLocalizedString(@"替换设备",nil),NSLocalizedString(@"删除设备",nil),NSLocalizedString(@"重命名",nil), nil];
    actionSheet.buttonFont = [UIFont systemFontOfSize:14];
    actionSheet.buttonHeight = 44.0f;
    actionSheet.buttonColor = RGB(36, 155, 255);
    actionSheet.unBlur = YES;
    [actionSheet show];
}

-(void)deleteDevice{
    [[DeviceDataBase sharedDataBase] deletDevice:[_data.devID intValue]];
    [MBProgressHUD showSuccess:NSLocalizedString(@"删除成功",nil) ToView:self.view];
}

/**
 实时更新设备
 */
- (void)currentDevice{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *_model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    NSDictionary *dic = @{@"action" : @"devSend",
                          @"params" : @{
                                  @"devTid" : _model.devTid,
                                  @"data" : @{
                                          @"cmdId" : @19,
                                          @"device_ID" : @([self.data.devID intValue])
                                          }
                                  }
                          };
    
    NSDictionary *dic2 = @{@"action" : @"devSend",
                          @"params" : @{
                                  @"devTid" : _model.devTid,
                                  @"data" : @{
                                          @"cmdId" : @119,
                                          @"device_ID" : @([self.data.devID intValue])
                                          }
                                  }
                          };
    WS(ws)
    if (![[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
        [[Hekr sharedInstance] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
            if (!error) {
                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
                ws.data = [DeviceMapHelp ItemWithDeivce:model];
                [ws analysisStatus];
                [ws tarnslateBackgroundImageView];
//                if (self.isShowTip == YES) {
//                    [self showOpenDoorStatusWith:data];
//                }
            }
        }];
        
        [[Hekr sharedInstance] recv:dic2 obj:self callback:^(id obj, id data, NSError *error) {
            if (!error) {
                NSNumber *msgId=data[@"msgId"];
                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
                int newa = [Encryptools getDescryption:model.device_ID withMsgId:[msgId intValue]];
                [model setDevice_ID:newa];
                ws.data = [DeviceMapHelp ItemWithDeivce:model];
                [ws analysisStatus];
                [ws tarnslateBackgroundImageView];
                //                if (self.isShowTip == YES) {
                //                    [self showOpenDoorStatusWith:data];
                //                }
            }
        }];
    }
    else{
        [[MyUdp shared] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
            if (!error) {
                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
                ws.data = [DeviceMapHelp ItemWithDeivce:model];
                [ws analysisStatus];
                [ws tarnslateBackgroundImageView];
//                if (self.isShowTip == YES) {
//                    [self showOpenDoorStatusWith:data];
//                }
            }
        }];
        
        [[MyUdp shared] recv:dic2 obj:self callback:^(id obj, id data, NSError *error) {
            if (!error) {
                NSNumber *msgId=data[@"msgId"];
                DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
                int newa = [Encryptools getDescryption:model.device_ID withMsgId:[msgId intValue]];
                [model setDevice_ID:newa];
                ws.data = [DeviceMapHelp ItemWithDeivce:model];
                [ws analysisStatus];
                [ws tarnslateBackgroundImageView];
                //                if (self.isShowTip == YES) {
                //                    [self showOpenDoorStatusWith:data];
                //                }
            }
        }];
        
    }
}

/**
 设置各类页面的信息
 */
-(void)setDevice{
    
    if ([self.data.status isEqualToString:@"no"]) {
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:YES];
        
        if([self.data.title isEqualToString:@"智能插座"]){
            [_deviceSwitch setHidden:NO];
        } else if ([self.data.title isEqualToString:@"双路开关"]) {
            //
        }
    }
    
    if([self.data.title isEqualToString:@"水感报警器"]||
       [self.data.title isEqualToString:@"SM报警器"]||
       [self.data.title isEqualToString:@"CO报警器"]||
       [self.data.title isEqualToString:@"复合型烟感"] ||
       [self.data.title isEqualToString:@"热感报警器"]){
        //报警类设备显示测试、电话按钮
        [_deviceSwitch setHidden:YES];
       DeviceModel *dev = [[DeviceDataBase sharedDataBase] selectDeviceNew:self.data.devID];
        if(dev!=nil && ([dev.device_name containsString:@"008"] || [dev.device_name containsString:@"009"] || [dev.device_name containsString:@"00A"] || [dev.device_name containsString:@"00B"] || [dev.device_name containsString:@"00C"]
                        || [dev.device_name containsString:@"00D"] )){
               [_TestBtn setHidden:YES];
            [self.wifiImgV setHidden:YES];
            [self.batteryImgV setHidden:YES];
            [self.batteryLabel setHidden:YES];
        }else{
             [_TestBtn setHidden:NO];
            [self.wifiImgV setHidden:NO];
            [self.batteryImgV setHidden:NO];
            [self.batteryLabel setHidden:NO];
        }
     
        
    }else if([self.data.title isEqualToString:@"智能插座"]){
        //插座类只显示开关
        [_TestBtn setHidden:YES];
        [_PhoneBtn setHidden:YES];
        
        if (self.data.statuCode.length >= 8) {
            if ([[self.data.statuCode substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"FF"]||[[self.data.statuCode substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"]) {
                [_deviceSwitch setOn:YES];
            }else{
                [_deviceSwitch setOn:NO];
            }
        }
    }
    else if([self.data.title isEqualToString:@"PIR探测器"] ||
            [self.data.title isEqualToString:@"门磁"] ||
            [self.data.title isEqualToString:@"SOS按钮"] ||
            [self.data.title isEqualToString:@"按键"]) {
        //探测器显示紧急电话
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:YES];

    }
    else if ([self.data.title isEqualToString:@"温湿度探测器"]) {
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:NO];
        [self.PhoneBtn setHidden:NO];
        
        NSString *temp = [self.data.statuCode substringWithRange:NSMakeRange(4, 2)];
        NSString *one = [BatterHelp getBinaryByhex:temp];
        one = one.length < 8 ? [@"0000" stringByAppendingString:one] : one;
        one = [one substringWithRange:NSMakeRange(0, 1)];
        NSNumber *tempNum = [BatterHelp numberHexString:temp];
        
        NSString *hum = [self.data.statuCode substringWithRange:NSMakeRange(6, 2)];
        NSNumber *humNum = [BatterHelp numberHexString:hum];
        if ([one isEqualToString:@"1"]) {
            int ttemp = [tempNum intValue] - 256;
            
            [_TestBtn setTitle:[NSString stringWithFormat:@"T:%d", ttemp] forState:UIControlStateNormal];
        } else {
            [_TestBtn setTitle:[NSString stringWithFormat:@"T:%@", [tempNum stringValue]] forState:UIControlStateNormal];
        }
        
        [self.PhoneBtn setTitle:[NSString stringWithFormat:@"H:%@", [humNum stringValue]] forState:UIControlStateNormal];
        
        _TestBtn.userInteractionEnabled = NO;
        self.PhoneBtn.userInteractionEnabled = NO;
    }
    else if ([self.data.title isEqualToString:@"门锁"]) {
        [_deviceSwitch setHidden:YES];
        [_PhoneBtn setHidden:NO];
        [_TestBtn setHidden:NO];
        [_TestBtn setTitle:NSLocalizedString(@"开锁", nil) forState:UIControlStateNormal];
    }
    else if ([self.data.title isEqualToString:@"气体探测器"]) {
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:NO];
        [self.PhoneBtn setHidden:NO];
    }
    else if ([self.data.title isEqualToString:@"双路开关"]) {
        [_deviceSwitch setHidden:YES];
        [_TestBtn setHidden:YES];
        [self.PhoneBtn setHidden:YES];
        [self.switch1 setHidden:NO];
        [self.switch2 setHidden:NO];
    }
}


/**
 动态改变背景图片
 */
-(void)tarnslateBackgroundImageView{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.bgImageView.layer addAnimation:transition forKey:nil];
    [self setPageBackground];

}

/**
 设备背景图片
 */
-(void)setPageBackground{
    NSLog(@"setPageBackground > _data.title = %@", _data.title);
    if ([_data.status isEqualToString:@"aq"]) {
        [_bgImageView setImage:[UIImage imageNamed:@"sbgreen_bg"]];
        if ([_data.title isEqualToString:@"智能插座"]) {
            _MainLabel.text = NSLocalizedString(@"插座关",nil);
            [_deviceSwitch setOn:NO animated:YES];
        }
        else if([_data.title isEqualToString:@"门磁"]){
            _MainLabel.text = NSLocalizedString(@"门关闭",nil);
        }
        else if([_data.title isEqualToString:@"PIR探测器"]){
            _MainLabel.text = NSLocalizedString(@"正常",nil);
        }
        else if ([_data.title isEqualToString:@"门锁"]) {
            if ([_data.desc isEqualToString:STATE_NORMAL] || [_data.desc isEqualToString:@"60"] ) {
                _MainLabel.text = NSLocalizedString(@"正常",nil);
            } else if ([_data.desc isEqualToString:@"AB"]) {
                _MainLabel.text = NSLocalizedString(@"已激活",nil);
            } else if ([_data.desc isEqualToString:STATE_TRIGGERED]) {
                _MainLabel.text = NSLocalizedString(@"远程密码开锁成功", nil);
                _MainLabel.textColor = RGB(245, 52, 35);
                _centerLine.backgroundColor = RGB(245, 52, 35);
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                return;
            } else if ([_data.desc isEqualToString:@"56"]) {
                _MainLabel.text = NSLocalizedString(@"密码错误", nil);
                _MainLabel.textColor = RGB(245, 52, 35);
                _centerLine.backgroundColor = RGB(245, 52, 35);
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                return;
            }
            
        }
        else if ([_data.title isEqualToString:@"双路开关"]) {
            NSString *switchStatus = [_data.statuCode substringWithRange:NSMakeRange(6, 2)];
            if ([switchStatus isEqualToString:@"00"]) {
                [_switch1 setOn:NO animated:YES];
                [_switch2 setOn:NO animated:YES];
                [_bgImageView setImage:[UIImage imageNamed:@"sbgreen_bg"]];
                NSString *statusString = @"通道1关\n通道2关";
                [_MainLabel setTextColor:RGB(0, 191, 102)];
                [_MainLabel setText:statusString];
            }
        }
//        else if ([_data.title isEqualToString:@"门锁"]) {
//            if ([_data.desc isEqualToString:@"55"]) {
//                _MainLabel.text = NSLocalizedString(@"远程密码开锁成功", nil);
//            } else if ([_data.desc isEqualToString:@"56"]) {
//                _MainLabel.text = NSLocalizedString(@"密码错误", nil);
//            }
//            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
//            return;
//        }
        else{
            _MainLabel.text = NSLocalizedString(@"正常",nil);
        }
        _MainLabel.textColor = RGB(0, 191, 102);
        _centerLine.backgroundColor = RGB(0, 191, 102);
    }
    else if ([_data.status isEqualToString:@"gz"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];
        _MainLabel.text = NSLocalizedString(@"低电压",nil);
        _MainLabel.textColor = RGB(255, 179, 0);
        _centerLine.backgroundColor = RGB(255, 179, 0);
        
    }
    else if ([_data.status isEqualToString:@"bj"]){
        
        if ([_data.title isEqualToString:@"智能插座"]) {
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
            _MainLabel.text = NSLocalizedString(@"插座开",nil);
            [_deviceSwitch setOn:YES animated:YES];
        }
        else if([_data.title isEqualToString:@"门磁"]){
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
            _MainLabel.text = NSLocalizedString(@"门打开",nil);
        }
        else if([_data.title isEqualToString:@"PIR探测器"]){
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
            _MainLabel.text = NSLocalizedString(@"有人移动报警",nil);
        }
        else if ([_data.title isEqualToString:@"复合型烟感"]) {
            if ([_data.desc isEqualToString:@"17"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
                _MainLabel.text = NSLocalizedString(@"测试报警", nil);
            } else if ([_data.desc isEqualToString:@"12"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];//
                _MainLabel.text = NSLocalizedString(@"低电压", nil);
            } else if ([_data.desc isEqualToString:@"15"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];//
                _MainLabel.text = NSLocalizedString(@"免打扰", nil);
            }else if ([_data.desc isEqualToString:@"19"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
                _MainLabel.text = NSLocalizedString(@"火灾报警", nil);
            } else if ([_data.desc isEqualToString:@"1B"]) {
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];//
                _MainLabel.text = NSLocalizedString(@"静音", nil);
            }
        }
        else if ([_data.title isEqualToString:@"门锁"]) {
            if ([_data.desc isEqualToString:@"10"]) {
                _MainLabel.text = NSLocalizedString(@"非法操作", nil);
            } else if ([_data.desc isEqualToString:@"20"]) {
                _MainLabel.text = NSLocalizedString(@"强拆", nil);
            } else if ([_data.desc isEqualToString:@"30"]) {
                _MainLabel.text = NSLocalizedString(@"胁迫", nil);
            } else if ([_data.desc isEqualToString:@"51"]) {
                _MainLabel.text = NSLocalizedString(@"密码开锁", nil);
            } else if ([_data.desc isEqualToString:@"52"]) {
                _MainLabel.text = NSLocalizedString(@"卡开锁", nil);
            } else if ([_data.desc isEqualToString:@"53"]) {
                _MainLabel.text = NSLocalizedString(@"指纹开锁", nil);
            }
            
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
        }
        else if ([_data.title isEqualToString:@"双路开关"]) {
            NSString *switchStatus = [_data.statuCode substringWithRange:NSMakeRange(6, 2)];
            if ([switchStatus isEqualToString:@"01"]) {
                [_switch1 setOn:YES animated:YES];
                [_switch2 setOn:NO animated:YES];
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"通道1开\n通道2关"];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(245, 52, 35) range:NSMakeRange(0, 4)];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(0, 191, 102) range:NSMakeRange(5, 4)];
                [_MainLabel setAttributedText:statusString];
            } else if ([switchStatus isEqualToString:@"02"]) {
                [_switch1 setOn:NO animated:YES];
                [_switch2 setOn:YES animated:YES];
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"通道1关\n通道2开"];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(0, 191, 102) range:NSMakeRange(0, 4)];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(245, 52, 35) range:NSMakeRange(5, 4)];
                [_MainLabel setAttributedText:statusString];
            } else if ([switchStatus isEqualToString:@"03"]) {
                [_switch1 setOn:YES animated:YES];
                [_switch2 setOn:YES animated:YES];
                [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
                NSString *statusString = @"通道1开\n通道2开";
                [_MainLabel setText:statusString];
                [_MainLabel setTextColor:RGB(245, 52, 35)];
            }
        }
        else{
            [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
            _MainLabel.text = NSLocalizedString(@"报警",nil);
        }
        if (![_data.title isEqualToString:@"双路开关"]) {
            _MainLabel.textColor = RGB(245, 52, 35);
        }
        _centerLine.backgroundColor = RGB(245, 52, 35);
    }
    else if ([_data.status isEqualToString:@"no"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sbgray_bg"]];
        _MainLabel.text = NSLocalizedString(@"离线",nil);
        _MainLabel.textColor = RGB(192, 203, 223);
        _centerLine.backgroundColor = RGB(192, 203, 223);
    }
}

/**
 显示设备状态
 */
- (void)analysisStatus{
    
    if (![self.data.status isEqualToString:@"no"]) {
        
        NSString *signal = [_data.statuCode substringWithRange:NSMakeRange(0, 2)];
        if ([signal isEqualToString:@"04"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi04"]];
        }
        else if ([signal isEqualToString:@"03"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi03"]];
        }
        else if ([signal isEqualToString:@"02"]){
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi02"]];
        }
        else if ([signal isEqualToString:@"01"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        }
        else{
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        }
        
        NSString *battery = [_data.statuCode substringWithRange:NSMakeRange(2, 2)];
        if (![self.data.title containsString:@"插座"] && ![self.data.title containsString:@"双路开关"]) {
            if ([battery isEqualToString:@"FF"]) {
            }
            else if ([battery isEqualToString:@"80"]){
                self.batteryLabel.text = @"0%";
            }
            else if ([battery isEqualToString:@"64"]){
                self.batteryLabel.text = @"100%";
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg100_icon"]];
                
            }else{
                self.batteryLabel.text = [NSString stringWithFormat:@"%@%%",[BatterHelp getBatterFormDevice:battery]];
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
        
        NSString *switchStatus = [_data.statuCode substringWithRange:NSMakeRange(6, 2)];
        if ([self.data.title containsString:@"插座"]) {
            if ([switchStatus isEqualToString:@"FF"] || [switchStatus isEqualToString:@"01"]) {
                [_deviceSwitch setOn:YES animated:YES];
            }else{
                [_deviceSwitch setOn:NO animated:YES];
            }
        }
        else if ([self.data.title containsString:@"双路开关"]) {
            if ([switchStatus isEqualToString:@"00"]) {
                [_switch1 setOn:NO animated:YES];
                [_switch2 setOn:NO animated:YES];
                NSString *statusString = @"通道1关\n通道2关";
                [_MainLabel setText:statusString];
            } else if ([switchStatus isEqualToString:@"01"]) {
                [_switch1 setOn:YES animated:YES];
                [_switch2 setOn:NO animated:YES];
                NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"通道1开\n通道2关"];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(245, 52, 35) range:NSMakeRange(0, 4)];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(0, 191, 102) range:NSMakeRange(5, 4)];
                [_MainLabel setAttributedText:statusString];
            } else if ([switchStatus isEqualToString:@"02"]) {
                [_switch1 setOn:NO animated:YES];
                [_switch2 setOn:YES animated:YES];
                NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"通道1关\n通道2开"];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(0, 191, 102) range:NSMakeRange(0, 4)];
                [statusString addAttribute:NSForegroundColorAttributeName value:RGB(245, 52, 35) range:NSMakeRange(5, 4)];
                [_MainLabel setAttributedText:statusString];
            } else if ([switchStatus isEqualToString:@"03"]) {
                [_switch1 setOn:YES animated:YES];
                [_switch2 setOn:YES animated:YES];
                NSString *statusString = @"通道1开\n通道2开";
                [_MainLabel setText:statusString];
            }
        }
    }
    else{
        [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        _batteryLabel.text = NSLocalizedString(@"",nil);
    }
}

- (IBAction)switchAction:(id)sender {
    UISwitch *mswitch = sender;
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if (!_isSwitching) {
        PostControllerApi *api;
        _isSwitching = YES;
        [MBProgressHUD showLoadToView:GetWindow];
        __block NSObject *obj = [[NSObject alloc] init];

        if (mswitch.tag == 11) {
            if (!mswitch.isOn) {
                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"01000000"];
            } else if (mswitch.isOn) {
                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"01010000"];
            }
        }
        else if (mswitch.tag == 22) {
            if (!mswitch.isOn) {
                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"02000000"];
            } else if (mswitch.isOn) {
                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"02020000"];
            }
        }
        else {
            if ([mswitch isOn]) {
                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"0101"];
            }else{
                api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"0100"];
            }
        }
    
        [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            _isSwitching = NO;
            [obj class];
            obj = nil;
        } failure:^(id data, NSError *error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            _isSwitching = NO;
            [mswitch setOn:!mswitch.isOn animated:YES];
            [obj class];
            obj = nil;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isSwitching) {
                [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                _isSwitching = NO;
                [mswitch setOn:!mswitch.isOn animated:YES];
                obj = nil;
            }
        });
    }
}

- (IBAction)testAction:(id)sender {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if ([self.data.title isEqualToString:@"复合型烟感"]) {
        PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"17000000"];
        [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
    }
    else if ([self.data.title isEqualToString:@"按键"]) {
        PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"00000100"];
        [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
    }
    else if ([self.data.title isEqualToString:@"门锁"]) {
        UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rememberBtn setTitle:NSLocalizedString(@"记住密码", nil) forState:UIControlStateNormal];
        rememberBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
        [rememberBtn setImage:[UIImage imageNamed:@"jzmm_noselect"] forState:UIControlStateNormal];
        [rememberBtn setImage:[UIImage imageNamed:@"jzmm_select"] forState:UIControlStateSelected];
        [rememberBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [rememberBtn setTitleColor:RGB(57, 166, 240) forState:UIControlStateNormal];
        [rememberBtn setFrame:CGRectMake(0, 0, 150, 20)];
        NSString *suoPsd = [[NSUserDefaults standardUserDefaults] objectForKey:@"suoPsd"];
        if (suoPsd && suoPsd.length != 0) {
            [rememberBtn setSelected:YES];
        } else {
            [rememberBtn setSelected:NO];
        }
        [rememberBtn addTarget:self action:@selector(rememberPassword:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [eyeBtn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
        [eyeBtn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateSelected];
        [eyeBtn setFrame:CGRectMake(0, 0, 20, 15)];
        [eyeBtn addTarget:self action:@selector(lookPsd:) forControlEvents:UIControlEventTouchUpInside];
//        self.isShowTip = NO;
        
        [LEEAlert alert].config
        .LeeAddTitle(^(UILabel *label) {
            label.text = NSLocalizedString(@"请输入开锁密码", nil);
            label.textColor = RGB(57, 166, 240);
            label.font = [UIFont systemFontOfSize:15];
        })
        .LeeAddTextField(^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"请输入开锁密码", nil);
            textField.borderStyle = UITextBorderStyleNone;
            textField.font = [UIFont systemFontOfSize:14];
            textField.rightView = eyeBtn;
            textField.secureTextEntry = YES;
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.text = suoPsd;
            self.textf = textField;
        })
        .LeeAddCustomView(^(LEECustomView *custom) {
            custom.positionType = LEECustomViewPositionTypeLeft;
            custom.view = rememberBtn;
        })
        .LeeAddAction(^(LEEAction *action) {
            action.type = LEEActionTypeCancel;
            action.title = NSLocalizedString(@"取消", nil);
            action.titleColor = [UIColor lightGrayColor];
            action.font = [UIFont systemFontOfSize:14];
        })
        .LeeAddAction(^(LEEAction *action) {
            action.type = LEEActionTypeDefault;
            action.title = NSLocalizedString(@"确定", nil);
            action.titleColor = RGB(57, 166, 240);
            action.font = [UIFont systemFontOfSize:14];
            __weak typeof(self) weakSelf = self;
            action.clickBlock = ^{
                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.textf.text forKey:@"suoPsd"];
                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:[NSString stringWithFormat:@"%@00", weakSelf.textf.text]];
                [api startWithObject:weakSelf CompletionBlockWithSuccess:^(id data, NSError *error) {
                    NSLog(@"成功了啊");
//                    if ([_data.desc isEqualToString:@"AB"]) {
//                        weakSelf.isShowTip = YES;
//                        [MBProgressHUD showMessage:NSLocalizedString(@"操作成功，等待设备响应", nil) ToView:[UIApplication sharedApplication].keyWindow RemainTime:1.0];
//                    }
//                    else {
//                        [MBProgressHUD showMessage:NSLocalizedString(@"门锁未激活", nil) ToView:[UIApplication sharedApplication].keyWindow RemainTime:0.8];
//                    }
                } failure:^(id data, NSError *error) {
                    NSLog(@"失败了啊");
                }];
            };
        })
        .LeeShow();
        
    }
    else{
        PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:@"BB000000"];
        [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {} failure:^(id data, NSError *error) {}];
    }
}

- (void)rememberPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)lookPsd:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.textf.secureTextEntry = !sender.selected;
}

- (IBAction)phoneAction:(id)sender {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:[config objectForKey:UserInfos] error:nil];
    
    if (model.user_des) {

        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.user_des];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"未设置紧急号码",nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:nil];
        [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RenameVC *vc = segue.destinationViewController;
    vc.deviceId = self.data.devID;
}

- (void)lodaData{
    self.data = [[DeviceDataBase sharedDataBase] selectDevice:self.data.devID];
    [self analysisStatus];
    [self tarnslateBackgroundImageView];
}


/**
 监听设备状态
 */
-(void)divceStatusListener{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    //氦氪云接口获取设备状态
    MainDeviceApi *api = [[MainDeviceApi alloc] initWithDrivce:model.devTid andCtrlKey:model.ctrlKey];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        if (!error) {
            //TODO: 在这里init方法里面做限制
            NSNumber *msgId=data[@"msgId"];
            NSNumber *cmdId = data[@"params"][@"data"][@"cmdId"];
            DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
            if([cmdId intValue] == 119){
                int newa = [Encryptools getDescryption:model.device_ID withMsgId:[msgId intValue]];
                [model setDevice_ID:newa];
            }
            ///如果是门锁，则提示开锁成功和失败
            if ([[model.device_name substringFromIndex:1] isEqualToString:@"213"] && model.device_ID== [self.data.devID intValue]) {
                NSString *msMsg = nil;
                if (model.device_status.length == 8 && [[model.device_status substringWithRange:NSMakeRange(4, 2)] isEqualToString:STATE_TRIGGERED]) {
                    msMsg = NSLocalizedString(@"远程开锁成功", nil);
                } else if (model.device_status.length == 8 && [[model.device_status substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"56"]) {
                    msMsg = NSLocalizedString(@"密码错误", nil);
                } else {
                    return ;
                }
                [LEEAlert alert].config
                .LeeAddTitle(^(UILabel *label) {
                    label.text = NSLocalizedString(@"提示", nil);
                    label.textColor = RGB(57, 166, 240);
                    label.font = [UIFont systemFontOfSize:15];
                })
                .LeeAddContent(^(UILabel *label) {
                    label.text = msMsg;
                    label.textColor = RGB(57, 166, 240);
                    label.font = [UIFont systemFontOfSize:14];
                })
                .LeeAddAction(^(LEEAction *action) {
                    action.type = 0;
                    action.title = NSLocalizedString(@"确定", nil);
                    action.titleColor = [UIColor darkGrayColor];
                    action.font = [UIFont systemFontOfSize:14];
                })
                .LeeShow();
            }
        }
    } failure:^(id data, NSError *error) {
        
    }];
    
}

- (UIImageView *)wifiImgV {
    if (!_wifiImgV) {
        _wifiImgV = [[UIImageView alloc] init];
        [self.bgView addSubview:_wifiImgV];
        if ([self.data.title containsString:@"插座"]) {
            [_wifiImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(0);
                make.top.equalTo(_centerLine.mas_bottom).offset(15);
            }];
        } else {
            [_wifiImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_centerLine.mas_bottom).offset(15);
                make.centerX.equalTo(-44);
            }];
        }
        
    }
    return _wifiImgV;
}

- (UIImageView *)batteryImgV {
    if (!_batteryImgV) {
        _batteryImgV = [[UIImageView alloc] init];
        [self.bgView addSubview:_batteryImgV];
        [_batteryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(_centerLine.mas_bottom).offset(20);
        }];
    }
    return _batteryImgV;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc] init];
        [self.bgView addSubview:_batteryLabel];
        [_batteryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_centerLine.mas_bottom).offset(20);
            make.centerX.equalTo(44);
        }];
    }
    return _batteryLabel;
}

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

#pragma -mark lazy
-(UIView *)bottomview{
    NSLog(@"[bottomview] mas_bottom = %@", self.view.mas_bottom);
    if(_bottomview==nil){
        _bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 31)];
        [self.view addSubview:_bottomview];
        [_bottomview makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(31);
            if (kIPhoneX) {
                make.bottom.equalTo(-30);
            } else {
                make.bottom.equalTo(self.view.mas_bottom);
            }
        }];

        UIImageView *imagebg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sbgjwhite_bg"]];
        [_bottomview addSubview:imagebg];
        [imagebg makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];

        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"设备告警", nil);
        label.font = SYSTEMFONT(14);
        [_bottomview addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(0);
        }];

        UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tj02_icon"]];
        [_bottomview addSubview:image1];
        [image1 makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left).offset(-5);
            make.centerY.equalTo(0);
        }];

        UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow02_icon"]];
        [_bottomview addSubview:image2];
        [image2 makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(5);
            make.centerY.equalTo(0);
        }];
    }
    return _bottomview;
}

#pragma -mark method
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    DeviceWarningListViewController *wl = [[DeviceWarningListViewController alloc] init];
    wl.dev_id = _data.devID;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wl];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 点击底部的蓝条
 */
-(void)tapBottom:(UITapGestureRecognizer *)sender{
    //弹动一下
    BOOL animated = [self.bottomview.layer pop_animationKeys] > 0;
    if (!animated) {
        POPDecayAnimation *scollerTop = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        scollerTop.velocity = @(-30);
        [_bottomview.layer pop_addAnimation:scollerTop forKey:@"scollerTop"];

        WS(ws)
        scollerTop.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            POPSpringAnimation *dropAnamation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
            dropAnamation.toValue = @(0);
            dropAnamation.springBounciness = 20;
            [ws.bottomview.layer pop_addAnimation:dropAnamation forKey:@"dropAnamation"];
        };
    }
}

- (void)alertPickerViewWithOneDataSource:(NSString *)type{
    NSMutableArray *ds = [NSMutableArray new];
    for(int i=0;i<256;i++){
        [ds addObject: [NSString stringWithFormat:NSLocalizedString(@"%d秒", nil),i*10 ]];
    }
    NSArray * dataArray = @[ds];
    if ([type isEqualToString:@"alert"]) {
        _alertVC = [LCAlertViewController LC_alertControllerWithTitle:NSLocalizedString(@"请选择报警时长", nil) dataArray:dataArray preferredStyle:LCAlertViewControllerStyleAlert];
    }else if ([type isEqualToString:@"actionSheet"]){
        _alertVC = [LCAlertViewController LC_alertControllerWithTitle:NSLocalizedString(@"请选择报警时长", nil) dataArray:dataArray preferredStyle:LCAlertViewControllerStyleActionSheet];
        UIPopoverPresentationController *popover =_alertVC.popoverPresentationController;
        if (popover) {//适配iPad
            popover.sourceView = self.view;
            popover.sourceRect = CGRectMake(0, 0,1, 1);
            popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
        }



    }

    [_alertVC.pickerView selectRow:0 inComponent:0 animated:NO];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        if (!_isSwitching) {
            __block NSObject *obj = [[NSObject alloc] init];
            _isSwitching = YES;
            [MBProgressHUD showMessage:NSLocalizedString(@"请稍后...", nil) ToView:GetWindow];
            NSInteger index = [_alertVC.pickerView selectedRowInComponent:0];
            NSLog(@"index:%ld",index);
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];

            NSString *str = @"";
            if(index<16){
                str = [@"0" stringByAppendingString:[BatterHelp gethexBybinary:index]];
            }else{
                str = [BatterHelp gethexBybinary:index];
            }

            NSString *totl = [[@"55BB" stringByAppendingString:str] stringByAppendingString:@"FF"];

            PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:0 DeviceStatus:totl];

            [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {

                [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                _isSwitching = NO;
                [obj class];
                obj = nil;

            } failure:^(id data, NSError *error) {
                [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                _isSwitching = NO;
                [obj class];
                obj = nil;

            }];



            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_isSwitching) {
                    [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                    _isSwitching = NO;
                    obj = nil;
                }
            });
        }




    }];

    [_alertVC LC_addAction:okAction withPickerBlock:^(NSInteger component, NSInteger row) {

    }];
    [_alertVC LC_addAction:cancelAction withPickerBlock:^(NSInteger component, NSInteger row) {

    }];
    [self presentViewController:_alertVC animated:YES completion:^{

    }];
}


-(void)testTypeChooseItem{
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {

        if (buttonIndex == 1) {

            if (!_isSwitching) {
                __block NSObject *obj = [[NSObject alloc] init];
                _isSwitching = YES;
                NSString *content = @"";
                if([_data.title isEqualToString:@"复合型烟感"]){
                    content = @"17000000";
                }else {
                    content = @"BB000000";
                }
                [MBProgressHUD showMessage:NSLocalizedString(@"请稍后...", nil) ToView:GetWindow];
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
                PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_data.devID intValue] DeviceStatus:content];

                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {

                    [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                    _isSwitching = NO;
                    [obj class];
                    obj = nil;

                } failure:^(id data, NSError *error) {
                    [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                    _isSwitching = NO;
                    [obj class];
                    obj = nil;

                }];



                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_isSwitching) {
                        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                        _isSwitching = NO;
                        obj = nil;
                    }
                });
            }

        }else if(buttonIndex==2){
            [self alertPickerViewWithOneDataSource:@"actionSheet"];
        }

    } otherButtonTitles:NSLocalizedString(@"测试单个",nil),NSLocalizedString(@"测试全部",nil), nil];
    actionSheet.buttonFont = [UIFont systemFontOfSize:14];
    actionSheet.buttonHeight = 44.0f;
    actionSheet.buttonColor = RGB(36, 155, 255);
    actionSheet.unBlur = YES;
    [actionSheet show];
}
@end
