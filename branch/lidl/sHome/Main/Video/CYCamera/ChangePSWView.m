//
//  ChangePSWView.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/23.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "ChangePSWView.h"
#import "Helper.h"
#import "GUI.h"

@implementation ChangePSWView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.OldTXF.frame = CGRectMake(0, 0, SCREEN_WIDTH - 5, 44);
        self.OldTXF.center = CGPointMake(SCREEN_WIDTH/2, 60);
        
        self.NewTXF.frame = CGRectMake(0, 0, SCREEN_WIDTH - 5, 44);
        self.NewTXF.center = CGPointMake(SCREEN_WIDTH/2, 115);
        
        self.ConfirmTXF.frame = CGRectMake(0, 0, SCREEN_WIDTH - 5, 44);
        self.ConfirmTXF.center = CGPointMake(SCREEN_WIDTH/2, 170);
        
        self.ConfirmBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 44);
        self.ConfirmBtn.center = CGPointMake(SCREEN_WIDTH/2, 250);
        [self.ConfirmBtn setBackgroundColor:ThemeColor];
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(45, self.OldTXF.frame.size.height-8, self.OldTXF.frame.size.width-45-15, 0.8)];
        line1.backgroundColor = RGB(200, 200, 200);
        [_OldTXF addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(45, self.NewTXF.frame.size.height-8, self.NewTXF.frame.size.width-45-15, 0.8)];
        line2.backgroundColor = RGB(200, 200, 200);
        [_NewTXF addSubview:line2];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(45, self.ConfirmTXF.frame.size.height-8, self.ConfirmTXF.frame.size.width-45-15, 0.8)];
        line3.backgroundColor = RGB(200, 200, 200);
        [_ConfirmTXF addSubview:line3];
        
        [self addSubview:self.OldTXF];
        [self addSubview:self.NewTXF];
        [self addSubview:self.ConfirmTXF];
        [self addSubview:self.ConfirmBtn];
    }
    return self;
}

#pragma mark lazyLoad
-(UITextField *)OldTXF{
    if (!_OldTXF) {
        _OldTXF = [[UITextField alloc]init];
        _OldTXF.borderStyle = UITextBorderStyleNone;
        _OldTXF.layer.borderColor = [UIColor blackColor].CGColor;
        _OldTXF.font = [UIFont systemFontOfSize:14];
        _OldTXF.secureTextEntry = YES;
        _OldTXF.placeholder = NSLocalizedString(@"旧密码", nil);
        _OldTXF.leftViewMode = UITextFieldViewModeAlways;
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        [left setImage:[UIImage imageNamed:@"04-密码图标"] forState:UIControlStateNormal];
        [left setFrame:CGRectMake(0, 0, 45, 45)];
        [left setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        _OldTXF.leftView = left;
    }
    return _OldTXF;
}

-(UITextField *)NewTXF{
    if (!_NewTXF) {
        _NewTXF = [[UITextField alloc]init];
        _NewTXF.borderStyle = UITextBorderStyleNone;
        _NewTXF.layer.borderColor = [UIColor blackColor].CGColor;
        _NewTXF.font = [UIFont systemFontOfSize:14];
        _NewTXF.secureTextEntry = YES;
        _NewTXF.placeholder = NSLocalizedString(@"新密码", nil);
        _NewTXF.leftViewMode = UITextFieldViewModeAlways;
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        [left setImage:[UIImage imageNamed:@"04-密码图标"] forState:UIControlStateNormal];
        [left setFrame:CGRectMake(0, 0, 45, 45)];
        [left setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        _NewTXF.leftView = left;
    }
    return _NewTXF;
}

-(UITextField *)ConfirmTXF{
    if (!_ConfirmTXF) {
        _ConfirmTXF = [[UITextField alloc]init];
        _ConfirmTXF.borderStyle = UITextBorderStyleNone;
        _ConfirmTXF.layer.borderColor = [UIColor blackColor].CGColor;
        _ConfirmTXF.font = [UIFont systemFontOfSize:14];
        _ConfirmTXF.secureTextEntry = YES;
        _ConfirmTXF.placeholder = NSLocalizedString(@"请再次输入密码", nil);
        _ConfirmTXF.leftViewMode = UITextFieldViewModeAlways;
        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
        [left setImage:[UIImage imageNamed:@"07-新密码"] forState:UIControlStateNormal];
        [left setFrame:CGRectMake(0, 0, 45, 45)];
        [left setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        _ConfirmTXF.leftView = left;
    }
    return _ConfirmTXF;
}

-(UIButton *)ConfirmBtn{
    if (!_ConfirmBtn) {
        _ConfirmBtn = [[UIButton alloc]init];
        [_ConfirmBtn setTitle:NSLocalizedString(@"确认更改", nil) forState:UIControlStateNormal];
        [_ConfirmBtn setBackgroundColor:RGB(75, 173, 241)];
        _ConfirmBtn.layer.cornerRadius = 22;
    }
    return _ConfirmBtn;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
