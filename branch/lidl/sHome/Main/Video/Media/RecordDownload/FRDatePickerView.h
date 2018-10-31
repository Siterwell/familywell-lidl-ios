//
//  FRDatePickerView.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/22.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnDateBlock)(NSDate *date);

@interface FRDatePickerView : UIView
@property (nonatomic, strong) UIDatePicker *datePicker;//时间选择器

@property (nonatomic, assign) BOOL showView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, copy) ReturnDateBlock returnDateBlock;

-(void)showFRDatePickerView;
-(void)dismiss;
-(void)returnDateWithBlock:(ReturnDateBlock)block;
@end
