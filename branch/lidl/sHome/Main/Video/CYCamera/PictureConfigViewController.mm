//
//  PictureConfigViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/14.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "PictureConfigViewController.h"
#import "PictureConfigView.h"
#import "Camera_Param.h"
#import "General_Location.h"
#import "System_TimeZone.h"
#import "TimeHelper.h"
#import "TimeSynDataSource.h"

@interface PictureConfigViewController ()
{
    Camera_Param JCamera_Param;
    General_Location JGeneral_Location;
    System_TimeZone JSystem_TimeZone;

}
@property (nonatomic, strong) PictureConfigView *pictureConfigView;
@property (nonatomic, strong)  TimeSynDataSource *dataSource; //资源和功能支持类文件
@end

@implementation PictureConfigViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[TimeSynDataSource alloc] init];
    self.title = NSLocalizedString(@"基本设置", nil);
    [self layoutSubviews];
    [self requestConfig];
}

-(void)layoutSubviews{
    self.pictureConfigView = [[PictureConfigView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.pictureConfigView.picConfigTableView.rowHeight = 50;
//    [self.pictureConfigView.picFlipRightLeftSwitch addTarget:self action:@selector(imageFlip:) forControlEvents:UIControlEventValueChanged];
//    [self.pictureConfigView.picFlipUpDownSwitch addTarget:self action:@selector(imageUpDown:) forControlEvents:UIControlEventValueChanged];
    [self.pictureConfigView.lrBtn addTarget:self action:@selector(changeFlip:) forControlEvents:UIControlEventTouchUpInside];
    [self.pictureConfigView.udBtn addTarget:self action:@selector(changeUpDown:) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self) weakSelf = self;
    self.pictureConfigView.click = ^{
        [weakSelf setTime];
    };
    [self.view addSubview:self.pictureConfigView];
}

-(void)requestConfig{
    [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeBlack];
    FUN_DevCmdGeneral(self.MsgHandle, SZSTR(self.deviceSN), 1452, SZSTR(@"OPTimeQuery"), 0, 5000, NULL, 0, -1, 0);
    [self requestGetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

#pragma mark controls's Method changge
-(void)imageFlip:(UISwitch *)swh{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JCamera_Param.PictureMirror = self.pictureConfigView.picFlipRightLeftSwitch.on;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

-(void)imageUpDown:(UISwitch *)swh{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JCamera_Param.PictureFlip = self.pictureConfigView.picFlipUpDownSwitch.on;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
//    self.pictureConfigView.picFlipRightLeftSwitch.on = JCamera_Param.PictureMirror.Value();
//    self.pictureConfigView.picFlipUpDownSwitch.on = JCamera_Param.PictureFlip.Value();
    self.pictureConfigView.lrBtn.selected = JCamera_Param.PictureMirror.Value();
    self.pictureConfigView.udBtn.selected = JCamera_Param.PictureFlip.Value();
}

- (void)changeFlip:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JCamera_Param.PictureMirror = self.pictureConfigView.lrBtn.selected;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

- (void)changeUpDown:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JCamera_Param.PictureFlip = self.pictureConfigView.udBtn.selected;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    if([config.name isEqualToString:@JK_System_TimeZone]){
        [MBProgressHUD showSuccess:NSLocalizedString(@"配置成功", nil) ToView:GetWindow];
    }

}

- (void)OnFunSDKResult:(NSNumber*)pParam {
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    if (strcmp(msg->szStr, "OPTimeQuery") == 0) {
        char *status = msg->pObject;
        NSString *sta = [NSString stringWithUTF8String:status];
        NSData *jsonData = [sta dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData!=nil){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSString *time = dict[@"OPTimeQuery"];
            _pictureConfigView.datenow = [TimeHelper dateFromString:time];
        }
    }else if(strcmp(msg->szStr, "OPTimeSetting") == 0){
        FUN_DevCmdGeneral(self.MsgHandle, SZSTR(self.deviceSN), 1452, SZSTR(@"OPTimeQuery"), 0, 5000, NULL, 0, -1, 0);
        [self requestGetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
    }
}

-(void)setTime{
    int myTime =[_dataSource getSystemTimeZone];
    NSString *strCmd = [NSString stringWithFormat:@"{\"Name\":\"System.TimeZone\", \"System.TimeZone\":{\"FirstUserTimeZone\":0,\"timeMin\":%d}}",myTime];
    JSystem_TimeZone.Parse([strCmd UTF8String]);
    [self requestSetConfigWithChannel:-1 andJObject:&JSystem_TimeZone];
    NSString *open = @"Off";
    NSArray *arrayBegin = [TimeSynDataSource getDayLightSavingBeginTime];
    NSArray *arrayEnd = [TimeSynDataSource getDayLightSavingEndTime];
    if ([arrayBegin.firstObject intValue] != 0) {
        open = @"Open";
    }
    
    NSString *strCmd2 = [NSString stringWithFormat:@"{\"Name\":\"General.Location\",\"General.Location\":{\"DSTEnd\":{\"Day\":%d,\"Hour\" : 1, \"Minute\" : 1, \"Month\" : %d, \"Week\" : 0, \"Year\" : %d }, \"DSTRule\" : \"%@\", \"DSTStart\" : { \"Day\" : %d, \"Hour\": 1, \"Minute\" : 1, \"Month\" : %d,\"Week\" : 0, \"Year\" : %d }, \"DateFormat\" : \"YYMMDD\", \"DateSeparator\" : \"-\", \"Language\" : \"SimpChinese\", \"TimeFormat\" : \"24\", \"VideoFormat\" : \"PAL\", \"WorkDay\" : 62 }}",[arrayEnd[2] intValue],[arrayEnd[1] intValue],[arrayEnd[0] intValue],open,[arrayBegin[2] intValue],[arrayBegin[1] intValue],[arrayBegin[0] intValue]];
    JGeneral_Location.Parse([strCmd2 UTF8String]);
    [self requestSetConfigWithChannel:-1 andJObject:&JGeneral_Location];
    
    
    NSString *timeString = [_dataSource getSystemTimeString];
    
    //调用保存设备时间的接口
    FUN_DevCmdGeneral(self.MsgHandle, SZSTR(self.deviceSN), 1450, "OPTimeSetting", 0, 5000, (char*)SZSTR(timeString), 0);
}
@end
