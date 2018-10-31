//
//  CYAlertView.h
//  SiterLink
//
//  Created by CY on 2017/6/15.
//  Copyright © 2017年 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ramdomcode @"97844269618858723534"
@interface CYAlertView : UIView

@property (nonatomic) UITextField *captchaTF;

@property (nonatomic, copy) void(^clickCancelButton)();

@property (nonatomic, copy) void(^clickDetermineButton)();

//初始化方法
- (instancetype)initWithTarget:(id)target Title:(NSString *)title Content:(NSString *)content CancelButtonTitle:(NSString *)cancelTitle DetermineButtonTitle:(NSString *)determineTitle toView:(UIView *)view;

//弹出窗口
- (void)cy_alertShow;

- (void)cy_clickCancelButton:(void (^)())cancel determineButton:(void (^)())determine;

@end
