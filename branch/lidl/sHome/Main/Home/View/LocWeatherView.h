//
//  LocWeatherView.h
//  sHome
//
//  Created by CY on 2018/3/26.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewWeatherModel.h"

@interface LocWeatherView : UIView

@property (nonatomic) NewWeatherModel *model;

@property (nonatomic) NSString *address;

- (instancetype)initWithFrame:(CGRect)frame;

@end
