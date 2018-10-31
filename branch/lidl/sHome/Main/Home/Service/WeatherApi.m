//
//  WeatherApi.m
//  sHome
//
//  Created by shaop on 2016/12/27.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "WeatherApi.h"

@implementation WeatherApi
{
    NSString *_location;
    NSString *_token;
    NSString *_key;
    NSString *_lan;

}
-(id)initWithLocation:(NSString *)location Authorization:(NSString *)token ProdPubKey:(NSString *)key{
    if (self = [super init]) {
        _location = location;
        _token = token;
        _key = key;
            NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *languageName = [appLanguages objectAtIndex:0];
            if ([languageName containsString:@"zh"]) {
                _lan = @"zh";
            } else if ([languageName containsString:@"de"]) {
                _lan = @"de";
            } else if ([languageName containsString:@"fr"]) {
                _lan = @"fr";
            }else if ([languageName containsString:@"es"]) {
                _lan = @"es";
            } else {
                _lan = @"en";
            }
        }
    return self;
}

- (NSString *)requestUrl {
    return @"weather/now";
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
    return @{
             @"location":_location,
             @"language":_lan,
             @"unit":@"c"
             };
}
@end
