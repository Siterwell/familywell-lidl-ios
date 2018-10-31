//
//  HWSwitch.h
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWSwitch : UIControl

@property (nonatomic, assign, getter = isOn) BOOL on;

- (id)initWithFrame:(CGRect)frame onColor:(UIColor *)onColor onPointColor:(UIColor *)onPointColor offColor:(UIColor *)offColor  offPointColor:(UIColor *)offPointColor  ballColor:(UIColor *)ballColor  ballSize:(NSInteger )ballSize;

@end
