//
//  RecordConfigViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/14.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "RecordConfigViewController.h"
#import "RecordConfigView.h"
#import "SupportExtRecord.h"
#import "RecordCfg.h"
#import "ExtRecord.h"
#import "RecordConfigInfo.h"
#import "RecordConfigView.h"
#import "Simplify_Encode.h"

@interface RecordConfigViewController ()
{
    SupportExtRecord JSupportExtRecord;
    RecordCfg JRecordCfg;
    RecordCfg JExtRecord;
}
@property (nonatomic, strong) RecordConfigView *recordConfigView;
@end

@implementation RecordConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JExtRecord.SetName(JK_ExtRecord);
    [self layOutSubViews];
    [self requestConfig];
    self.title = NSLocalizedString(@"录像配置", nil);

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *img=[UIImage imageNamed:@"yes_icon"];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnRightClicked) forControlEvents:UIControlEventTouchUpInside];
    CGSize btnSize = CGSizeMake(35, 44);
    CGRect frame = btn.frame;
    frame.size = btnSize;
    btn.frame = frame;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)layOutSubViews{
//    [self setRightBtnText:@"保存"];
    __weak typeof(self) weakSelf = self;
    self.recordConfigView = [[RecordConfigView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.recordConfigView.recordWay = JExtRecord.RecordMode.Value();
    [self.recordConfigView setConfig:&JRecordCfg andCfg:&JExtRecord];
    self.recordConfigView.recordWayBlock = ^(const char *way) {
        
        JRecordCfg.RecordMode = way;
        if (strcmp(way, "ConfigRecord") == 0) {
            for (int i =0; i< JRecordCfg.Mask.Size(); i++) {
                // mask：0停止录像。6报警联动录像。7一直录像
                JRecordCfg.Mask[i][0] = 0x07;
            }
        } else if (strcmp(way, "ManualRecord") == 0){
            
            for (int i =0; i< JRecordCfg.Mask.Size(); i++) {
                // mask：0停止录像。6报警联动录像。7一直录像
                JRecordCfg.Mask[i][0] = 0x06;
            }
            JRecordCfg.RecordMode = "ConfigRecord";
        }else{
            for (int i =0; i< JRecordCfg.Mask.Size(); i++) {
                // mask：0停止录像。6报警联动录像。7一直录像
                JRecordCfg.Mask[i][0] = 0x07;
            }
        }
        [weakSelf requestSetConfigWithChannel:weakSelf.channelNum andJObject:&JRecordCfg];
    };
    [self.view addSubview:self.recordConfigView];
}

-(void)requestConfig{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self requestGetConfigWithChannel:self.channelNum andJObject:&JSupportExtRecord];//是否支持主副码流
    FUN_DevGetConfig_Json(SELF,CSTR(self.deviceSN),"Simplify.Encode",0);
}

//saveConfig
-(void)btnRightClicked{
    for (int i = 0; i < self.recordConfigView.dataArr.count; i++) {
        RecordConfigInfo *info = self.recordConfigView.dataArr[i];
        [SVProgressHUD show];
        if (info.recordType == RecodeStreamType_Main ) {
            [self requestSetConfigWithChannel:self.channelNum andJObject:&JRecordCfg];
        }
        if (info.recordType == RecodeStreamType_Sub ){
            [self requestSetConfigWithChannel:self.channelNum andJObject:&JExtRecord];
        }
    }
    
    NSDictionary *mainFormatDictionary = @{@"AudioEnable":@([self.recordConfigView.AutoEnableBtn isSelected])};
    
    NSDictionary *dictionary = @{@"MainFormat":mainFormatDictionary};
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *strValues = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    FUN_DevSetConfig_Json(SELF, SZSTR(self.deviceSN), "Simplify.Encode",
                          [strValues UTF8String],[strValues length]+1,self.channelNum);
    
}

#pragma configCallback
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
    if([config.name isEqualToString:@JK_SupportExtRecord]){
        int nAbility = JSupportExtRecord.AbilityPram.Value();
        if (nAbility == 0) {//不支持副码流设置
            //获取主码流配置
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [self requestGetConfigWithChannel:self.channelNum andJObject:&JRecordCfg];
            [self.recordConfigView setConfig:&JRecordCfg andCfg:NULL];
        }else if (nAbility == 1){//只支持辅码流
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [self requestGetConfigWithChannel:self.channelNum andJObject:&JExtRecord];
            [self.recordConfigView setConfig:NULL andCfg:&JExtRecord];
        }else if (nAbility == 2){//主副码流都支持
            //获取主码流配置
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [self requestGetConfigWithChannel:self.channelNum andJObject:&JRecordCfg];
            //获取副码流配置
            [self requestGetConfigWithChannel:self.channelNum andJObject:&JExtRecord];
            [self.recordConfigView setConfig:&JRecordCfg andCfg:&JExtRecord];
            
        }
        
    }else if ([config.name isEqualToString:@JK_Record]){
    }else if ([config.name isEqualToString:@JK_ExtRecord]){
    }
    [self.recordConfigView.configTableView reloadData];
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    if ([config.name isEqualToString:@JK_Record]){
        [SVProgressHUD showSuccessWithStatus:TS("配置成功")];
    }else if ([config.name isEqualToString:@JK_ExtRecord]){
        [SVProgressHUD showSuccessWithStatus:TS("配置成功")];
    }
}

- (void)OnFunSDKResult:(NSNumber*)pParam {
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    if (msg->id == EMSG_DEV_GET_CONFIG_JSON)
    {
        if (msg->param1 <= 0)
        {

            //[SVProgressHUD showErrorWithStatus:TS("Get_cfg_failed") duration:1.5f];
        }
        else
        {
            [SVProgressHUD dismiss];
            if (msg->pObject == NULL) {
                return;
            }
            
            NSData *data = [[[NSString alloc]initWithUTF8String:msg->pObject] dataUsingEncoding:NSUTF8StringEncoding];
            if ( data == nil )
            {
                return;
            }
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ( appData == nil)
            {
                return;
            }
            
            //TODU:  int change to string ...
            NSString* strConfigName = [appData valueForKey:@"Name"];
            
            if ( [strConfigName isEqualToString:@"Simplify.Encode"])
            {
                
                
                NSArray* simpEncodes = appData[strConfigName];
                if ( [simpEncodes count]>self.channelNum )
                {
                    SDK_EncodeConfigAll_SIMPLIIFY encodeCfgAll;
                    memset(&encodeCfgAll, 0, sizeof(SDK_EncodeConfigAll_SIMPLIIFY));
                    
                    NSDictionary* dictEncode = simpEncodes[self.channelNum];
                    NSArray*  arrayFormats = @[@"MainFormat", @"ExtraFormat"];
                    
                    SDK_MEDIA_FORMAT* pFormats[2] = {&encodeCfgAll.vEncodeConfigAll[self.channelNum].dstMainFmt,
                        &encodeCfgAll.vEncodeConfigAll[self.channelNum].dstExtraFmt};
                    for( int i=0; i < [arrayFormats count]; i++ )
                    {
                        NSDictionary* dictFormat = dictEncode[arrayFormats[i]];
                        pFormats[i]->bAudioEnable = [self JsonValueToInt:dictFormat[@"AudioEnable"]];
                        pFormats[i]->bVideoEnable = [self JsonValueToInt:dictFormat[@"VideoEnable"]];
                        NSDictionary* dictVideo = dictFormat[@"Video"];
                        pFormats[i]->vfFormat.nBitRate = [self JsonValueToInt:dictVideo[@"BitRate"]];
                        pFormats[i]->vfFormat.nFPS = [self JsonValueToInt:dictVideo[@"FPS"]];
                        pFormats[i]->vfFormat.iQuality = [self JsonValueToInt:dictVideo[@"Quality"]];
                        pFormats[i]->vfFormat.iGOP = [self JsonValueToInt:dictVideo[@"GOP"]];
                    }
                    [[self recordConfigView] setAutoEnable:pFormats[0]->bAudioEnable];
                    [self.recordConfigView.configTableView reloadData];
                }
            }
        }
    }
    else if (msg->id == EMSG_DEV_SET_CONFIG_JSON )
    {
        if ( strcmp(msg->szStr, "Simplify.Encode")==0)
        {
            if (msg->param1 != 0)
            {
                if (msg->param1 == H264_DVR_SUCCESS)
                {
                    //[SVProgressHUD showSuccessWithStatus:TS("Save_Success") duration:1.5f];
                    return;
                }
            }
        }
        [SVProgressHUD dismiss];
    }

}

-(int)JsonValueToInt:(id) value
{
    int nIntValue = 0;
    if ( [value isKindOfClass:[NSString class]] ) {
        NSString* stringValue = value;
        if ( [stringValue containsString:@"0x"] ) {
            sscanf([stringValue UTF8String], "0x%x", &nIntValue);
        }
        else
        {
            nIntValue = [stringValue intValue];
        }
    }
    else if ( [value isKindOfClass:[NSNumber class]] )
    {
        nIntValue = [value intValue];
    }
    return nIntValue;
}

@end
