//
//  CustomView.h
//  ScirCleView
//
//  Created by shaop on 16/9/7.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView

-(void)startAnimotionWithSouce:(NSInteger)Souce WithDuration:(int)time;
-(void)addCircleLayer;

@property(nonatomic) UILabel *souceLabel;

@end
