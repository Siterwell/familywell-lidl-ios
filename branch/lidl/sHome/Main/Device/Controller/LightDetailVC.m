//
//  LightDetailVC.m
//  sHome
//
//  Created by CY on 2018/4/4.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "LightDetailVC.h"
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
#import "PostControllerApi.h"

#import "LZCircularSlider.h"

@interface LightDetailVC ()

@property (nonatomic) UIImageView *bgImageView;
@property (nonatomic) UILabel *MainLabel;
@property (nonatomic) UIImageView *wifiImgV;

@property (nonatomic) UILabel *valueLabel;
@property (nonatomic) UIButton *swBtn;
//@property (nonatomic) UISlider *slider;
@property (nonatomic) LZCircularSlider *slider;

@property (nonatomic, assign) BOOL isClickButton;

@end

@implementation LightDetailVC {
    CGPoint _bottomPoint;
    CGPoint _beginPoint;
    
    BOOL _isReplcing;
    BOOL _isDeleting;
    BOOL _isSwitching;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupBaseUI];
    
    self.navigationController.navigationBar.alpha = 1;
    
    if([_data.customTitle isEqualToString:@""]){
        self.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(_data.title, nil),_data.devID];
    }else{
        self.title = _data.customTitle;
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"管理",nil) withTintColor:[UIColor whiteColor]];
    
    [self setPageBackground];
    [self analysisStatus];
}

- (void)setupBaseUI {
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:_bgImageView];
    
    _MainLabel = [[UILabel alloc] init];
    _MainLabel.font = [UIFont systemFontOfSize:17];
    _MainLabel.textColor = [UIColor blackColor];
    _MainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_MainLabel];
    [_MainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-50);
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
    
//    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(45 , 160, Main_Screen_Width-90, 40)];
//    slider.minimumValue = 0;
//    slider.maximumValue = 100;
//    slider.value = [[BatterHelp numberHexString:[self.data.statuCode substringWithRange:NSMakeRange(6, 2)]] floatValue];
//    slider.continuous = YES;
//    [slider setMinimumTrackImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [slider setMaximumTrackImage:[self imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
//    [slider addTarget:self action:@selector(onlyChangeValue:) forControlEvents:UIControlEventValueChanged];
//    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//    [self.view addSubview:slider];
    
    
//    LZCircularSlider *slider = [[LZCircularSlider alloc] initWithFrame:CGRectMake(25, 160, Main_Screen_Width-50, Main_Screen_Width-50)];
//    slider.lineWidth = 8;
//    slider.maximumValue = 100;
//    slider.minimumValue = 0;
//    slider.currentValue = [[BatterHelp numberHexString:[self.data.statuCode substringWithRange:NSMakeRange(6, 2)]] floatValue];
//    slider.unfilledColor =[UIColor colorWithRed:192/255.0 green:192/255.0 blue:192/255.0 alpha:1];
//    slider.filledColor =[UIColor colorWithRed:255/255.0 green:127/255.0 blue:80/255.0 alpha:1];
//    slider.downFilledColor =[UIColor colorWithRed:65/255.0 green:105/255.0 blue:225/255.0 alpha:1];
//    slider.backgroundColor =[UIColor brownColor];
//    [slider addTarget:self action:@selector(onlyChangeValue:) forControlEvents:UIControlEventValueChanged];
//    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//    [self.view addSubview:slider];
//
//    self.slider = slider;
    
    _slider =[[LZCircularSlider alloc]initWithFrame:CGRectMake(25, 160, Main_Screen_Width-50, Main_Screen_Width-50)];
    
    _slider.lineWidth =8;
    _slider.maximumValue =101;
    _slider.minimumValue =0;
    _slider.currentValue = [[BatterHelp numberHexString:[self.data.statuCode substringWithRange:NSMakeRange(6, 2)]] intValue];;
    _slider.unfilledColor =[UIColor grayColor];
    _slider.filledColor =[UIColor whiteColor];

    _slider.backgroundColor =[UIColor clearColor];
    [_slider addTarget:self action:@selector(onlyChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:_slider];

    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.text = [NSString stringWithFormat:@"%d%%", [[BatterHelp numberHexString:[self.data.statuCode substringWithRange:NSMakeRange(6, 2)]] intValue]];
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font = [UIFont systemFontOfSize:38];
    [self.view addSubview:valueLabel];
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.slider).offset(120);
    }];
    self.valueLabel = valueLabel;
    
    _swBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_swBtn setBackgroundImage:[UIImage imageNamed:@"off02_btn"] forState:UIControlStateNormal];
    [_swBtn setBackgroundImage:[UIImage imageNamed:@"on02_icon"] forState:UIControlStateSelected];
    [_swBtn setSelected:[[self.data.statuCode substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"] ? YES : NO];
    [self.view addSubview:_swBtn];
    [_swBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.valueLabel.mas_bottom).offset(70);
        make.width.equalTo(60);
        make.height.equalTo(30);
    }];
    [_swBtn addTarget:self action:@selector(setupLight:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (UIImage *)imageWithColor:(UIColor *)color//颜色直接转图片（借鉴的其他大牛的代码）
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 6.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)onlyChangeValue:(LZCircularSlider *)sender {
    self.valueLabel.text = [NSString stringWithFormat:@"%d%%", (int)sender.currentValue];
}

- (void)sliderValueChanged:(LZCircularSlider *)sender {
    self.valueLabel.text = [NSString stringWithFormat:@"%d%%", (int)sender.currentValue];
//    [self setupLight:self.swBtn];
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    int inttValue = (int)(self.slider.currentValue);
    NSString *strValue = [BatterHelp gethexBybinary: inttValue];
    strValue = strValue.length == 2 ? strValue : [@"0" stringByAppendingString:strValue];
    NSString *status = [strValue stringByAppendingString:@"0000"];
    status = [self.swBtn.selected ? @"01" : @"00" stringByAppendingString: status];
    NSLog(@"66666666666=%@", status);
    PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[self.data.devID intValue] DeviceStatus:status];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {

    } failure:^(id data, NSError *error) {
        
    }];
}

/**
 设备背景图片
 */
-(void)setPageBackground{
    if ([_data.status isEqualToString:@"aq"]) {
        [_bgImageView setImage:[UIImage imageNamed:@"sbgreen_bg"]];
        _MainLabel.text = NSLocalizedString(@"正常",nil);
        //        _MainLabel.textColor = RGB(0, 191, 102);
    }
    else if ([_data.status isEqualToString:@"gz"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];
        _MainLabel.text = NSLocalizedString(@"故障",nil);
        //        _MainLabel.textColor = RGB(255, 179, 0);
    }
    else if ([_data.status isEqualToString:@"bj"]) {
        [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
        _MainLabel.text = NSLocalizedString(@"报警",nil);
        //        _MainLabel.textColor = RGB(245, 52, 35);
    }
    else if ([_data.status isEqualToString:@"no"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sbgray_bg"]];
        _MainLabel.text = NSLocalizedString(@"NO",nil);
        //        _MainLabel.textColor = RGB(192, 203, 223);
    }
}

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
        
    }
    else {
        [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
    }
}

- (void)clickItem{
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
            if (!_isReplcing) {
                __block NSObject *obj = [[NSObject alloc] init];
                _isReplcing = YES;
                [replaceApi startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
                    _isReplcing = NO;
                    NSDictionary *dic = data;
                    dic = [dic objectForKey:@"params"];
                    dic = [dic objectForKey:@"data"];
                    long isSuccess = [[dic objectForKey:@"answer_yes_or_no"] longValue];
                    if (isSuccess == 2) {
                        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"DeviceStoryboard" bundle:nil];
                        AddDeviceVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddDeviceVC"];
                        vc.type = ws.data.devID;
                        BaseNC *nav = [[BaseNC alloc] initWithRootViewController:vc];
                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [ws.navigationController presentViewController:nav animated:YES completion:nil];
                        [ws.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [MBProgressHUD showError:NSLocalizedString(@"替换失败",nil) ToView:ws.view];
                    }
                    //                    [obj setValue:@"1" forKey:@"1"];
                    obj = nil;
                } failure:^(id data, NSError *error) {
                    //                    [obj setValue:@"1" forKey:@"1"];
                    obj = nil;
                    _isReplcing = NO;
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_isReplcing) {
                        obj = nil;
                        _isReplcing = NO;
                        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                        if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
                            [config setObject:NetworkAppStatus forKey:AppStatus];
                        }
                    }
                });
            }
            
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

- (void)setupLight:(UIButton *)swBtn {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    self.isClickButton = YES;
    
    int inttValue = (int)([self.valueLabel.text intValue]);
    NSString *strValue = [BatterHelp gethexBybinary: inttValue];
    strValue = strValue.length == 2 ? strValue : [@"0" stringByAppendingString:strValue];
    NSString *status = [strValue stringByAppendingString:@"0000"];
    
    status = [swBtn.selected ? @"00" : @"01" stringByAppendingString: status];
    NSLog(@"66666666666=%@", status);
    PostControllerApi *api = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[self.data.devID intValue] DeviceStatus:status];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        if (self.isClickButton == YES) {
            swBtn.selected = !swBtn.selected;
            self.isClickButton = NO;
        }
//        swBtn.selected = !swBtn.selected;
    } failure:^(id data, NSError *error) {
        
    }];
    
}

@end
