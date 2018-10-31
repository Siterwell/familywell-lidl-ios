//
//  NSSDKAPConfigModel.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/20.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKAPConfigModel.h"
#import "NetworkAssistant.h"
#import "FunSDK/FunSDK.h"
#import "NSString+Extention.h"
#define SZSTR(x) (x == nil ? "" : [x UTF8String])
#define NSSTR(x) [NSString ToNSStr:x]
#define CSTR SZSTR
#define OCSTR NSSTR

@implementation NSSDKAPConfigModel
+(NSSDKAPConfigModel *)sharedInstance{
    static NSSDKAPConfigModel *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

//开始快速配置
-(int)starAPConfigWithSSID:(NSString *)SSID password:(NSString *)password{
    char data[128] = {0};
    char infof[256] = {0};
    int encmode = 1;
    unsigned char mac[6] = {0};
    sprintf(data, "S:%sP:%sT:%d", [SSID UTF8String], CSTR(password), encmode);
    NSString* sGateway = [NETWORKER getCurrentGateWay];
    sprintf(infof, "gateway:%s ip:%s submask:%s dns1:%s dns2:%s mac:0", CSTR(sGateway), [[NETWORKER getCurrentIPAddress] UTF8String],"255.255.255.0",CSTR(sGateway),CSTR(sGateway));
    NSString* sMac = [NETWORKER getCurrentMacAddress];
    sscanf(CSTR(sMac), "%x:%x:%x:%x:%x:%x", &mac[0], &mac[1], &mac[2], &mac[3], &mac[4], &mac[5]);
    
    return FUN_DevStartAPConfig(SDK_HANDLE, 3, CSTR(SSID), data, infof, CSTR(sGateway), encmode, 0, mac, -1);
//    return 1;
}


//停止快速配置
-(int)stopConfig{
    FUN_DevStopAPConfig();
    return 0;
}

#pragma FunSDKcallBack
-(void)OnFunSDKResult:(NSSDKObject *)sender MsgId:(int)msgId Param1:(int)param1 Param2:(int)param2 Param3:(int)param3 String:(const char *)szStr Data:(char *)pData DataLen:(int)length Seq:(int)seq{
    [super OnFunSDKResult:sender MsgId:msgId Param1:param1 Param2:param2 Param3:param3 String:szStr Data:pData DataLen:length Seq:seq];
    switch (msgId) {
        case EMSG_DEV_AP_CONFIG:{
            SDK_CONFIG_NET_COMMON_V2 *pCfg = (SDK_CONFIG_NET_COMMON_V2 *)pData;
            NSString* devSn = @"";
            NSString* name = @"";
            int nDevType = 0;
            int nResult = param1;
            if ( nResult>=0 && pCfg) {
                name = OCSTR(pCfg->HostName);
                devSn = OCSTR(pCfg->sSn);
                nDevType = pCfg->DeviceType;
            }
            if (self.apConfigDelegate && [self.apConfigDelegate respondsToSelector:@selector(APDevice:DevSn:deviceType:configResult:)] ) {
                [self.apConfigDelegate APDevice:name  DevSn:devSn deviceType:nDevType configResult:nResult];
            }
        }
            break;
    }
}
@end
