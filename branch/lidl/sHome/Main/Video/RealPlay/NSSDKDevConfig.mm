//
//  NSSDKDevConfig.m
//  FunSDKDemo
//
//  Created by zyj on 2017/3/6.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKDevConfig.h"
#import "GTMNSString+HTML.h"
#import "FunSDK/FunSDK.h"
#import "GUI.h"

static int seq = 0;
@interface NSSDKDevConfig()

//key格式： configname[channelno][seq]
//value:   DeviceConfig*
@property (nonatomic) NSMutableDictionary* dicConfig;
@end

@implementation NSSDKDevConfig

-(instancetype)init{
    id obj = [super init];
    self.setTimeout = 10000;
    self.getTimeout = 10000;
    self.dicConfig = [[NSMutableDictionary alloc] initWithCapacity:0];
    return obj;
}



-(int)FindFile:(H264_DVR_FINDINFO *)fileInfo MaxCount:(int)nCount{
    return FUN_DevFindFile(SDK_HANDLE, SZSTR(self.device), fileInfo, nCount);
}

-(int)FindFileByTime:(SDK_SearchByTime *)lpFindInfo{
    return FUN_DevFindFileByTime(SDK_HANDLE, SZSTR(self.device), lpFindInfo);
}


#pragma mark 向设备获取配置
-(int)requestGetConfig:(DeviceConfig*)config{
    return [self requestGetConfig:config withTimeout:self.getTimeout];
}

#pragma mark 向设备获取配置 (带超时时间)
-(int)requestGetConfig:(DeviceConfig*)config withTimeout:(int)timeout{
    NSString* sCfgId = [NSString stringWithFormat:@"%d", seq];
    if ( [self.dicConfig objectForKey:sCfgId] ) {
        [self.dicConfig removeObjectForKey:sCfgId];
    }
    self.dicConfig[sCfgId] = config;
    if(config.nCfgCommand == 0){
//        FUN_DevGetConfig_Json(SDK_HANDLE, CSTR(config.devId), "AlarmFunction.[0]", 1024, config.channel, timeout, seq);//调试用 勿删除
        
        FUN_DevGetConfig_Json(SDK_HANDLE, CSTR(config.devId), CSTR(config.name), 1024, config.channel, timeout, seq);
    }else{
        FUN_DevCmdGeneral(SDK_HANDLE, CSTR(config.devId), config.nCfgCommand, CSTR(config.name), config.nBinary, timeout, NULL, 0, 0, seq);
    }
    return seq++;
}

#pragma mark 将配置保存至设备
-(int)requestSetConfig:(DeviceConfig*)config{
    return [self requestSetConfig:config withTimeout:self.setTimeout];
}

#pragma mark 将配置保存至设备
-(int)requestSetConfig:(DeviceConfig*)config withTimeout:(int)timeout{
    NSString* sCfgId = [NSString stringWithFormat:@"%d", seq];
    if ( [self.dicConfig objectForKey:sCfgId] ) {
        [self.dicConfig removeObjectForKey:sCfgId];
    }
    self.dicConfig[sCfgId] = config;
    const char* pCfgBuf = config.jObject->ToString();
    config.jLastStrCfg = OCSTR(pCfgBuf);
    FUN_DevSetConfig_Json(SDK_HANDLE, CSTR(config.devId), CSTR(config.name), pCfgBuf, (int)(strlen(pCfgBuf) + 1), config.channel, timeout, seq);
    self.setTimeout = 10000;
    return seq++;
}

#pragma mark 取消某个配置的结果接收
-(void)cancelConfig:(int)cfgId{
    NSString* sCfgId = [NSString stringWithFormat:@"%d",cfgId];
    [self.dicConfig removeObjectForKey:sCfgId];
}


-(void)OnFunSDKResult:(NSSDKObject *)sender MsgId:(int)msgId Param1:(int)param1 Param2:(int)param2 Param3:(int)param3 String:(const char *)szStr Data:(char *)pData DataLen:(int)length Seq:(int)seq{
    [super OnFunSDKResult:sender MsgId:msgId Param1:param1 Param2:param2 Param3:param3 String:szStr Data:pData DataLen:length Seq:seq];
    
    switch (msgId) {
#pragma mark - EMSG_DEV_GET_CONFIG_JSON
        case EMSG_DEV_GET_CONFIG_JSON:
        case EMSG_DEV_CMD_EN:
        {
            NSString* sCfgId = [NSString stringWithFormat:@"%d",seq];
            DeviceConfig* config = self.dicConfig[sCfgId];
            if (config) {
                if ( pData ) {
                    NSString* strName;
                    if ( config.channel >= 0 ) {
                        strName = [NSString stringWithFormat:@"%@.[%ld]", config.name, (long)config.channel];
                    }
                    else{
                        strName = config.name;
                    }
                    if (pData == NULL) {
                        return;
                    }

                    if (config.jLastStrCfg == nil) {
                        config.jLastStrCfg = [OCSTR(pData) gtm_stringByUnescapingFromHTML];
                    }

                    NSString *tmpStr = [config.jLastStrCfg stringByReplacingOccurrencesOfString:strName withString:config.name];

                    config.jLastStrCfg = tmpStr;
                    if ( config.jObject ) {
                         config.jObject->Parse(CSTR(config.jLastStrCfg));
                    }
                }
                if (config == nil || szStr == NULL) {
                    return;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(getConfig:result:)] ) {
                    [self.delegate getConfig:config result:param1];
                }
                [self.dicConfig removeObjectForKey:sCfgId];
            }
        }
            break;
#pragma mark - EMSG_DEV_SET_CONFIG_JSON
        case EMSG_DEV_SET_CONFIG_JSON:
        {
            NSString* sCfgId = [NSString stringWithFormat:@"%d",seq];
            DeviceConfig* config = self.dicConfig[sCfgId];
            if (config) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(setConfig:result:)]) {
                    [self.delegate setConfig:config result:param1];
                    [self.dicConfig removeObjectForKey:sCfgId];
                }
            }
        }
            break;
#pragma mark - EMSG_DEV_FIND_FILE
        case EMSG_DEV_FIND_FILE:{
            if(self.delegate && [self.delegate respondsToSelector:@selector(OnSDKSeachFile:Files:Result:)]){
                [self.delegate OnSDKSeachFile:self Files:(H264_DVR_FILE_DATA *)pData Result:param1];
            }
        }
            break;
        case EMSG_DEV_FIND_FILE_BY_TIME:{
            if(self.delegate && [self.delegate respondsToSelector:@selector(OnSDKSeachFile:Files:Result:)]){
                [self.delegate OnSDKSeachFileByTime:self Files:(SDK_SearchByTimeInfo *)pData Result:param1];
            }
        }
           break;
        case EMSG_DEV_SEARCH_DEVICES:
        {
            if (param1 <= 0) {
                //  none
                [SVProgressHUD showErrorWithStatus: NSLocalizedString(@"没有数据", nil)];
                break;
            }
            
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(OnSDKSearchDevice:Data:)]){
                [self.delegate OnSDKSearchDevice:param2 Data:(SDK_CONFIG_NET_COMMON_V2 *)pData];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 局域网搜索
-(void)searchDevice
{
    FUN_DevSearchDevice(SDK_HANDLE, 4000, 0);
}
@end

