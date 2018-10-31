//
//  ChooseSystemSceneApi.m
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ChooseSystemSceneApi.h"

@implementation ChooseSystemSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_scene_group;
    bool _encrypt;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey SceneGroup:(NSString *)scene_group{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _scene_group = scene_group;
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
                             @"scene_type": @(_encrypt==NO?[_scene_group intValue]:((((~[_scene_group intValue])+65536)^0x0123)^0x1234)),
                             @"cmdId": (_encrypt==NO?@6:@106)
                             
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
