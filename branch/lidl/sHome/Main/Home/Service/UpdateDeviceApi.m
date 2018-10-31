//
//  UpdateDeviceApi.m
//  sHome
//
//  Created by shap on 2017/4/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "UpdateDeviceApi.h"
#import "DeviceListModel.h"

@implementation UpdateDeviceApi
{
    GatewayVersionModel *_model;
}
-(id)initWithGatewayVersionModel:(GatewayVersionModel *)model{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

-(id)requestArgumentDevice{
    return _model.devTid;
}

-(id)requestArgumentFilter{
    return @{@"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _model.devTid
                     }
             };;
}

-(id)requestArgumentCommand{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *device = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    return @{
             @"action":@"devUpgrade",
             @"params": @{
                     @"devTid":_model.devTid,
                     @"ctrlKey" : device.ctrlKey,
                     @"binUrl" : _model.devFirmwareOTARawRuleVO.binUrl,
                     @"binType" : _model.devFirmwareOTARawRuleVO.latestBinType,
                     @"md5" : _model.devFirmwareOTARawRuleVO.md5,
                     @"binVer":_model.devFirmwareOTARawRuleVO.latestBinVer,
                     @"size":_model.devFirmwareOTARawRuleVO.size
                     }
             };
}


@end
