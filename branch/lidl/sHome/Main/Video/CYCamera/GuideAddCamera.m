//
//  GuideAddCamera.m
//  sHome
//
//  Created by TracyHenry on 2018/8/28.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "GuideAddCamera.h"

@interface GuideAddCamera()
@property(nonatomic,weak) IBOutlet UILabel *label1;
@property(nonatomic,weak) IBOutlet UILabel *label2;
@property(nonatomic,weak) IBOutlet UILabel *label3;
@property(nonatomic,weak) IBOutlet UILabel *label4;
@property(nonatomic,weak) IBOutlet UILabel *label5;
@property(nonatomic,weak) IBOutlet UILabel *label6;
@property(nonatomic,weak) IBOutlet UILabel *label7;
@property(nonatomic,weak) IBOutlet UILabel *label8;
@property(nonatomic,weak) IBOutlet UILabel *label9;
@property(nonatomic,weak) IBOutlet UIButton *btn_next;
@end

@implementation GuideAddCamera

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"添加摄像机", nil);
    [_btn_next setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [_btn_next setBackgroundColor:ThemeColor];
    _btn_next.layer.cornerRadius = 5;
    _label1.numberOfLines = 0;
    _label2.numberOfLines = 0;
    _label3.numberOfLines = 0;
    _label4.numberOfLines = 0;
    _label5.numberOfLines = 0;
    _label6.numberOfLines = 0;
    _label7.numberOfLines = 0;
    _label8.numberOfLines = 0;
    _label9.numberOfLines = 0;
    _label1.text = NSLocalizedString(@"是否听到设备提示\"开始快速配置\"或\"等待连接\"", nil);
    _label2.text = NSLocalizedString(@"若确认，点击进入\"下一步\"", nil);
    _label3.text = NSLocalizedString(@"有些设备为指示灯快闪，无语音提示", nil);
    _label4.text = NSLocalizedString(@"(暂不支持5GHz频段的WIFI)", nil);
    _label5.text = NSLocalizedString(@"1.请插好电源和数据线，确保设备商店并已经正常运行;", nil);
    _label6.text = NSLocalizedString(@"2.首次配置，请将设备、手机和路由器置于1米以内的范围，确保信号接收成功;", nil);
    _label7.text = NSLocalizedString(@"3.待听到\"开始快速配置\"或\"等待连接\"的语音提示，方可开始配置", nil);
    _label8.text = NSLocalizedString(@"4.如未观察到上述现象，请长按SET/RESRET键，将设备恢复出厂设置后重新连接;", nil);
    _label9.text = NSLocalizedString(@"若观察到上述现象，请点击", nil);
}



@end
