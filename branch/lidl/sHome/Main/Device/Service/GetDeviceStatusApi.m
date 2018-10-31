//
//  GetDeviceStatusApi.m
//  sHome
//
//  Created by shaop on 2016/12/29.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "GetDeviceStatusApi.h"

@implementation GetDeviceStatusApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_mDeviceId;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey mDeviceID:(NSString *)mDeviceId{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _mDeviceId = mDeviceId;
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
                             @"device_ID": _mDeviceId,
                             @"cmdId": @16
                             }
                     }
             };
}

- (id)requestArgumentFilter {
    return @{@"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _devTid
                     }
             };;
}

- (id)requestArgumentDevice{
    return _devTid;
}

@end
