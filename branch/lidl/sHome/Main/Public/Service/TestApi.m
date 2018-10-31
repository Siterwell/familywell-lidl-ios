//
//  TestApi.m
//  sHome
//
//  Created by shaop on 2016/12/13.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "TestApi.h"

@implementation TestApi
{
    NSString *_drivce;
}

-(id)initWithDrivce:(NSString *)drivce{
    if (self = [super init]) {
        _drivce = drivce;
    }
    return self;
}

-(id)requestArgumentDevice{
    return _drivce;
}

-(id)requestArgumentFilter{
    return@{
            @"action" : @"devSend",
            @"params" : @{
                    @"devTid" : _drivce
                    }
            };
}

-(id)requestArgumentCommand{
    return @{
             @"action":@"appSend",
             @"params": @{
                     @"devTid":_drivce,
                     @"ctrlKey":@"89bd578ce7f34a5d9d8c645c3c0b6aa1",
                     @"data":@{
                             @"cmdId":@2
                             }
                     }
             };
}

@end
