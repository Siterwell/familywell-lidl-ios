//
//  AirModel.h
//  sHome
//
//  Created by shaop on 2016/12/27.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Air ;
@class AirNow ,cityAir;

@interface AirModel : JSONModel
@property (nonatomic , strong) NSArray<Air> *results;

@end


@interface Air : JSONModel
@property (nonatomic , strong) AirNow *air;
@end

@interface AirNow : JSONModel
@property (nonatomic , strong) cityAir *city;

@end

@interface cityAir : JSONModel
@property (nonatomic , strong) NSString *aqi;
@end
