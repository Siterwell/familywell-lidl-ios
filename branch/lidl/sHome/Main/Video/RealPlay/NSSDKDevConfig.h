//
//  NSSDKDevConfig.h
//  FunSDKDemo
//
//  Created by zyj on 2017/3/6.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKObject.h"
#import "DeviceConfig.h"


@class NSSDKDevConfig;
@class DeviceConfig;
@protocol NSSDKDevConfigDelegate <NSObject>

-(void)getConfig:(DeviceConfig *)config result:(int)result;

-(void)setConfig:(DeviceConfig *)config result:(int)result;

-(void)OnSDKSeachFile:(NSSDKDevConfig *)sender Files:(H264_DVR_FILE_DATA *)pFiles Result:(int)nResult;

-(void)OnSDKSeachFileByTime:(NSSDKDevConfig *)sender Files:(SDK_SearchByTimeInfo *)pFiles Result:(int)nResult;

-(void)OnSDKSearchDevice:(int)param2 Data:(SDK_CONFIG_NET_COMMON_V2 *)pData;
@end

@interface NSSDKDevConfig : NSSDKObject
@property (nonatomic, weak, nullable) id <NSSDKDevConfigDelegate> delegate;
@property (nonatomic,assign) int getTimeout;
@property (nonatomic,assign) int setTimeout;

#pragma mark 向设备获取配置 result on delegate getConfig
-(int)requestGetConfig:(DeviceConfig *)config;

#pragma mark 向设备获取配置 (带超时时间) result on delegate getConfig
-(int)requestGetConfig:(DeviceConfig *)config withTimeout:(int)timeout;

#pragma mark 将配置保存至设备 result on delegate setConfig
-(int)requestSetConfig:(DeviceConfig *)config;

#pragma mark 将配置保存至设备 result on delegate setConfig
-(int)requestSetConfig:(DeviceConfig *)config withTimeout:(int)timeout;

#pragma mark 取消某个配置的结果接收
-(void)cancelConfig:(int)cfgId;

#pragma mark result on delegate OnSDKSeachFile
-(int)FindFile:(H264_DVR_FINDINFO *)fileInfo MaxCount:(int)nCount;

#pragma mark result on delegate OnSDKSeachFileByTime
-(int)FindFileByTime:(SDK_SearchByTime *)lpFindInfo;

-(void)searchDevice;
@end
