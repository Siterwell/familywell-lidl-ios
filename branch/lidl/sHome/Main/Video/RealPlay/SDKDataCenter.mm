//
//  SDKDataCenter.m
//  FunSDKDemo
//
//  Created by zyj on 2017/2/23.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//
#import "FunSupport.h"
#import "SDKDataCenter.h"
#import "GUI.h"

@interface SDKDataCenter (){
}
@property(nonatomic, strong)NSMutableArray *devices;
@property(nonatomic, copy)NSString *optDevice;
@property(nonatomic,assign)int optChannel;
@end

@implementation SDKDataCenter
+ (SDKDataCenter *)instance{
    static SDKDataCenter* sharedSupport = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSupport = [[self alloc] init];
    });
    
    return sharedSupport;
}

-(id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.loginUserName = @"";
    self.loginPassword = @"";
    
    _optDevice = [NSUserDefaults getStrValue:TOUD(UD_KEY_LAST_DEVICE)];
    _optChannel = [NSUserDefaults getIntValue:TOUD(UD_KEY_LAST_CHANNEL_NUM)];
    _devices = [[NSMutableArray alloc] initWithCapacity:0];
    return self;
}

-(NSMutableArray *)GetDevices{
    return _devices;
}

-(void)ModifyDevice:(NSDeviceInfo *)dev{
    NSDeviceInfo *pNow = [self GetDeviceBySN:dev.sn];
    if (pNow == nil) {
        [self AddDevice:dev ResetPassword:YES];
    } else {
        FUN_DevSetLocalPwd(SZSTR(dev.sn), SZSTR(dev.userName), SZSTR(dev.password));//修改密码后 本地保存下
    }
    pNow.userName = dev.userName;
    pNow.password = dev.password;
    pNow.name = dev.name;
}

-(void)AddDevice:(NSDeviceInfo *)dev ResetPassword:(BOOL)bReset{
    [_devices addObject:dev];
    if (bReset) {
        FUN_DevSetLocalPwd(SZSTR(dev.sn), SZSTR(dev.userName), SZSTR(dev.password));
    }
}

-(NSDeviceInfo *)GetDeviceBySN:(NSString *)sn{
    for (NSDeviceInfo *dev in _devices) {
        if ([dev.sn isEqualToString:sn]) {
            return dev;
        }
    }
    return nil;
}

-(NSDeviceInfo *)GetDeviceByIndex:(NSInteger)index{
    if(index < 0 || index >= [_devices count]){
        return nil;
    }
    return _devices[index];
}

-(void)DelDevice:(NSString *)sn{
    NSDeviceInfo *dev = [self GetDeviceBySN:sn];
    if (dev) {
        [_devices removeObject:dev];
    }
}

-(void)DelAllDevice{
    [_devices removeAllObjects];
}

-(void)ModifyDevice:(NSString *)sn andUserName:(NSString *)userName andPassword:(NSString *)password{
    NSDeviceInfo *dev = [self GetDeviceBySN:sn];
    if (dev) {
        dev.password = password;
        if (userName != nil) {
            dev.userName =  userName;
        }
        FUN_DevSetLocalPwd(SZSTR(sn), SZSTR(dev.userName), SZSTR(dev.password));
    }
}

-(void)ModifyDevice:(NSString *)sn andName:(NSString *)name{
    NSDeviceInfo *dev = [self GetDeviceBySN:sn];
    if (dev) {
        dev.name = name;
    }
}

-(NSString *)OptDeviceSN{
    return _optDevice;
}
-(int)OptChannelNum{
    return _optChannel;
}

-(void)setOptDeviceSN:(NSString *)DeviceSN Channel:(int)Channel{
    [NSUserDefaults setValue:TOUD(UD_KEY_LAST_DEVICE) Value:DeviceSN];
    self.optDevice = DeviceSN;
    if (Channel >= 0) {
        self.optChannel = Channel;
        [NSUserDefaults setIntValue:TOUD(UD_KEY_LAST_CHANNEL_NUM) Value:Channel];
    }
}
@end
