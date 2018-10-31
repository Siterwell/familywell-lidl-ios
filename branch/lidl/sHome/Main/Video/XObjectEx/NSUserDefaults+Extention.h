//
//  NSUserDefaults+Extention.h
//  FunSDKDemo
//
//  Created by ZYJ on 2/21/17.
//  Copyright (c) 2015 XM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum EUD_KEY{
    UD_KEY_USER_NAME,
    UD_KEY_USER_PWD,
    UD_KEY_USER_TYPE,
    UD_KEY_CHANNEL_NAMES,
    UD_KEY_LAST_CHANNEL_NUM,
    UD_KEY_LAST_DEVICE,
}EUD_KEY;
#define TOUD(key) [NSString stringWithFormat:@"UD_KEY_%d", key]
@interface NSUserDefaults (Extention)
+(NSString *)getStrValue:(NSString *)key;
+(NSString *)getStrValue:(NSString *)key Default:(NSString *)defValue;
+(int)getIntValue:(NSString *)key;
+(int)getIntValue:(NSString *)key Default:(int)defValue;
+(id)getObjectValue:(NSString *)key;

+(void)setValue:(NSString *)key Value:(nullable id)value;
+(void)setIntValue:(NSString *)key Value:(int)value;
@end




