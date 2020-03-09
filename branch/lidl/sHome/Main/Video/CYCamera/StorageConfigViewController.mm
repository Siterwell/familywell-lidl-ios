//
//  StorageConfigViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/22.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "StorageConfigViewController.h"
#import "MemoryConfigView.h"
#import "DeviceConfig.h"
#import "StorageInfo.h"
#import "OPStorageManager.h"
#import "General_General.h"
#import "FunSDK/netsdk.h"
#import "LEEAlert.h"

@interface StorageConfigViewController ()
{
    JObjArray<StorageInfo> jStorageInfo;
    OPStorageManager JOPStorageManager;
    General_General JGeneral_General;
}
//control
@property(nonatomic,strong)MemoryConfigView *memoryConfigView;
//data
@property (nonatomic, assign) float totalStorage;          // 总容量
@property (nonatomic, assign) float freeStorage;           // 总剩余容量
@property (nonatomic, assign) float videoTotalStorage;     // 录像总容量
@property (nonatomic, assign) float videoFreeStorage;      // 录像总剩余容量
@property (nonatomic, assign) float imgTotalStorage;       // 图像总容量
@property (nonatomic, assign) float imgFreeStorage;        // 图像总剩余容量

@property (nonatomic, assign) int serial;//磁盘
@property (nonatomic, assign) int partition;//扇区

@end

@implementation StorageConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"存储管理", nil);
    
    [self initData];
    [self requestEncodeConfig];
}

-(void)viewWillLayoutSubviews{
    [self.view addSubview: self.memoryConfigView];
}

-(void)initData{
    self.totalStorage = 0;
    self.freeStorage = 0;
    self.videoTotalStorage = 0;
    self.videoFreeStorage = 0;
    self.imgFreeStorage = 0;
    self.imgTotalStorage = 0;
    self.serial = 0;
    self.partition = 0;
}

-(void)requestEncodeConfig{
    [SVProgressHUD showWithStatus:TS("请稍后...")];
    
    //请求获取存取信息
    jStorageInfo.SetName(JK_StorageInfo);//有些配置名字是不能获得的 要自己设
    [self requestGetConfigWithChannel:-1 andJObject:&jStorageInfo];
    
    //请求获取录像满时的操作
    [self requestGetConfigWithChannel:-1 andJObject:&JGeneral_General];
}

#pragma mark LazyLoad
-(MemoryConfigView *)memoryConfigView{
    if (!_memoryConfigView) {
        _memoryConfigView = [[MemoryConfigView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height - 64)];
        [_memoryConfigView.stopBtn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
        [_memoryConfigView.circleBtn addTarget:self action:@selector(circleRecord:) forControlEvents:UIControlEventTouchUpInside];
        [_memoryConfigView.formatterButton addTarget:self action:@selector(formatterStorage:) forControlEvents:UIControlEventTouchUpInside];
//        _memoryConfigView.occupation = (self.totalStorage - self.freeStorage)/(float)self.totalStorage;
    }
    return _memoryConfigView;
}

- (void)stopRecord:(UIButton *)sender {
    JGeneral_General.OverWrite = "StopRecord";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self requestSetConfigWithChannel:-1 andJObject:&JGeneral_General];
    [_memoryConfigView.stopBtn setSelected:YES];
    [_memoryConfigView.circleBtn setSelected:NO];
}

- (void)circleRecord:(UIButton *)sender {
    JGeneral_General.OverWrite = "OverWrite";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self requestSetConfigWithChannel:-1 andJObject:&JGeneral_General];
    [_memoryConfigView.stopBtn setSelected:NO];
    [_memoryConfigView.circleBtn setSelected:YES];
}

#pragma mark ControlMethod
-(void)formatterStorage:(UIButton *)btn{
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = NSLocalizedString(@"提示", nil);
        label.textColor = RGB(28, 140, 249);
        label.font = [UIFont systemFontOfSize:15];
    })
    .LeeAddContent(^(UILabel *label) {
        label.textColor = RGB(28, 140, 249);
        label.text = NSLocalizedString(@"是否格式化设备磁盘", nil);
        label.font = [UIFont systemFontOfSize:14.5];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"取消", nil);
        action.type = LEEActionTypeCancel;
        action.titleColor = [UIColor grayColor];
        action.font = [UIFont systemFontOfSize:14];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"确定", nil);
        action.titleColor = RGB(28, 140, 249);
        action.font = [UIFont systemFontOfSize:14];
        action.clickBlock = ^{
            //格式化操作
            _serial = 0;
            _partition = 0;
            [self onFormatDisk:_serial Partition:_partition];

        };
    })
    .LeeShow();
    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:TS("All videos and photos will be deleted") preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAc = [UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *deleteAc = [UIAlertAction actionWithTitle:TS("Delete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        //格式化操作
//        _serial = 0;
//        _partition = 0;
//        [self onFormatDisk:_serial Partition:_partition];
//    }];
//    [alertVC addAction:cancelAc];
//    [alertVC addAction:deleteAc];
//    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)onFormatDisk:(int) disk Partition:(int ) partition {
    [SVProgressHUD showWithStatus:TS("正在格式化")];
    //格式化操作
    JOPStorageManager.Action = "Clear";
    JOPStorageManager.SerialNo = disk;
    JOPStorageManager.PartNo = partition;
    JOPStorageManager.Type = "Data";
    
    [self requestSetConfigWithChannel:-1 andJObject:&JOPStorageManager andOutTime:25000];//因为格式化是分块格式化的  耗时  所以超时时间设长
}

-(void)changeRecordStyle:(UISegmentedControl *)seg{
    JGeneral_General.OverWrite = self.memoryConfigView.OverWriteSegment.selectedSegmentIndex == 0 ? "JSON_StopRecord":"OverWrite";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self requestSetConfigWithChannel:-1 andJObject:&JGeneral_General];
}

// 将容量数值转化字符串
-(NSString *)changeCapcity:(float)capcitynum{
    NSString * capcitystr;
    if(capcitynum >= 1024){
        float freenum = capcitynum/1024;
        capcitystr = [NSString stringWithFormat:@"%.2f%@",freenum,@"G"];
    }
    else if (capcitynum < 1){
        float freenum = capcitynum*1024;
        capcitystr = [NSString stringWithFormat:@"%.2f%@",freenum,@"K"];
    }
    else{
        capcitystr = [NSString stringWithFormat:@"%d%@",(int)(capcitynum),@"M"];
    }
    return capcitystr;
}

#pragma mark RefreshUI
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
    if ([config.name isEqualToString:@JK_StorageInfo]) {
        NSData *jsonData = [config.jLastStrCfg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        if (jsonData == nil) {
            return;
        }
        NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        NSArray *infoArray = infoDic[@"StorageInfo"][0][@"Partition"];
        for (int i = 0; i < SDK_MAX_DISK_PER_MACHINE && i < infoArray.count; i++) {
            //录像分区
            if ([infoArray[i][@"DirverType"] intValue]==0) {
                NSString *videoTotalString =infoArray[i][@"TotalSpace"];
                NSString *videoRemainString =infoArray[i][@"RemainSpace"];
                unsigned long videoTotalCapacity =  strtoul([videoTotalString UTF8String], 0, 16);
                unsigned long videoRemainVapacity =  strtoul([videoRemainString UTF8String], 0, 16);
                _videoTotalStorage += videoTotalCapacity;
                _videoFreeStorage += videoRemainVapacity;
            }
            //图片分区
            if ([infoArray[i][@"DirverType"] intValue]== 4) {
                NSString *imageTotalString =infoArray[i][@"TotalSpace"];
                NSString *imageRemainString =infoArray[i][@"RemainSpace"];
                unsigned long imageTotalCapacity =  strtoul([imageTotalString UTF8String], 0, 16);
                unsigned long imageRemainVapacity =  strtoul([imageRemainString UTF8String], 0, 16);
                _imgTotalStorage += imageTotalCapacity;
                _imgFreeStorage += imageRemainVapacity;
            }
        }
        _totalStorage = _imgTotalStorage + _videoTotalStorage;
        _freeStorage = _imgFreeStorage + _videoFreeStorage;
        
        NSString *totalStorageStr = [self changeCapcity:_totalStorage];
        NSString *freeStorageStr = [self changeCapcity: _freeStorage];
        NSString *imgTotalStorageStr = [self changeCapcity:_imgTotalStorage];
        NSString *videoTotalStorageStr = [self changeCapcity:_videoTotalStorage];
        
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:totalStorageStr,videoTotalStorageStr,imgTotalStorageStr,freeStorageStr,@"0",@"0", nil];
        [self.memoryConfigView.dataArr removeAllObjects];
        self.memoryConfigView.dataArr = arr;
        self.memoryConfigView.occupation = (self.totalStorage - self.freeStorage)/(float)self.totalStorage;
        [self.memoryConfigView.memoryTableView reloadData];
    }
    
    //录像满时
    if ([config.name isEqualToString:@JK_General_General]) {
        if ([OCSTR(JGeneral_General.OverWrite.Value()) isEqualToString:@"StopRecord"]) {
            [self.memoryConfigView.stopBtn setSelected:YES];
            [self.memoryConfigView.circleBtn setSelected:NO];
        } else {
            [self.memoryConfigView.stopBtn setSelected:NO];
            [self.memoryConfigView.circleBtn setSelected:YES];
        }
    }
    
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    if ([config.name isEqualToString:@JK_OPStorageManager]) {
        
        _partition++;//格式化成功一个分区
        
        if (_partition < jStorageInfo[_serial].Partition.Size()) {
            //格式化操作
            [self onFormatDisk:_serial Partition:_partition];
        } else {
            //弹出格式化成功
            [SVProgressHUD showSuccessWithStatus:TS("格式化成功")];
            
            //    数据初始化
            [self initData];
            //重新请求获取存取信息
            [self requestGetConfigWithChannel:-1 andJObject:&jStorageInfo];
        }
    }
    //录像满时
    if ([config.name isEqualToString:@JK_General_General]) {
        [SVProgressHUD showSuccessWithStatus:TS("配置成功")];
    }
}


@end
