//
//  MainDeviceApi.m
//  sHome
//
//  Created by shaop on 2017/1/18.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "MainDeviceApi.h"

@implementation MainDeviceApi
{
    NSString *_drivce;
    NSString *_ctrlKey;

}

-(id)initWithDrivce:(NSString *)drivce andCtrlKey:(NSString *)ctrlkey{
    if (self = [super init]) {
        _drivce = drivce;
        _ctrlKey = ctrlkey;
    }
    return self;
}

-(id)requestArgumentDevice{
    return _drivce;
}

-(id)requestArgumentFilter{
    return @{
            @"action" : @"devSend",
            @"params" : @{
                    @"devTid" : _drivce,
                    @"data" : @{
                            @"cmdId" : @19
                            }
                    }
            };
}

-(id)requestArgumentFilterEncrypt{
    return @{
             @"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _drivce,
                     @"data" : @{
                             @"cmdId":@119,
                             }
                     }
             };
}


-(id)requestArgumentCommand{
    return @{
             @"action":@"appSend",
             @"params": @{
                     @"devTid":_drivce,
                     @"ctrlKey":_ctrlKey,
                     @"data":@{
                             @"indexed": @0,
                             @"numbers": @20,
                             @"cmdId":@15
                             }
                     }
             };
}

@end
