//
//  ScynDeviceApi.h
//  sHome
//
//  Created by shaop on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface ScynDeviceApi : BaseDriveApi
-(id)initWithDrivce:(NSString *)drivce andCtrlKey:(NSString *)ctrlkey DeviceStatus:(NSArray *)device_status;
@end
