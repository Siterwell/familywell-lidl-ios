//
//  RecordConfigVc.m
//  sHome
//
//  Created by Apple on 2017/9/4.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "RecordConfigVc.h"
#import "RecordConfigCell.h"
#import "RecordMethodCell.h"
#import "RecordConfigThrCell.h"

#import "SupportExtRecord.h"
#import "RecordCfg.h"

@interface RecordConfigVc ()
{
    SupportExtRecord JSupportExtRecord;
    RecordCfg JRecordCfg;
    RecordCfg JExtRecord;
    
}

@end

@implementation RecordConfigVc


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"录像配置";
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(btnRightClicked)];
    self.navigationItem.rightBarButtonItem = right;

    
    [self requestConfig];

}

-(void)btnRightClicked{
    
//    if (info.recordType == RecodeStreamType_Main ) {
//        [self requestSetConfigWithChannel:self.channelNum andJObject:&JRecordCfg];
//    }
//    if (info.recordType == RecodeStreamType_Sub ){
//        [self requestSetConfigWithChannel:self.channelNum andJObject:&JExtRecord];
//    }

}

-(void)requestConfig{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self requestGetConfigWithChannel:self.channelNum andJObject:&JSupportExtRecord];//是否支持主副码流
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RecordConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordConfigCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.recordTitle.text = @"预录";
            cell.recordTime.text = [NSString stringWithFormat:@"%ds",JExtRecord.PreRecord.Value()];
            cell.recordDes.text = @"该功能只有在报警或者无线遥控器产生的联动录像下才有效，它可以将报警产生之前的录像提前预录下来";
            [cell.recordSlider setValue:JExtRecord.PreRecord.Value() animated:YES];
        }else{
            cell.recordTitle.text = @"长度";
            cell.recordTime.text = [NSString stringWithFormat:@"%dmin",JExtRecord.PacketLength.Value()];
            [cell.recordSlider setValue:JExtRecord.PreRecord.Value() animated:YES];
            cell.recordDes.text = @"该功能允许您改变存放在设备里面的录像文件长度";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        RecordMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordMethodCell" forIndexPath:indexPath];
        cell.rmothedTitle.text = @"录像方式";
        cell.rmethodDes.text = @"如果选择联动录像，那意味着设备平时是不录像的，当有移动侦测等报警产生或接收到专用遥控器发出的录像指令时才开始录像";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        RecordConfigThrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordConfigThrCell" forIndexPath:indexPath];
        cell.recordTitle.text = @"录像音频";
        cell.recordDes.text = @"如果关闭，则录下来的文件没有音频";
        [cell.ypHWswitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return [UITableViewCell new];
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma configCallback
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
    if([config.name isEqualToString:@JK_SupportExtRecord]){
        int nAbility = JSupportExtRecord.AbilityPram.Value();
        if (nAbility == 0) {//不支持副码流设置
            //获取主码流配置
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [self requestGetConfigWithChannel:self.channelNum andJObject:&JRecordCfg];
//            [self.recordConfigView setConfig:&JRecordCfg andCfg:NULL];
        }else if (nAbility == 1){//只支持辅码流
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [self requestGetConfigWithChannel:self.channelNum andJObject:&JExtRecord];
//            [self.recordConfigView setConfig:NULL andCfg:&JExtRecord];
        }else if (nAbility == 2){//主副码流都支持
//            //获取主码流配置
//            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//            [self requestGetConfigWithChannel:self.channelNum andJObject:&JRecordCfg];
            //获取副码流配置
            [self requestGetConfigWithChannel:self.channelNum andJObject:&JExtRecord];
//            [self.recordConfigView setConfig:&JRecordCfg andCfg:&JExtRecord];
        }
        
        
    }else if ([config.name isEqualToString:@JK_Record]){
    }else if ([config.name isEqualToString:@JK_ExtRecord]){
    }
    [self.tableView reloadData];
}

#pragma mark 控制按钮切换
- (void)changeSwitch:(id)sender{
    
    HWSwitch *hw = (HWSwitch*)sender;
    
    NSString *onOrOff = hw.on?@"01":@"00";

}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    if ([config.name isEqualToString:@JK_Record]){
        [SVProgressHUD showSuccessWithStatus:TS("Success")];
    }else if ([config.name isEqualToString:@JK_ExtRecord]){
        [SVProgressHUD showSuccessWithStatus:TS("Success")];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
