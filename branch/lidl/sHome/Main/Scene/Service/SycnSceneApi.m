//
//  SycnSceneApi.m
//  sHome
//
//  Created by shaop on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SycnSceneApi.h"

@implementation SycnSceneApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    NSString *_scene_group;
    NSString *_scene_content;
    NSString *_answer_content;
    bool _encrypt;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey SceneGroup:(NSString *)scene_group answerContent:(NSString *)answer_content SceneContent:(NSString *)scene_content{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _scene_group = scene_group;
        _scene_content = scene_content;
        _answer_content = answer_content;
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
                             @"cmdId": (_encrypt==NO?@31:@131),
                             @"sence_group": @(_encrypt==NO?[_scene_group intValue]:((((~[_scene_group intValue])+65536)^0x0123)^0x1234)),
                             @"answer_content":_answer_content,
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
                             @"cmdId" : @28
                             }
                     }
             };
}

-(id)requestArgumentFilterEncrypt{
    return @{
             @"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _devTid,
                     @"data" : @{
                             @"cmdId" : @128
                             }
                     }
             };
}

- (id)requestArgumentDevice{
    return _devTid;
}
@end
