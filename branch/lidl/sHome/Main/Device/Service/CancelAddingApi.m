//
//  CancelAddingApi.m
//  sHome
//
//  Created by shaop on 2017/4/20.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "CancelAddingApi.h"

@implementation CancelAddingApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
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
                             @"cmdId": @7
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
