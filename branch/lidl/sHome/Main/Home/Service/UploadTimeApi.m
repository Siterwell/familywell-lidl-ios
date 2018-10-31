//
//  UploadTimeApii.m
//  sHome
//
//  Created by 沈晓鹏 on 2017/3/31.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "UploadTimeApi.h"
#import "TimeHelper.h"
@implementation UploadTimeApi
{
    NSString *_drivce;
    NSString *_ctrlKey;
    NSString *_device_status;
}

- (id)initWithDrivce:(NSString *)drivce andCtrlKey:(NSString *)ctrlkey{
    if (self = [super init]) {
        _drivce = drivce;
        _ctrlKey = ctrlkey;
    }
    return self;
}

-(id)requestArgumentDevice{
    return _drivce;
}

-(id)requestArgumentFilter{
    return @{@"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _drivce
                     }
             };;
}

-(id)requestArgumentCommand{

    return @{
             @"action":@"appSend",
             @"params": @{
                     @"devTid":_drivce,
                     @"ctrlKey":_ctrlKey,
                     @"data":@{
                             @"cmdId":@21,
                             @"time":[TimeHelper getSTHTime]
                             }
                     }
             };
}

@end
