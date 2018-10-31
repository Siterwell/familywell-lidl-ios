//
//  ClickSceneApi.m
//  sHome
//
//  Created by shaop on 2017/3/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ClickSceneApi.h"
#import "DeviceListModel.h"
@implementation ClickSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_sceneid;
    bool _encrypt;
}

-(id)initWithSceneId:(NSString *)sceneid{
    if (self = [super init]) {
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        
        _devTid = model.devTid;
        _ctrlKey = model.ctrlKey;
        _sceneid = sceneid;
        NSString *binversion = model.binVersion;
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
                             @"cmdId": (_encrypt==NO?@32:@132),
                             @"indexed": @(_encrypt==NO?[_sceneid intValue]:((((~[_sceneid intValue])+65536)^0x0123)^0x1234))
                             }
                     }
             };
}

- (id)requestArgumentFilter {
    return @{
             @"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _devTid,
                     @"data" : @{
                             @"cmdId" : @11
                             }
                     }
             };
}


- (id)requestArgumentDevice{
    return _devTid;
}

@end
