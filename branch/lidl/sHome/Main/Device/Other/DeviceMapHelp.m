//
//  DeviceMapHelp.m
//  sHome
//
//  Created by shaop on 2017/1/16.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "DeviceMapHelp.h"
#import "BatterHelp.h"
#import "EquipmentState.h"

@implementation DeviceMapHelp

+(ItemData *)ItemWithDeivce:(DeviceModel *)model{
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    NSDictionary *names = [dic valueForKey:@"names"];
    NSDictionary *pictures = [dic valueForKey:@"pictures"];

    if ([model.device_status isEqualToString:@"OVER"] || model.device_ID > 5000 || model.device_ID == 65535) {
        return nil;
    }
    if (model.device_name.length >= 4) {
        NSString *subName = [model.device_name substringWithRange:NSMakeRange(1, 3)];
        ItemData *data = [[ItemData alloc] initWithTitle:[names objectForKey:subName] Status:[self getStatus:model.device_status name:[names objectForKey:subName]] DevID:[NSString stringWithFormat:@"%d",model.device_ID] Images:[pictures objectForKey:subName] Code:model.device_status];
        if (model.device_status.length >= 6) {
            data.desc = [model.device_status substringWithRange:NSMakeRange(4, 2)];
        } else {
            data.desc = @"";
        }
        
        return data;

    }else {
        return [[ItemData alloc] init];
    }
}


+ (NSString *)getStatus:(NSString *)status name:(NSString *)name {
    if (status.length>=8) {
        NSString *battery = [status substringWithRange:NSMakeRange(2, 2)];
        NSString *switchStatus = [status substringWithRange:NSMakeRange(6, 2)];
        status = [status substringWithRange:NSMakeRange(4, 2)];
        
        if([name isEqualToString:@"温控器"]){
            if ([status containsString:@"FF"]) {
                return @"no";
            } else {
                if ([[BatterHelp getBatterFormDevice:battery] intValue] <= 15) {
                    return @"gz";
                } else {
                    return @"aq";
                }
            }
        }
        else if ([name isEqualToString:@"智能插座"]) {
            if ([switchStatus isEqualToString:@"01"]) {
                return @"bj";
            } else if ([switchStatus isEqualToString:@"00"]) {
                return @"aq";
            } else {
                return @"no";
            }
        }
        else if ([name isEqualToString:@"双路开关"]) {
            if ([switchStatus isEqualToString:@"00"]) {
                return @"aq";
            } else if ([switchStatus isEqualToString:@"01"] || [switchStatus isEqualToString:@"02"] || [switchStatus isEqualToString:@"03"]) {
                return @"bj";
            } else {
                return @"no";
            }
        }
        else if ([name containsString:@"温湿"]) {
            if ([[BatterHelp numberHexString:switchStatus] intValue] > 100) {
                return @"no";
            } else {
                if ([[BatterHelp getBatterFormDevice:battery] intValue] <= 15) {
                    return @"gz";
                } else {
                    return @"aq";
                }
            }
        }
        else if ([name containsString:@"调光"]) {
            if ([[BatterHelp numberHexString:switchStatus] intValue] > 100 || [[BatterHelp numberHexString:switchStatus] intValue] < 0) {
                return @"no";
            } else {
                if ([[BatterHelp getBatterFormDevice:battery] intValue] <= 15) {
                    return @"gz";
                } else {
                    return @"aq";
                }
            }
        }

        else if ([status isEqualToString:STATE_DOOR_NOT_CLOSED]||
                [status isEqualToString:STATE_MUTE]||

                [status isEqualToString:@"17"]||
                [status isEqualToString:@"18"]||
                [status isEqualToString:@"19"]||
                [status isEqualToString:@"1A"]||
                [status isEqualToString:@"1B"]||
                [status isEqualToString:STATE_TEST]||
                 
                [status isEqualToString:@"10"]||
                [status isEqualToString:@"20"]||
                [status isEqualToString:@"30"]||
                 [status isEqualToString:@"51"]||
                 [status isEqualToString:@"52"]||
                 [status isEqualToString:@"53"]  ){
            return @"bj";
        }
        else if ([status isEqualToString:STATE_TRIGGERED] || [status isEqualToString:@"56"]) {
            if ([name isEqualToString:@"门锁"]) {
                return @"aq";
            } else {
                return @"bj";
            }
        }
        
        else if (([status isEqualToString:@"11"]||
                 [status isEqualToString:@"12"]||
                 [status isEqualToString:@"13"]||
                 [status isEqualToString:@"14"]||
                 [status isEqualToString:@"15"]||
                 [status isEqualToString:@"16"]) && ([name isEqualToString:@"复合型烟感"]) ) {
            return @"gz";
        }
        
        else if ([status isEqualToString:STATE_NORMAL] || [status isEqualToString:@"01"] || [status isEqualToString:@"02"] || [status isEqualToString:@"04"] || [status isEqualToString:@"08"] || [status isEqualToString:@"60"] || [status isEqualToString:@"AB"]){
            //电量
            if (![battery isEqualToString:@"80"] && ![battery isEqualToString:@"64"]) {
                battery = [BatterHelp getBatterFormDevice:battery];
                if ([battery intValue] <= 15) {
                    return @"gz";
                } else {
                    return @"aq";
                }
            }
            
            return @"aq";
        }
        else if ([status isEqualToString:@"40"]) {
            return @"gz";
        }
        else {
            return @"no";
        }
    }
    return @"no";
}


@end
