//
//  ChooseConnectTypeVC.m
//  sHome
//
//  Created by TracyHenry on 2018/8/28.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "ChooseConnectTypeVC.h"
#import "GuideAddCamera.h"
#import "LanSearchViewController.h"
@interface ChooseConnectTypeVC()
@property(nonatomic,weak) IBOutlet UIButton *btn_config;
@property(nonatomic,weak) IBOutlet UIButton *btn_share;
@property(nonatomic,weak) IBOutlet UIButton *btn_lan;
@property(nonatomic,weak) IBOutlet UILabel *label_instruction;
@end

@implementation ChooseConnectTypeVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"添加摄像机", nil);
    _btn_config.layer.borderWidth = 1;
    _btn_config.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btn_config.layer.cornerRadius = 10;
    [_btn_config setTitle:NSLocalizedString(@"添加我的摄像机", nil) forState:UIControlStateNormal];
    
    _btn_share.layer.borderWidth = 1;
    _btn_share.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btn_share.layer.cornerRadius = 10;
    [_btn_share setTitle:NSLocalizedString(@"添加分享的摄像机", nil) forState:UIControlStateNormal];
    
    _btn_lan.layer.borderWidth = 1;
    _btn_lan.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btn_lan.layer.cornerRadius = 10;
    [_btn_lan setTitle:NSLocalizedString(@"添加同一路由器上的摄像机", nil) forState:UIControlStateNormal];
    _label_instruction.numberOfLines = 0;
    _label_instruction.font = SYSTEMFONT(12);
    _label_instruction.text = NSLocalizedString(@"如果设备曾经添加过路由器,请长按设备背面（或者底部）的SET键,恢复出厂设置", nil);

}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}
    
//记住密码
- (IBAction)gotoLanAction:(id)sender {
    LanSearchViewController *vc = [[LanSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
