//
//  ScynDeviceApi.m
//  sHome
//
//  Created by shaop on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ScynDeviceApi.h"
#import "ItemData.h"
#import "BatterHelp.h"

@implementation ScynDeviceApi
{
    NSString *_drivce;
    NSString *_ctrlKey;
    NSArray *_deviceArray;
}

-(id)initWithDrivce:(NSString *)drivce andCtrlKey:(NSString *)ctrlkey DeviceStatus:(NSArray *)device_status{
    if (self = [super init]) {
        _drivce = drivce;
        _ctrlKey = ctrlkey;
        _deviceArray = device_status;
    }
    return self;
}


-(NSString *)getCRCContent{
    
    int maxId = 0;
    for (ItemData *data in _deviceArray) {
        if (data.devID && [data.devID intValue] > maxId) {
            maxId = [data.devID intValue];
        }
    }
    NSString *content = @"";
    content = [NSString stringWithFormat:@"%@",[BatterHelp gethexBybinary:(maxId*2 +2)]];
    int length = (int)content.length;
    
    for (int i = 0; i < 4 - length; i++) {
        content = [@"0" stringByAppendingString:content];
    }
    
    for (int i = 1 ; i<=maxId; i++) {
        bool hasDevice = NO;
        for (ItemData *data in _deviceArray) {
            if (data.devID && [data.devID intValue] == i) {
                
                NSString *name = data.statuCode;

                name = [BatterHelp getDeviceCRCCode:name];
                
                content = [content stringByAppendingString:name];
                hasDevice = YES;
                break;
            }
        }
        if (!hasDevice) {
            content = [content stringByAppendingString:@"0000"];
        }
    }
    
    return content;
}

-(id)requestArgumentDevice{
    return _drivce;
}

-(id)requestArgumentFilter{
    return @{
             @"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _drivce,
                     @"data" : @{
                             @"cmdId":@19,
                             }
                     }
             };
}

-(id)requestArgumentFilterEncrypt{
    return @{
             @"action" : @"devSend",
             @"params" : @{
                     @"devTid" : _drivce,
                     @"data" : @{
                             @"cmdId":@119,
                             }
                     }
             };
}

-(id)requestArgumentCommand{
    return @{
             @"action":@"appSend",
             @"params": @{
                     @"devTid":_drivce,
                     @"ctrlKey":_ctrlKey,
                     @"data":@{
                             @"cmdId":@29,
                             @"device_status":[self getCRCContent]
                             }
                     }
             };
}


- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}
@end
