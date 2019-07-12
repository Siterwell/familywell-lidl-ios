//
//  DeviceDataBase.h
//  sHome
//
//  Created by shaop on 2017/1/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import "DeviceMapHelp.h"

@interface DeviceDataBase : NSObject
+ (instancetype)sharedDataBase;

- (void)updateDevice:(DeviceModel *)device;

- (NSMutableArray *)selectDevice;

- (void)addDeviceName:(NSString *)device_name ID:(int)device_id;

- (void)deletDevice:(int)deviceID;

- (void)deletDevice;

- (ItemData *)selectDevice:(NSString *)deviceId;

-(DeviceModel *)selectDeviceNew:(NSString *)deviceId;

- (NSString *)getGs361Autotemp:(NSString *)deviceId;

- (NSString *)getGs361Handtemp:(NSString *)deviceId;

- (NSString *)getGs361Fangtemp:(NSString *)deviceId;

- (void)UpdateGs361AutoTemp:(NSString *)temp withDevId:(NSString *)devID;

- (void)UpdateGs361HandTemp:(NSString *)temp withDevId:(NSString *)devID;

- (void)UpdateGs361FangTemp:(NSString *)temp withDevId:(NSString *)devID;
@end
