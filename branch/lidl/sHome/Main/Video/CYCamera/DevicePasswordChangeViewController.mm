//
//  DevicePasswordChangeViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/14.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "DevicePasswordChangeViewController.h"
#import "ChangePSWView.h"
#import "FunSDK/FunSDK.h"
//#import "Users.h"
#import "ModifyPassword.h"
#import "SDKDataCenter.h"

@interface DevicePasswordChangeViewController ()
{
    ModifyPassword JModifyPassword;
}
@property (nonatomic, strong) ChangePSWView *changePSWView;
@end

@implementation DevicePasswordChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"密码管理", nil);
    [self layoutSubviews];
    
}

-(void)layoutSubviews{
    self.changePSWView = [[ChangePSWView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.changePSWView.ConfirmBtn addTarget:self action:@selector(changeDevicePWD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.changePSWView];
}

#pragma mark Controls Methods
-(void)changeDevicePWD:(UIButton *)btn{
    if ([SVProgressHUD isVisible]) {
        return;
    }
    if (![self.changePSWView.NewTXF.text isEqualToString:self.changePSWView.ConfirmTXF.text]) {
        [SVProgressHUD showErrorWithStatus:TS("密码输入不一致")];
        return;
    }
    [self.changePSWView.NewTXF resignFirstResponder];
    [self.changePSWView.ConfirmTXF resignFirstResponder];
    
    [SVProgressHUD showWithStatus:TS("修改中") maskType:SVProgressHUDMaskTypeBlack];
    
    if (self.changePSWView.OldTXF.text == NULL) {
        self.changePSWView.OldTXF.text = @"";
    }
    if (self.changePSWView.NewTXF.text == NULL) {
        self.changePSWView.NewTXF.text = @"";
    }
    [SVProgressHUD showWithStatus:TS("修改中") maskType:SVProgressHUDMaskTypeBlack];
    
    JModifyPassword.SetNewPassword([self.changePSWView.OldTXF.text UTF8String], [self.changePSWView.NewTXF.text  UTF8String]);
    [self requestSetConfigWithChannel:-1 andJObject:&JModifyPassword];
}

void MD5Encrypt(signed char *strOutput, unsigned char *strInput);

//callback
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
    
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    [DATACENTER ModifyDevice:self.deviceSN andUserName:nil andPassword:self.changePSWView.NewTXF.text];
    [SVProgressHUD showSuccessWithStatus:TS("修改成功") duration:1.5];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setConfig:(DeviceConfig *)config result:(int)result{
    [SVProgressHUD dismiss];
    if (result < 0) {
        if (result == EE_DVR_PASSWORD_NOT_VALID) {
             [SVProgressHUD showErrorWithStatus:TS("无效的旧密码")];
        }else{
//         [SVProgressHUD showErrorWithStatus: [SDKParser parseError:result] duration:3];
        }
    }else{
        [self RefreshUIWithSetConfig:config];
    }
}

@end
