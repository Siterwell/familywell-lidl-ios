//
//  SDKDataCenter.h
//  FunSDKDemo
//
//  Created by zyj on 2017/2/23.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDeviceInfo.h"
#import "NSUserDefaults+Extention.h"

#define DATACENTER [SDKDataCenter instance]
@interface SDKDataCenter : NSObject
+ (SDKDataCenter *)instance;

// login user name and password
@property (atomic, copy) NSString *loginUserName;
@property (atomic, copy) NSString *loginPassword;

// Device opteration
-(NSMutableArray *)GetDevices;
-(void)AddDevice:(NSDeviceInfo *)dev ResetPassword:(BOOL)bReset;
-(void)ModifyDevice:(NSDeviceInfo *)dev;
-(NSDeviceInfo *)GetDeviceBySN:(NSString *)sn;
-(NSDeviceInfo *)GetDeviceByIndex:(NSInteger)index;
-(void)DelDevice:(NSString *)sn;
-(void)DelAllDevice;
-(void)ModifyDevice:(NSString *)sn andUserName:(NSString *)userName andPassword:(NSString *)password;
-(void)ModifyDevice:(NSString *)sn andName:(NSString *)name;

-(NSString *)OptDeviceSN;
-(int)OptChannelNum;
-(void)setOptDeviceSN:(NSString *)DeviceSN Channel:(int)Channel;

@end
