//
//  replaceDeviceApi.m
//  sHome
//
//  Created by shaop on 2016/12/29.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "replaceDeviceApi.h"

@implementation replaceDeviceApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_mDeviceId;
    bool _encrypt;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey mDeviceID:(NSString *)mDeviceId{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _mDeviceId = mDeviceId;
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
    NSDictionary *dic = @{
                          @"action": @"appSend",
                          @"params": @{
                                  @"devTid": _devTid,
                                  @"ctrlKey": _ctrlKey,
                                  @"data": @{
                                          @"device_ID": @(_encrypt==NO?[_mDeviceId intValue]:((((~[_mDeviceId intValue])+65536)^0x0123)^0x1234)),
                                          @"cmdId": (_encrypt==NO?@3:@103)
                                          }
                                  }
                          };
    return dic;
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
