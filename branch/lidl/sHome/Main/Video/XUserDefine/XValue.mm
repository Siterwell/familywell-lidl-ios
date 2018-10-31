//
//  XValue.m
//  未来家庭
//
//  Created by zyj on 16/1/23.
//  Copyright © 2016年 zyj. All rights reserved.
//

#import "XValue.h"

@implementation XValue
+(NSMutableDictionary *) ToDictionary:(const char *)value{
    if (value == NULL) {
        return nil;
    }
    NSData *data = [NSData dataWithBytes:value length:strlen(value)];
    if (data == nil) {
        return nil;
    }

    NSError *error;
    NSMutableDictionary *dic = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return dic;
}

+(int) GetIntValue:(NSDictionary *)table Key:(NSString *)key{
    return [XValue GetIntValue:table Key:key DefValue:0];
}

+(int) GetIntValue:(NSDictionary *)table Key:(NSString *)key DefValue:(int)value{
    if (table == nil) {
        return value;
    }
    if ([[table objectForKey:key] isEqual:[NSNull null]]) {
        return value;
    }
    return [[table objectForKey:key] intValue];
}

+(int) GetIntValue2:(NSDictionary *)table Node:(NSString *)node Key:(NSString *)key DefValue:(int)value{
    return [XValue GetIntValue:[XValue GetObjValue:table Key:node] Key:key DefValue:value];
}

+(int) GetIntValue2:(NSDictionary *)table Node:(NSString *)node Key:(NSString *)key{
    return [XValue GetIntValue2:table Node:node Key:key DefValue:0];
}

+(NSString *) GetStrValue:(NSDictionary *)table Key:(NSString *)key{
    return [XValue GetStrValue:table Key:key DefValue:@""];
}

+(NSString *) GetStrValue:(NSDictionary *)table Key:(NSString *)key DefValue:(NSString *)value{
    if (table == nil) {
        return value;
    }
    if ([[table objectForKey:key] isEqual:[NSNull null]]) {
        return value;
    }
    return [table objectForKey:key];
}

+(NSString *) GetStrValue2:(NSDictionary *)table Node:(NSString *)node Key:(NSString *)key{
    return [XValue GetStrValue2:table Node:node Key:key DefValue:@""];
}

+(NSString *) GetStrValue2:(NSDictionary *)table Node:(NSString *)node Key:(NSString *)key DefValue:(NSString *)value{
    return [XValue GetStrValue:[XValue GetObjValue:table Key:node] Key:key DefValue:value];
}

+(id) GetObjValue:(NSDictionary *)table Key:(NSString *)key{
    if (table == nil) {
        return nil;
    }
    if ([[table objectForKey:key] isEqual:[NSNull null]]) {
        return nil;
    }
    return [table objectForKey:key];
}
@end
