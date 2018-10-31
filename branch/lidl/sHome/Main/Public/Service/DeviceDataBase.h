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
@end
