//
//  HWSwitch.m
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "HWSwitch.h"

@interface HWSwitch ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *onContentView;
@property (nonatomic, strong) UIView *offContentView;
@property (nonatomic, strong) UIColor *onColor;
@property (nonatomic, strong) UIColor *offColor;
@property (nonatomic, strong) UIColor *offPointColor;
@property (nonatomic, strong) UIColor *onPointColor;
@property (nonatomic, strong) UIColor *ballColor;
@property (nonatomic, assign) NSInteger ballSize;
@property (nonatomic, strong) UIView *ballView;
@property (nonatomic, strong) UIView *onPointView;
@property (nonatomic, strong) UIView *offPointView;

@end

@implementation HWSwitch


- (id)initWithFrame:(CGRect)frame onColor:(UIColor *)onColor onPointColor:(UIColor *)onPointColor offColor:(UIColor *)offColor  offPointColor:(UIColor *)offPointColor  ballColor:(UIColor *)ballColor  ballSize:(NSInteger )ballSize
{
    self = [super initWithFrame:[self roundRect:frame]];
    if (self) {
        self.ballColor = ballColor;
        self.onColor = onColor;
        self.onPointColor = onPointColor;
        self.offColor = offColor;
        self.offPointColor = offPointColor;
        self.ballSize = ballSize;
        [self initView];
    }
    return self;
}

- (CGRect)roundRect:(CGRect)frameOrBounds
{
    CGRect newRect = frameOrBounds;
    
    return newRect;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:_containerView];
    
    _onContentView = [[UIView alloc] initWithFrame:self.bounds];
    _onContentView.backgroundColor = self.onColor;
    [_containerView addSubview:_onContentView];
    
    _offContentView = [[UIView alloc] initWithFrame:self.bounds];
    _offContentView.backgroundColor = self.offColor;
    [_containerView addSubview:_offContentView];
    
    _ballView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetHeight(_offContentView.frame) - self.ballSize)/2, (CGRectGetHeight(_offContentView.frame) - self.ballSize)/2, self.ballSize, self.ballSize)];
    _ballView.backgroundColor = self.ballColor;
    _ballView.layer.cornerRadius = self.ballSize / 2.0;
    [_containerView addSubview:_ballView];
    
    _onPointView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(_offContentView.frame)/2 - 5/2, 5, 5)];
    _onPointView.backgroundColor = self.onPointColor;
    
    [_onContentView addSubview:_onPointView];
    
    _offPointView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_offContentView.frame) - 10, CGRectGetHeight(_offContentView.frame)/2 - 5/2, 5, 5)];
    _offPointView.backgroundColor = self.offPointColor;
    _ballView.layer.cornerRadius = 5 / 2.0;
    [_offContentView addSubview:_offPointView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTapTapGestureRecognizerEvent:)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePanGestureRecognizerEvent:)];
    [self addGestureRecognizer:panGesture];
    
    CGFloat r = CGRectGetHeight(self.containerView.bounds) / 2.0;
    
    self.containerView.layer.cornerRadius = r;
    self.containerView.layer.masksToBounds = YES;
    
    _onPointView.layer.cornerRadius = 5 / 2.0;
    _onPointView.layer.masksToBounds = YES;
    _offPointView.layer.cornerRadius = 5 / 2.0;
    _offPointView.layer.masksToBounds = YES;
    
    _ballView.layer.cornerRadius = self.ballSize / 2.0;
    _ballView.layer.masksToBounds = YES;
}

#pragma mark 点击
- (void)handleTapTapGestureRecognizerEvent:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self setOn:!self.isOn animated:NO];
    }
}

#pragma mark 滑动
- (void)handlePanGestureRecognizerEvent:(UIPanGestureRecognizer *)recognizer
{
    CGFloat margin = (CGRectGetHeight(self.bounds) - self.ballSize) / 2.0;
    CGFloat offset = 6.0f;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            if (!self.isOn) {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     self.ballView.frame = CGRectMake(margin,
                                                                      margin,
                                                                      self.ballSize + offset,
                                                                      self.ballSize);
                                 }];
            } else {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     self.ballView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - margin - (self.ballSize + offset),
                                                                      margin,
                                                                      self.ballSize + offset,
                                                                      self.ballSize);
                                 }];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if (!self.isOn) {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     self.ballView.frame = CGRectMake(margin,
                                                                      margin,
                                                                      self.ballSize,
                                                                      self.ballSize);
                                 }];
            } else {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     self.ballView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - self.ballSize,
                                                                      margin,
                                                                      self.ballSize,
                                                                      self.ballSize);
                                 }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self setOn:!self.isOn animated:YES];
            break;
        case UIGestureRecognizerStatePossible:
            break;
    }
}

- (void)setOn:(BOOL)on
{
    [self setOn:on animated:NO];
}

#pragma mark 关闭动画控制
- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (_on == on) {
        return;
    }
    
    _on = on;
    
    CGFloat margin = (CGRectGetHeight(self.bounds) - self.ballSize) / 2.0;
    
    if (!animated) {
        if (!self.isOn) {
            // frame of off status
            self.onContentView.frame = CGRectMake(-1 * CGRectGetWidth(self.containerView.bounds),
                                                  0,
                                                  CGRectGetWidth(self.containerView.bounds),
                                                  CGRectGetHeight(self.containerView.bounds));
            
            self.offContentView.frame = CGRectMake(0,
                                                   0,
                                                   CGRectGetWidth(self.containerView.bounds),
                                                   CGRectGetHeight(self.containerView.bounds));
            
            self.ballView.frame = CGRectMake(margin,
                                             margin,
                                             self.ballSize,
                                             self.ballSize);
        } else {
            // frame of on status
            self.onContentView.frame = CGRectMake(0,
                                                  0,
                                                  CGRectGetWidth(self.containerView.bounds),
                                                  CGRectGetHeight(self.containerView.bounds));
            
            self.offContentView.frame = CGRectMake(0,
                                                   CGRectGetWidth(self.containerView.bounds),
                                                   CGRectGetWidth(self.containerView.bounds),
                                                   CGRectGetHeight(self.containerView.bounds));
            
            self.ballView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - margin - self.ballSize,
                                             margin,
                                             self.ballSize,
                                             self.ballSize);
        }
    } else {
        if (self.isOn) {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.ballView.frame = CGRectMake(CGRectGetWidth(self.containerView.bounds) - margin - self.ballSize,
                                                                  margin,
                                                                  self.ballSize,
                                                                  self.ballSize);
                             }
                             completion:^(BOOL finished){
                                 self.onContentView.frame = CGRectMake(0,
                                                                       0,
                                                                       CGRectGetWidth(self.containerView.bounds),
                                                                       CGRectGetHeight(self.containerView.bounds));
                                 
                                 self.offContentView.frame = CGRectMake(0,
                                                                        CGRectGetWidth(self.containerView.bounds),
                                                                        CGRectGetWidth(self.containerView.bounds),
                                                                        CGRectGetHeight(self.containerView.bounds));
                             }];
        } else {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.ballView.frame = CGRectMake(margin,
                                                                  margin,
                                                                  self.ballSize,
                                                                  self.ballSize);
                             }
                             completion:^(BOOL finished){
                                 self.onContentView.frame = CGRectMake(-1 * CGRectGetWidth(self.containerView.bounds),
                                                                       0,
                                                                       CGRectGetWidth(self.containerView.bounds),
                                                                       CGRectGetHeight(self.containerView.bounds));
                                 
                                 self.offContentView.frame = CGRectMake(0,
                                                                        0,
                                                                        CGRectGetWidth(self.containerView.bounds),
                                                                        CGRectGetHeight(self.containerView.bounds));
                             }];
        }
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
