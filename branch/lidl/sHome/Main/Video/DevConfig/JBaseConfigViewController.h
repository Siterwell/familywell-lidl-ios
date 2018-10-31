//
//  JBaseConfigViewController.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/22.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NavigationViewController.h"
#import "DeviceConfig.h"

@interface JBaseConfigViewController :NavigationViewController
@property (nonatomic, copy) NSString *deviceSN;
@property (nonatomic, assign) int  channelNum;

@property (nonatomic) NSMutableArray* arrayCfgReqs;

#pragma mark - 请求获取配置
-(void)requestGetConfigWithChannel:(int)channel andJObject:(JObject*)jobject;
-(void)requestGetConfigWithChannel:(int)channel andJObject:(JObject*)jobject andOutTime:(int)outTime;

#pragma mark - 请求设置配置
-(void)requestSetConfigWithChannel:(int)channel andJObject:(JObject*)jobject;
-(void)requestSetConfigWithChannel:(int)channel andJObject:(JObject*)jobject andOutTime:(int)outTime;

//下面两个方法在子类中实现
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config;
-(void)RefreshUIWithSetConfig:(DeviceConfig *)config;


@end
