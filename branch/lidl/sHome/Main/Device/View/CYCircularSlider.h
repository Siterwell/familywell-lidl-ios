//
//  CYCircularSlider.h
//  Familywell
//
//  Created by TracyHenry on 2018/11/8.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol senderValueChangeDelegate <NSObject>

-(void)senderVlueWithNum:(float)num;
-(void)senderMoveWithFloat:(float)num;

@end

@interface CYCircularSlider : UIControl

/**
 实现按钮颜色
 */
@property (nonatomic, strong) UIColor* filledColor;

/**
 空心按钮颜色
 */
@property (nonatomic, strong) UIColor* unfilledColor;


/**
 最小值
 */
@property (nonatomic) float minimumValue;
//
/**
 最大值
 */
@property (nonatomic) float maximumValue;
//当前值
@property (nonatomic) float currentValue;

/**
 圈边宽度
 */
@property (nonatomic) int lineWidth;


@property (nonatomic, strong) UIColor* handleColor;
@property (nonatomic, strong) UIColor* handleColor2;

@property (nonatomic,weak) id<senderValueChangeDelegate> delegate;


-(void)setAngel:(int)num;

-(void)setAddAngel;

-(void)setMovAngel;


@end
