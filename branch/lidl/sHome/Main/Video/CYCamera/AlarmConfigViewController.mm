//
//  AlarmConfigViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/14.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "AlarmConfigViewController.h"
#import "AlarmConfigView.h"
#import "Detect_MotionDetect.h"
#import "Detect_BlindDetect.h"
#import "Detect_LossDetect.h"


@interface AlarmConfigViewController ()
{
    Detect_MotionDetect JDetect_MotionDetect;
    Detect_BlindDetect JDetect_BlindDetect;
    Detect_LossDetect JDetect_LossDetect;
}
@property (nonatomic, strong) AlarmConfigView *alarmConfigView;

@end

@implementation AlarmConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 239, 239);
    [self layOutSubviews];
    [self requestAlarmConfigs];
//    self.title = NSLocalizedString(@"报警配置", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

-(void)layOutSubviews{
    self.title = TS("Configure_Alarm");

//    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:TS("Save") style:UIBarButtonItemStylePlain target:self action:@selector(SaveConfig)];
//    [self.navigationItem setRightBarButtonItem:rightBtnItem];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(95, 195, 249) forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(SaveConfig) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.alarmConfigView = [[AlarmConfigView alloc]initWithFrame:CGRectMake(0, 64,Main_Screen_Width, self.view.frame.size.height - 64)];
    self.alarmConfigView.level = JDetect_MotionDetect.Level.Value();
    self.alarmConfigView.dataArr = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0,@0,@0, nil];
    self.alarmConfigView.sensitivityBlock = ^(int sensitivity) {
        JDetect_MotionDetect.Level = sensitivity;
        [self requestSetConfigWithChannel:self.channelNum andJObject:&JDetect_MotionDetect];
    };
    [self.view addSubview:self.alarmConfigView];
    
}

-(void)requestAlarmConfigs{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self requestGetConfigWithChannel:self.channelNum andJObject:&JDetect_MotionDetect];
    [self requestGetConfigWithChannel:self.channelNum andJObject:&JDetect_BlindDetect];
    [self requestGetConfigWithChannel:self.channelNum andJObject:&JDetect_LossDetect];
}

//controls methods
-(void)SaveConfig{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
//    JDetect_MotionDetect.Level = [[NSNumber numberWithInt: self.alarmConfigView.level] intValue];
    
    JDetect_MotionDetect.Enable = [self.alarmConfigView.dataArr[0] boolValue];
    JDetect_MotionDetect.mEventHandler.RecordEnable = [self.alarmConfigView.dataArr[1] boolValue];
    JDetect_MotionDetect.mEventHandler.SnapEnable = [self.alarmConfigView.dataArr[2] boolValue];
    JDetect_MotionDetect.mEventHandler.MessageEnable = [self.alarmConfigView.dataArr[3] boolValue];
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JDetect_MotionDetect];
    
    JDetect_BlindDetect.Enable = [self.alarmConfigView.dataArr[4] boolValue];
    JDetect_BlindDetect.mEventHandler.RecordEnable = [self.alarmConfigView.dataArr[5] boolValue];
    JDetect_BlindDetect.mEventHandler.SnapEnable = [self.alarmConfigView.dataArr[6] boolValue];
    JDetect_BlindDetect.mEventHandler.MessageEnable = [self.alarmConfigView.dataArr[7] boolValue];
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JDetect_BlindDetect];
    
    JDetect_LossDetect.Enable = [self.alarmConfigView.dataArr[8] boolValue];
    
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JDetect_LossDetect];
}

-(void)selfDismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark callback
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
    if ([config.name isEqualToString:@JK_Detect_MotionDetect]) {
        int bEnable = JDetect_MotionDetect.Enable.Value();
        if (bEnable == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:0 withObject:@1];
        }else{
             [self.alarmConfigView.dataArr replaceObjectAtIndex:0 withObject:@0];
        }
        int bRecord = JDetect_MotionDetect.mEventHandler.RecordEnable.Value();
        if (bRecord == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:1 withObject:@1];
        }else{
            [self.alarmConfigView.dataArr replaceObjectAtIndex:1 withObject:@0];
        }
        int bCapture = JDetect_MotionDetect.mEventHandler.SnapEnable.Value();
        if (bCapture == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:2 withObject:@1];
        }else{
            [self.alarmConfigView.dataArr replaceObjectAtIndex:2 withObject:@0];
        }
        int bMessage = JDetect_MotionDetect.mEventHandler.MessageEnable.Value();
        if (bMessage == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:3 withObject:@1];
        }else{
            [self.alarmConfigView.dataArr replaceObjectAtIndex:3 withObject:@0];
        }
    }else if ([config.name isEqualToString:@JK_Detect_BlindDetect]) {
        int bEnable = JDetect_BlindDetect.Enable.Value();
        if (bEnable == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:4 withObject:@1];
        }else{
            [self.alarmConfigView.dataArr replaceObjectAtIndex:4 withObject:@0];
        }
        int bRecord = JDetect_BlindDetect.mEventHandler.RecordEnable.Value();
        if (bRecord == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:5 withObject:@1];
        }else{
            [self.alarmConfigView.dataArr replaceObjectAtIndex:5 withObject:@0];
        }
        int bCapture = JDetect_BlindDetect.mEventHandler.SnapEnable.Value();
        if (bCapture == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:6 withObject:@1];
        }else{
            [self.alarmConfigView.dataArr replaceObjectAtIndex:6 withObject:@0];
        }
        int bMessage = JDetect_BlindDetect.mEventHandler.MessageEnable.Value();
        if (bMessage == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:7 withObject:@1];
        }else{
            [self.alarmConfigView.dataArr replaceObjectAtIndex:7 withObject:@0];
        }
    }else if ([config.name isEqualToString:@JK_Detect_LossDetect]) {
        int lEnable = JDetect_LossDetect.Enable.Value();
        if (lEnable == YES) {
            [self.alarmConfigView.dataArr replaceObjectAtIndex:8 withObject:@1];
        }else{
            [self.alarmConfigView.dataArr replaceObjectAtIndex:8 withObject:@0];
        }
    }
    self.alarmConfigView.level = JDetect_MotionDetect.Level.Value();
     [self.alarmConfigView.alarmTableView reloadData];
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    
    if ([config.name isEqualToString:@JK_Detect_MotionDetect]) {
        
    }else if ([config.name isEqualToString:@JK_Detect_BlindDetect]) {
        
    }else if ([config.name isEqualToString:@JK_Detect_LossDetect]) {
        [SVProgressHUD showSuccessWithStatus:TS("Success")];
    }
}








@end
