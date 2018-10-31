//
//  GetAlarmsApi.m
//  sHome
//
//  Created by shaop on 2017/4/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "GetAlarmsApi.h"

@implementation GetAlarmsApi
{
    NSString *_token;
    NSString *_key;
    NSString *_devTid;
    
}
-(id)initWithDevTid:(NSString *)devTid Authorization:(NSString *)token ProdPubKey:(NSString *)key{
    if (self = [super init]) {
        _token = token;
        _key = key;
        _devTid = devTid;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"user/warnings";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

-(SERVERCENTER_TYPE)centerType
{
    return WEATHER_SERVERCENTER;
}

- (NSDictionary *)requestHeaderFieldValueDictionary
{
    NSDictionary *headerDictionary=@{@"platform":@"ios",
                                     @"Accept":@"application/json",
                                     @"Content-Type":@"application/json",
                                     @"Authorization" :[NSString stringWithFormat:@"Bearer %@",_token],
                                     @"X-Hekr-ProdPubKey":_key
                                     };
    return headerDictionary;
}

- (id)requestArgument {
    NSTimeInterval secondsPerDay = 7 * 24 * 60 * 60;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:10];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString *dateTime = [formatter stringFromDate:date];

    return @{
             @"devTid":_devTid,
             @"startTime":dateTime,
             @"size":@80
             };
}
@end
