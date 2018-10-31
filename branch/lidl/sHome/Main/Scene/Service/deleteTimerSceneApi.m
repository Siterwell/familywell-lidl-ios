//
//  deleteTimerSceneApi.m
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "deleteTimerSceneApi.h"

@implementation deleteTimerSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_timerId;
    bool _encrypt;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey TimerId:(NSString *)timerId{
    if (self = [super init]) {
        _devTid = devTid;
        _timerId = timerId;
        _ctrlKey = ctrlKey;
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        NSString *binversion = [[config objectForKey:DeviceInfo] objectForKey:@"binVersion"];
        NSRange range =[binversion rangeOfString:@"." options:NSBackwardsSearch];
        if(range.location==NSNotFound){
            _encrypt = NO;
        }else{
            NSString *v = [binversion substringWithRange:NSMakeRange(range.location+1, binversion.length-range.location-1)];
            if( [v intValue] >14){
                _encrypt = YES;
            }else{
                _encrypt = NO;
            }
        }
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
                             @"device_ID": @(_encrypt==NO?[_timerId intValue]:((((~[_timerId intValue])+65536)^0x0123)^0x1234)),
                             @"cmdId": (_encrypt==NO?@37:@137)
                             }
                     }
             };
}

- (id)requestArgumentFilter {
    return @{
             @"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _devTid,
                     }
             };
}


- (id)requestArgumentDevice{
    return _devTid;
}
@end
