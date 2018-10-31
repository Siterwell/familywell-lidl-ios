//
//  WeatherModel.h
//  sHome
//
//  Created by shaop on 2016/12/27.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Weather ;
@class WeatherNow ;

@interface WeatherModel : JSONModel
@property (nonatomic , strong) NSArray<Weather> *results;
@end

@interface Weather : JSONModel
@property (nonatomic , strong) WeatherNow *now;
@end

@interface WeatherNow : JSONModel
@property (nonatomic , strong) NSString *text;
@property (nonatomic , strong) NSString *temperature;
@end
