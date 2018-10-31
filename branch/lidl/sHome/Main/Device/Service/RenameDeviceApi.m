//
//  RenameDeviceApi.m
//  sHome
//
//  Created by shap on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "RenameDeviceApi.h"

@implementation RenameDeviceApi
{
    NSString *_devTid;
    NSString *_ctrlKey;
    int _deviceId;
    NSString *_deviceName;
    bool _encrypt;
}

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey DeviceId:(int)deviceId DeviceName:(NSString *)deviceName{
    if (self = [super init]) {
        _devTid = devTid;
        _ctrlKey = ctrlKey;
        _deviceId = deviceId;
        _deviceName = [self getDeviceName:deviceName];
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

- (NSString *)getDeviceName:(NSString *)deviceName{
    NSString *content = @"";
    NSString *nameString = @"";
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *namedata = [deviceName dataUsingEncoding:enc];
    
    NSInteger countf = 15 - namedata.length;
    for(int i = 0 ; i < countf ; i++){
        nameString = [nameString stringByAppendingString:@"@"];
    }
    deviceName = [NSString stringWithFormat:@"%@%@%@",nameString,deviceName,@"$"];
    namedata = [deviceName dataUsingEncoding:enc];
    deviceName = [self convertDataToHexStr:namedata];
    content = [content stringByAppendingString:deviceName];
    
    return content;
}


- (id)requestArgumentCommand {
    return @{
             @"action": @"appSend",
             @"params": @{
                     @"devTid": _devTid,
                     @"ctrlKey": _ctrlKey,
                     @"data": @{
                             @"device_ID": @(_encrypt==NO?_deviceId:((((~_deviceId)+65536)^0x0123)^0x1234)),
                             @"cmdId": (_encrypt==NO?@5:@105),
                             @"device_name": _deviceName
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
