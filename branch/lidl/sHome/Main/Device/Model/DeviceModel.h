//
//  DeviceModel.h
//  sHome
//
//  Created by shaop on 2017/1/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "JSONModel+DeviceDic.h"

@interface DeviceModel : JSONModel

@property (nonatomic) int device_ID;

@property (nonatomic, strong) NSString *device_name;

@property (nonatomic, strong) NSString *device_status;
    
@end
