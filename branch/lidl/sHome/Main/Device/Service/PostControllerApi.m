//
//  PostControllerApi.m
//  sHome
//
//  Created by shaop on 2017/1/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "PostControllerApi.h"

@implementation PostControllerApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    int _deviceId;
    NSString *_deviceStatus;
    bool _encrypt;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey DeviceId:(int)deviceId DeviceStatus:(NSString *)deviceStatus{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _deviceId = deviceId;
        _deviceStatus = deviceStatus;
        
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
                             @"cmdId": (_encrypt==NO?@1:@101),
                             @"device_ID": @(_encrypt==NO?_deviceId:((((~_deviceId)+65536)^0x0123)^0x1234)),
                             @"device_status": _deviceStatus
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
