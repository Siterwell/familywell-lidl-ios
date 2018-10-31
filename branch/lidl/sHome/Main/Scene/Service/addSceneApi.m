//
//  addSceneApi.m
//  sHome
//
//  Created by shaop on 2016/12/29.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "addSceneApi.h"

@implementation addSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_type;
    NSString *_content;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey SceneTpye:(NSString *)type SceneContent:(NSString *)content{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _type = type;
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
                             @"cmdId": @8,
                             @"scene_type": _type,
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
