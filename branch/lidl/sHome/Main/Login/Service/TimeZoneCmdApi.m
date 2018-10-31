//
//  TimeZoneCmdApi.m
//  sHome
//
//  Created by CY on 2017/9/11.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "TimeZoneCmdApi.h"

@implementation TimeZoneCmdApi {
    NSString *_devTid;
    NSString *_ctrlKey;
    NSInteger _zoneOffset;
}

- (id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey {
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        
        NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone] ;///获取当前时区信息
        NSInteger sourceGMTOffset = [destinationTimeZone secondsFromGMTForDate:[NSDate date]];///获取偏移秒数
        _zoneOffset = sourceGMTOffset/3600;
        _zoneOffset = _zoneOffset > 0 ? _zoneOffset : 256 + _zoneOffset;
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
                             @"cmdId": @251,
                             @"TimeZone":@(_zoneOffset)
                             }
                     }
             };
}



- (id)requestArgumentDevice{
    return _devTid;
}

@end
