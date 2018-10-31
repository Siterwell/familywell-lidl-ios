//
//  FRDatePickerView.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/22.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "FRDatePickerView.h"
#import "Helper.h"
#import "GUI.h"

@implementation FRDatePickerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        self.frame = [UIScreen mainScreen].bounds;
        
        UIView *toolbar = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 44)];
        [self addSubview:toolbar];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        [cancelBtn setTitle:TS("Cancel") forState:UIControlStateNormal];
        BUTTON_TARGET(cancelBtn, cancel);
        [toolbar addSubview:cancelBtn];
        
        UIButton *okBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 44)];
        [okBtn setTitle:TS("OK") forState:UIControlStateNormal];
        BUTTON_TARGET(okBtn, ok);
        [toolbar addSubview:okBtn];
        
        self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2 + 44, SCREEN_WIDTH, SCREEN_HEIGHT/2 - 44)];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.datePickerMode = UIDatePickerModeDate;//日期模式显示
        [self addSubview:self.datePicker];
    }
    return self;
}

//取消按钮
-(void)cancel:(UIButton *)btn{
    [self removeFromSuperview];
}

//确定按钮
-(void)ok:(UIButton *)btn{
    if (self.returnDateBlock != nil) {
        self.returnDateBlock(self.datePicker.date);
    }
    [self dismiss];
}

-(void)returnDateWithBlock:(ReturnDateBlock)block{
    self.returnDateBlock = block;
}

-(void)showFRDatePickerView{
    UIWindow *window = [UIApplication  sharedApplication].keyWindow;
    if (self.showView == NO) {
        self.showView = YES;
        [window addSubview:self];
        self.alpha = 0.9;
        [window makeKeyAndVisible];
    }
    
    if (self.alpha != 1) {
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:nil];
        
    }
    
}

-(void)dismiss{
    [self removeFromSuperview];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.alpha = 0;
    } completion:nil];
}


@end
