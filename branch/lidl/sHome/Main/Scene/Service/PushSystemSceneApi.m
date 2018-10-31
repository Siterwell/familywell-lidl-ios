//
//  PushSystemSceneApi.m
//  sHome
//
//  Created by shap on 2017/4/2.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "PushSystemSceneApi.h"

@implementation PushSystemSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_scene_content;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey SceneContent:(NSString *)scene_content{
    if (self = [super init]) {
        _devTid = devTid;
        _scene_content = scene_content;
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
                             @"cmdId":@24,
                             @"scene_content":_scene_content
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
