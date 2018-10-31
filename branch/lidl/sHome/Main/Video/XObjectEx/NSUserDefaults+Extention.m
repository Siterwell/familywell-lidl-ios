#import "NSUserDefaults+Extention.h"

@implementation NSUserDefaults (Extention)
+(NSString *)getStrValue:(NSString *)key{
    return [NSUserDefaults getStrValue:key Default:@""];
}
+(NSString *)getStrValue:(NSString *)key Default:(NSString *)defValue{
    NSString *ret = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return ret == nil ? defValue : ret;
}

+(int)getIntValue:(NSString *)key{
    return [NSUserDefaults getIntValue:key Default:0];
}

+(int)getIntValue:(NSString *)key Default:(int)defValue{
    NSString *ret = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return ret == nil ? defValue : (int)[ret integerValue];
}

+(id)getObjectValue:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)setValue:(NSString *)key Value:(nullable id)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

+(void)setIntValue:(NSString *)key Value:(int)value{
    NSString *str = [NSString stringWithFormat:@"%d", value];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:key];
}
@end
