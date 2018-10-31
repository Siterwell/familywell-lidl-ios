//
//  CYNetManager.h
//  sHome
//
//  Created by CY on 2017/11/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "CYBaseNetManager.h"
#import "NewWeatherModel.h"

@interface CYNetManager : CYBaseNetManager
//http://api.openweathermap.org/data/2.5/weather?lat=39&lon=116&appid=b45eb4739891c226b7a36613ce3d1dbd
//http://maps.google.cn/maps/api/geocode/json?latlng="+lat+","+lon+"&sensor=true&language=
+ (id)getWeatherWithParams:(NSDictionary *)params handler:(void (^)(NewWeatherModel *model, NSError *error))handler;

+ (id)getLocationWithParams:(NSDictionary *)params handler:(void (^)(NSString *address, NSString *errorStr))handler;

@end
