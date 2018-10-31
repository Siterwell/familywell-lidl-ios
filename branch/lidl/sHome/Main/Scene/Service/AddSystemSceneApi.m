//
//  AddSystemSceneApi.m
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AddSystemSceneApi.h"

@implementation AddSystemSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_content;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey SceneContent:(NSString *)content{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _content = content;
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
                             @"cmdId": @23,
                             @"scene_content": _content
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
