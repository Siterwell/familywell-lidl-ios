//
//  HomeWellBaseConfigTableVc.h
//  sHome
//
//  Created by Apple on 2017/9/7.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceConfig.h"
#import "GUI.h"
#import "ShowError.h"

#define SELF [self MsgHandle]
#define AS_HANDLE(x) (__bridge void*) x

@interface HomeWellBaseConfigTableVc : UITableViewController

@property (nonatomic, copy) NSString *deviceSN;
@property (nonatomic, assign) int  channelNum;

@property (nonatomic) NSMutableArray* arrayCfgReqs;

@property (readonly, nonatomic) int hObj;
- (int)MsgHandle;
- (void)CloseHandle;

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
