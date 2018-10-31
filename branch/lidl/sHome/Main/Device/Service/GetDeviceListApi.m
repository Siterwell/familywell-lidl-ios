//
//  GetDeviceListApi.m
//  sHome
//
//  Created by shaop on 2016/12/29.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "GetDeviceListApi.h"

@implementation GetDeviceListApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_numbers;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Number:(NSString *)number{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _numbers = number;
    }
    return self;
}


- (id)requestArgumentCommand {
    return @{
        @"action": @"appSend",
        @"params": @{
            @"devTid": _devTid,
            @"ctrlKey": _ctrlKey,
            @"data": @{
                @"indexed": @0,
                @"numbers": _numbers,
                @"cmdId": @13
            }
        }
    };
}

- (id)requestArgumentFilter {
    return @{@"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _devTid
                     }
             };
}

- (id)requestArgumentDevice{
    return _devTid;
}

@end
