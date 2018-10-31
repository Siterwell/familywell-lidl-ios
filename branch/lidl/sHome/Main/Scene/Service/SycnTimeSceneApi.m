//
//  SycnTimeSceneApi.m
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SycnTimeSceneApi.h"

@implementation SycnTimeSceneApi

{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_time;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey Time:(NSString *)Time{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _time = Time;
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
                             @"cmdId":@35,
                             @"time":_time
                             }
                     }
             };
}

- (id)requestArgumentFilter {
    return @{
             @"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _devTid
                     }
            };
}

- (id)requestArgumentDevice{
    return _devTid;
}

@end
