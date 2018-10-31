//
//  DeviceMapHelp.h
//  sHome
//
//  Created by shaop on 2017/1/16.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
#import "ItemData.h"

@interface DeviceMapHelp : NSObject
+(ItemData *)ItemWithDeivce:(DeviceModel *)model;
@end
