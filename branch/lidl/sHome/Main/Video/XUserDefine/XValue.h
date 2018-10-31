//
//  XValue.h
//  未来家庭
//
//  Created by zyj on 16/1/23.
//  Copyright © 2016年 zyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XValue : NSObject
+(NSMutableDictionary *) ToDictionary:(const char *)value;
+(int) GetIntValue:(NSDictionary *)table Key:(NSString *)key;
+(int) GetIntValue:(NSDictionary *)table Key:(NSString *)key DefValue:(int)value;
+(NSString *) GetStrValue:(NSDictionary *)table Key:(NSString *)key;
+(NSString *) GetStrValue:(NSDictionary *)table Key:(NSString *)key DefValue:(NSString *)value;
+(id) GetObjValue:(NSDictionary *)table Key:(NSString *)key;

+(int) GetIntValue2:(NSDictionary *)table Node:(NSString *)node Key:(NSString *)key;
+(int) GetIntValue2:(NSDictionary *)table Node:(NSString *)node Key:(NSString *)key DefValue:(int)value;

+(NSString *) GetStrValue2:(NSDictionary *)table Node:(NSString *)node Key:(NSString *)key;
+(NSString *) GetStrValue2:(NSDictionary *)table Node:(NSString *)node Key:(NSString *)key DefValue:(NSString *)value;
@end
