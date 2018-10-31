//
//  AlarmConfigVc.m
//  sHome
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AlarmConfigVc.h"
#import "RecordConfigThrCell.h"
#import "RecordMethodCell.h"
#import "AlarmConfigTwoCell.h"
#import "Detect_MotionDetect.h"
#import "Detect_BlindDetect.h"
#import "AlarmOut.h"
#import "SexViewPicker.h"

@interface AlarmConfigVc ()
{
    Detect_MotionDetect JDetect_MotionDetect;
    Detect_BlindDetect JDetect_BlindDetect;
    AlarmOut JDetect_AlarmOut;
    
    NSMutableArray *motionArry;
    NSMutableArray *blindArry;
    NSMutableArray *lossArry;
    
    NSString *alamType;
    NSString *alamTypeV;
    
    NSMutableArray *lmdArry;
    NSInteger lmdTypeV;
    NSMutableArray *sclxArry;
    
    SexViewPicker *sexView;
}

@end

@implementation AlarmConfigVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报警配置";
    [self.tableView registerClass:[RecordMethodCell class] forCellReuseIdentifier:@"RecordMethodCell"];
    [self.tableView registerClass:[RecordConfigThrCell class] forCellReuseIdentifier:@"RecordConfigThrCell"];
    [self.tableView registerClass:[AlarmConfigTwoCell class] forCellReuseIdentifier:@"AlarmConfigTwoCell"];
    [self requestAlarmConfigs];
    motionArry = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
    blindArry = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], [NSNumber numberWithInt:0],nil];
    lossArry = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
    
    lmdArry = [[NSMutableArray alloc] initWithObjects:@{@"key":@1,@"ENV":@"低级"},@{@"key":@3,@"ENV":@"中级"},@{@"key":@6,@"ENV":@"高级"}, nil];

    sclxArry = [[NSMutableArray alloc] initWithObjects:@{@"key":@"ConfigAlarm",@"ENV":@"自动"},@{@"key":@"ManualAlarm",@"ENV":@"手动"},@{@"key":@"CloseAlarm",@"ENV":@"关闭"}, nil];

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveConfigs)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self initAlarmPicker];
    
}

- (void)initAlarmPicker{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SexViewPicker" owner:nil options:nil];
    sexView =[nibView objectAtIndex:0];
    sexView.frame = CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width, 210);
    sexView.confirmClicked = ^(NSString *optType,NSString *selectValue,NSInteger index){
        
        if([optType isEqualToString:@"lmd"]){
            [motionArry replaceObjectAtIndex:4 withObject:[lmdArry objectAtIndex:index][@"key"]];
        }else if ([optType isEqualToString:@"sclx"]){
            alamTypeV = [sclxArry objectAtIndex:index][@"key"];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:sexView];
}

//controls methods
-(void)saveConfigs{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JDetect_MotionDetect.Enable = [[motionArry objectAtIndex:0] boolValue];

    JDetect_MotionDetect.mEventHandler.RecordEnable = [[motionArry objectAtIndex:1] boolValue];
    JDetect_MotionDetect.mEventHandler.SnapEnable = [[motionArry objectAtIndex:2] boolValue];
    JDetect_MotionDetect.mEventHandler.MessageEnable = [[motionArry objectAtIndex:3] boolValue];
    
    //灵敏度1:低级  3:中级  6:高级
    JDetect_MotionDetect.Level = [[motionArry objectAtIndex:4] intValue];
    
    //输入出使能
    JDetect_MotionDetect.mEventHandler.AlarmOutEnable = [[lossArry objectAtIndex:0] boolValue];
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JDetect_MotionDetect];
    
    
    JDetect_BlindDetect.Enable = [[blindArry objectAtIndex:0] boolValue];
    JDetect_BlindDetect.mEventHandler.RecordEnable =[[blindArry objectAtIndex:1] boolValue];
    JDetect_BlindDetect.mEventHandler.SnapEnable = [[blindArry objectAtIndex:2] boolValue];

    JDetect_BlindDetect.mEventHandler.MessageEnable = [[blindArry objectAtIndex:3] boolValue];
;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JDetect_BlindDetect];
    
    //输出类型
//    JDetect_AlarmOut.AlarmOutType = alamTypeV;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JDetect_AlarmOut];
}


-(void)requestAlarmConfigs{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self requestGetConfigWithChannel:0 andJObject:&JDetect_MotionDetect];
    [self requestGetConfigWithChannel:0 andJObject:&JDetect_BlindDetect];
    [self requestGetConfigWithChannel:0 andJObject:&JDetect_AlarmOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lmdSelect{
    [sexView showInView];
    sexView.pickers = lmdArry;
    sexView.optType = @"lmd";
    
}

- (void)sclxSelect{
    [sexView showInView];
    sexView.pickers = sclxArry;
    sexView.optType = @"sclx";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 0;
    }else if (section == 3){
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
    
        if (indexPath.row == 4) {
            RecordMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordMethodCell" forIndexPath:indexPath];
            cell.rmothedTitle.text = @"报警灵敏度";
            cell.rmethodDes.text = @"报警灵敏度分三等级:低级、中级、高级";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectValue.text = [self lmd:[[motionArry objectAtIndex:4] intValue]];
            [cell.selectBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lmdSelect)]];
            return cell;
        }
        
        RecordConfigThrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordConfigThrCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:{
                cell.recordTitle.text = @"是否侦测";
                cell.recordDes.text = @"开关打开时，设备如果检测到移动物体，会触发报警事件";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                cell.ypHWswitch.on = motionArry == nil?0:[[motionArry objectAtIndex:0] intValue];
                [cell setHWSwithcTag:100];
            }
                break;
                
            case 1:{
                cell.recordTitle.text = @"联动录像";
                cell.recordDes.text = @"开关打开时，设备如果检测到移动物体，就会开始录像";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                 cell.ypHWswitch.on = motionArry == nil?0:[[motionArry objectAtIndex:1] intValue];
                [cell setHWSwithcTag:101];
            }
                
                break;
                
            case 2:{
                cell.recordTitle.text = @"拍照联动";
                cell.recordDes.text = @"开关打开时，设备如果检测到移动物体，就会抓取一张图片";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                 cell.ypHWswitch.on = motionArry == nil?0:[[motionArry objectAtIndex:2] intValue];
                [cell setHWSwithcTag:102];
            }
                
                break;
                
            case 3:{
                cell.recordTitle.text = @"手机推送联动";
                cell.recordDes.text = @"设备触发报警时，会推送一条消息到手机";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                 cell.ypHWswitch.on = motionArry == nil?0:[[motionArry objectAtIndex:3] intValue];
                [cell setHWSwithcTag:103];
            }
                break;
                
            default:
                break;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
    }else if(indexPath.section == 1){
        RecordConfigThrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordConfigThrCell" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:{
                cell.recordTitle.text = @"遮挡开启";
                cell.recordDes.text = @"开关打开时，设备如果检测到前方被遮挡，会触发报警事件";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                 cell.ypHWswitch.on = blindArry == nil?0:[[blindArry objectAtIndex:0] intValue];
                [cell setHWSwithcTag:200];
            }
                break;
                
            case 1:{
                cell.recordTitle.text = @"联动录像";
                cell.recordDes.text = @"开关打开时，设备如果检测到前方被遮挡，就会开始录像";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                 cell.ypHWswitch.on = blindArry == nil?0:[[blindArry objectAtIndex:1] intValue];
                [cell setHWSwithcTag:201];
            }
                
                break;
                
            case 2:{
                cell.recordTitle.text = @"拍照联动";
                cell.recordDes.text = @"开关打开时，设备如果检测到前方被遮挡，就会抓取一张图片";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                cell.ypHWswitch.on = blindArry == nil?0:[[blindArry objectAtIndex:2] intValue];
                [cell setHWSwithcTag:202];
            }
                
                break;
                
            case 3:{
                cell.recordTitle.text = @"手机推送联动";
                cell.recordDes.text = @"设备触发报警时，会推送一条消息到手机";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                 cell.ypHWswitch.on = blindArry == nil?0:[[blindArry objectAtIndex:3] intValue];
                [cell setHWSwithcTag:203];
            }
                
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 2){
        //警报输入设置
        AlarmConfigTwoCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmConfigTwoCell" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:{
                cell.alermTitle.text = @"输入开启";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                [cell setHWSwithcTag:300];
            }
                break;
                
            case 1:{
                cell.alermTitle.text = @"联动录像";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                [cell setHWSwithcTag:301];
            }
                
                break;
                
            case 2:{
                cell.alermTitle.text = @"拍照联动";
                [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                [cell setHWSwithcTag:302];
            }
                
                break;
                
            case 3:{
              cell.alermTitle.text = @"手机推送联动";
            [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell setHWSwithcTag:303];
            }
                
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 3){
        
        if (indexPath.row == 1) {
            RecordMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordMethodCell" forIndexPath:indexPath];
            cell.rmothedTitle.text = @"报警输出类型";
            cell.rmethodDes.text = @"";
            cell.selectValue.text = [self alarmType:alamTypeV];
            return cell;
        }
        AlarmConfigTwoCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmConfigTwoCell" forIndexPath:indexPath];
        cell.alermTitle.text = @"报警输出状态";
        [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell setHWSwithcTag:400];
        cell.ypHWswitch.on = lossArry == nil?0:[[lossArry objectAtIndex:0] intValue];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [UITableViewCell new];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"移动侦测";
            break;
            
        case 1:
            return @"视频遮挡";
            break;
            
        case 2:
            return @"报警输入";
            break;
            
        case 3:
            return @"报警输出";
            break;
            
        default:
            break;
    }
    return @"";
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 44;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark 控制按钮切换
- (void)changeSwitch:(id)sender{
    
    HWSwitch *hw = (HWSwitch*)sender;

    switch (hw.tag) {
        case 100:{
            [motionArry replaceObjectAtIndex:0 withObject:hw.isOn?@1:@0];
        }
            break;
            
        case 101:
            [motionArry replaceObjectAtIndex:1 withObject:hw.isOn?@1:@0];
            break;
            
        case 102:
            [motionArry replaceObjectAtIndex:2 withObject:hw.isOn?@1:@0];
            break;
            
        case 103:
            [motionArry replaceObjectAtIndex:3 withObject:hw.isOn?@1:@0];
            break;
            
        case 200:
            [blindArry replaceObjectAtIndex:0 withObject:hw.isOn?@1:@0];
            break;
            
        case 201:
            [blindArry replaceObjectAtIndex:1 withObject:hw.isOn?@1:@0];
            break;
            
        case 202:
            [blindArry replaceObjectAtIndex:2 withObject:hw.isOn?@1:@0];
            break;
            
        case 203:
            [blindArry replaceObjectAtIndex:3 withObject:hw.isOn?@1:@0];
            break;
        case 300:
            
            break;
            
        case 301:
            
            break;
            
        case 302:
            
            break;
            
        case 303:
            
            break;
        case 400:
            [lossArry replaceObjectAtIndex:0 withObject:hw.isOn?@1:@0];
            break;
            
        default:
            break;
    }
}

#pragma mark callback
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
    if ([config.name isEqualToString:@JK_Detect_MotionDetect]) {
        int bEnable = JDetect_MotionDetect.Enable.Value();
        
        if (bEnable == YES) {
            [motionArry replaceObjectAtIndex:0 withObject:@1];
        }else{
            [motionArry replaceObjectAtIndex:0 withObject:@0];
        }
        int bRecord = JDetect_MotionDetect.mEventHandler.RecordEnable.Value();
        if (bRecord == YES) {
            [motionArry replaceObjectAtIndex:1 withObject:@1];
        }else{
            [motionArry replaceObjectAtIndex:1 withObject:@0];
        }
        int bCapture = JDetect_MotionDetect.mEventHandler.SnapEnable.Value();
        if (bCapture == YES) {
            [motionArry replaceObjectAtIndex:2 withObject:@1];
        }else{
            [motionArry replaceObjectAtIndex:2 withObject:@0];
        }
        int bMessage = JDetect_MotionDetect.mEventHandler.MessageEnable.Value();
        if (bMessage == YES) {
           [motionArry replaceObjectAtIndex:3 withObject:@1];
        }else{
            [motionArry replaceObjectAtIndex:3 withObject:@0];
        }
        
        //灵敏度1:低级  3:中级  6:高级
        int leve = JDetect_MotionDetect.Level.Value();
        [motionArry replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:leve]];
        
        //==========报警输出========
        int alarmOut = JDetect_MotionDetect.mEventHandler.AlarmOutEnable.Value();
        if (alarmOut == YES) {
            [lossArry replaceObjectAtIndex:0 withObject:@1];
        }else{
            [lossArry replaceObjectAtIndex:0 withObject:@0];
        }
        
//        “ConfigAlarm”, “ManualAlarm”, “ClosedAlarm”
        
        
        
//        blindArry = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
//        lossArry = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
    }else if ([config.name isEqualToString:@JK_Detect_BlindDetect]) {
        int bEnable = JDetect_BlindDetect.Enable.Value();
        if (bEnable == YES) {
            [blindArry replaceObjectAtIndex:0 withObject:@1];
        }else{
            [blindArry replaceObjectAtIndex:0 withObject:@0];
        }
        int bRecord = JDetect_BlindDetect.mEventHandler.RecordEnable.Value();
        if (bRecord == YES) {
            [blindArry replaceObjectAtIndex:1 withObject:@1];
        }else{
            [blindArry replaceObjectAtIndex:1 withObject:@0];
        }
        int bCapture = JDetect_BlindDetect.mEventHandler.SnapEnable.Value();
        if (bCapture == YES) {
            [blindArry replaceObjectAtIndex:2 withObject:@1];
        }else{
            [blindArry replaceObjectAtIndex:2 withObject:@0];
        }
        int bMessage = JDetect_BlindDetect.mEventHandler.MessageEnable.Value();
        if (bMessage == YES) {
            [blindArry replaceObjectAtIndex:3 withObject:@1];
        }else{
            [blindArry replaceObjectAtIndex:3 withObject:@0];
        }
        
        int leve = JDetect_BlindDetect.Level.Value();
        
        [blindArry replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:leve]];
   
    } else if ([config.name isEqualToString:@JK_AlarmOut]){
        //        “ConfigAlarm”, “ManualAlarm”, “ClosedAlarm”
        NSString *type = OCSTR(JDetect_AlarmOut.AlarmOutType.Value());
        alamTypeV = type;
        alamType = [self alarmType:type];
    }
    [self.tableView reloadData];
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    
    if ([config.name isEqualToString:@JK_Detect_MotionDetect]) {
        
    }else if ([config.name isEqualToString:@JK_Detect_BlindDetect]) {
        
    }
    
}

- (NSString *)lmd:(NSInteger)type
{
    if (type == 1) {
        return @"低级";
    }else if(type == 3){
        return @"中级";
    }else{
        return @"高级";
    }
}

- (NSString *)alarmType:(NSString*)type
{
    if ([type isEqualToString:@"ConfigAlarm"]) {
        return @"自动";
    }else if([type isEqualToString:@"ManualAlarm"]){
        return @"手动";
    }else{
        return @"关闭";
    }
}


@end
