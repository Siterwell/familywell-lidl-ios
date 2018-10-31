//
//  JBaseConfigViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/22.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "JBaseConfigViewController.h"
#import "NSSDKDevConfig.h"
#import "NSDeviceInfo.h"
#import "SDKDataCenter.h"
#import "SVProgressHUD.h"
//#import "DeviceAddVC.h"

@interface JBaseConfigViewController ()<NSSDKDevConfigDelegate>
@property (nonatomic,strong)NSSDKDevConfig *SDKDevConfig;
@end

@implementation JBaseConfigViewController

-(instancetype)init{
    id obj = [super init];
    
    self.arrayCfgReqs = [[NSMutableArray alloc] initWithCapacity:8];
    
    return obj;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark Lazyload
-(NSSDKDevConfig *)SDKDevConfig{
    if (!_SDKDevConfig) {
        _SDKDevConfig = [[NSSDKDevConfig alloc]init];
        _SDKDevConfig.delegate = self;
    }
    return _SDKDevConfig;
}

-(DeviceConfig *)makeDeviceConfigWithChannel:(int)channel andJObject:(JObject*)jobject{
    DeviceConfig *devConfig = [[DeviceConfig alloc]initWithJObject:jobject];
    devConfig.devId = self.deviceSN;
    devConfig.channel = channel;
    return devConfig;
}

//get
-(void)requestGetConfigWithChannel:(int)channel andJObject:(JObject*)jobject{
    DeviceConfig *devConfig = [self makeDeviceConfigWithChannel:channel andJObject:jobject];
    [self requestGetConfig:devConfig];
}

-(void)requestGetConfigWithChannel:(int)channel andJObject:(JObject*)jobject andOutTime:(int)outTime{
    DeviceConfig *devConfig = [self makeDeviceConfigWithChannel:channel andJObject:jobject];
    [self requestGetConfig:devConfig withTimeout:outTime];
}

//set
-(void)requestSetConfigWithChannel:(int)channel andJObject:(JObject*)jobject{
    DeviceConfig *devConfig = [self makeDeviceConfigWithChannel:channel andJObject:jobject];
    [self requestSetConfig:devConfig];
}
-(void)requestSetConfigWithChannel:(int)channel andJObject:(JObject*)jobject andOutTime:(int)outTime{
    DeviceConfig *devConfig = [self makeDeviceConfigWithChannel:channel andJObject:jobject];
    [self requestSetConfig:devConfig withTimeout:outTime];
}


#pragma mark - 请求获取配置
-(void)requestGetConfig:(DeviceConfig*)config{
    int nSeq = [self.SDKDevConfig requestGetConfig:config];
    [self.arrayCfgReqs addObject:[[NSNumber alloc] initWithInt:nSeq]];
}

#pragma mark 请求获取配置 (带超时时间)
-(void)requestGetConfig:(DeviceConfig *)config withTimeout:(int)timeout{
    int nSeq = [self.SDKDevConfig  requestGetConfig:config withTimeout:timeout];
    [self.arrayCfgReqs addObject:[[NSNumber alloc] initWithInt:nSeq]];
}


#pragma mark - 请求设置配置
-(void)requestSetConfig:(DeviceConfig*)config{
    int nSeq = [self.SDKDevConfig requestSetConfig:config];
    [self.arrayCfgReqs addObject:[[NSNumber alloc] initWithInt:nSeq]];
}

#pragma mark 请求设置配置 (带超时时间)
-(void)requestSetConfig:(DeviceConfig *)config withTimeout:(int)timeout{
    int nSeq = [self.SDKDevConfig requestSetConfig:config withTimeout:timeout];
    [self.arrayCfgReqs addObject:[[NSNumber alloc] initWithInt:nSeq]];
}


#pragma mark - 界面消失后要取消接收该消息
-(void)viewDidDisappear:(BOOL)animated{
    for ( NSNumber* num in self.arrayCfgReqs) {
        [self.SDKDevConfig cancelConfig:[num intValue]];
    }
}


#pragma mark FunSDKCallBack  NSSDKDevConfigDelegate
-(void)getConfig:(DeviceConfig *)config result:(int)result{
    [SVProgressHUD dismiss];
    if(result < 0){
//        [SVProgressHUD showErrorWithStatus: [SDKParser parseError:result] duration:3];
        if (result == EE_DVR_PASSWORD_NOT_VALID) {//密码错误
            NSDeviceInfo *dev = [DATACENTER GetDeviceBySN:self.deviceSN];
//            DeviceAddVC *pModifyDev = [[DeviceAddVC alloc] initWith:dev IsAdd:NO];
//            pModifyDev.name = TS("Modify Device Password");
//            [self presentViewController:pModifyDev animated:YES completion:nil];
        }
    }else{
        [self RefreshUIWithGetConfig:config];
    }
    
}

-(void)setConfig:(DeviceConfig *)config result:(int)result{
    [SVProgressHUD dismiss];
    if (result < 0) {
//        [SVProgressHUD showErrorWithStatus: [SDKParser parseError:result] duration:3];
    }else{
        [self RefreshUIWithSetConfig:config];
    }
}


//下面两个方法在子类中实现
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
    
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    
}


@end
