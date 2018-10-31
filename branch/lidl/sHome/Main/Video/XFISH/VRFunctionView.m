//
//  VRFunctionView.m
//  XMEye
//
//  Created by riceFun on 16/12/1.
//  Copyright © 2016年 Megatron. All rights reserved.
//

#import "VRFunctionView.h"
#import "Helper.h"
#define buttonHeight frame.size.height/2

@implementation VRFunctionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        //设置每个控件的位置
        //最左侧的关闭开关
        self.closeMode.frame = CGRectMake(0, 0,buttonHeight,buttonHeight);
        self.closeMode.center = CGPointMake(buttonHeight*1.5/2, frame.size.height/2);
        
#pragma mark 360VR
        //顶上两个
        self.war.frame = CGRectMake(buttonHeight*1.5, 0, buttonHeight, buttonHeight);
        self.ceiling.frame = CGRectMake(buttonHeight*1.5 + buttonHeight, 0, buttonHeight, buttonHeight);
        //下面两个通用的
        self.Ball.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 0, buttonHeight, buttonHeight, buttonHeight);
        self.Rectangle.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 1, buttonHeight, buttonHeight, buttonHeight);
        //吸顶模式独有的5个
        self.BallBowl.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 2, buttonHeight, buttonHeight, buttonHeight);
        self.BallHat.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 3, buttonHeight, buttonHeight, buttonHeight);
        self.Cylinder.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 4, buttonHeight, buttonHeight, buttonHeight);
        self.Split.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 5, buttonHeight, buttonHeight, buttonHeight);
        self.dichotomia.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 6, buttonHeight, buttonHeight, buttonHeight);
        
#pragma mark 180VR
        self.curve_180.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 0, buttonHeight/2, buttonHeight, buttonHeight);
        self.rectangle_180.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 1, buttonHeight/2, buttonHeight, buttonHeight);
        self.cylindrical_180.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 2, buttonHeight/2, buttonHeight, buttonHeight);
        self.split_180.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 3, buttonHeight/2, buttonHeight, buttonHeight);
        self.three_180.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 4, buttonHeight/2, buttonHeight, buttonHeight);


        
        self.menuView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:self.menuView];
        [self.menuView addSubview:self.closeMode];

//        if (_VRType == XMVR_TYPE_360D) {//根据不同的模式添加不同的功能按钮
            [self.menuView addSubview:self.war];
            [self.menuView addSubview:self.ceiling];
            
            [self.menuView addSubview:self.Ball];
            [self.menuView addSubview:self.Rectangle];
            
            [self.menuView addSubview:self.BallBowl];
            [self.menuView addSubview:self.BallHat];
            [self.menuView addSubview:self.Cylinder];
            [self.menuView addSubview:self.Split];
            [self.menuView addSubview:self.dichotomia];
//        }else if (_VRType == XMVR_TYPE_180D){
            [self.menuView addSubview:self.curve_180];
            [self.menuView addSubview:self.rectangle_180];
            [self.menuView addSubview:self.cylindrical_180];
            [self.menuView addSubview:self.split_180];
            [self.menuView addSubview:self.three_180];
//        }
        
        
    }
    return self;
}

#pragma mark lazyLoad
-(UIView *)menuView
{
    if (!_menuView) {
        _menuView = [[UIView alloc]init];
        _menuView.backgroundColor = [UIColor redColor];
        _menuView.alpha = 0.6;
        _menuView.hidden = YES;
    }
    return _menuView;
}
-(UIView *)modeView
{
    if (!_modeView) {
        _modeView = [[UIView alloc]init];
        _modeView.backgroundColor = [UIColor blueColor];
        _modeView.alpha = 0.6;
        _modeView.layer.cornerRadius = 15;
    }
    return _modeView;
}
#pragma mark - modeView的按钮
-(UIButton *)closeMode
{
    if (!_closeMode) {
        _closeMode = [[UIButton alloc]init];
//        [_closeMode setImage:[UIImage imageNamed:@"360VR-ins_default"] forState:UIControlStateNormal];
//        [_closeMode setImage:[UIImage imageNamed:@"VR-close_nor"] forState:UIControlStateSelected];
        [_closeMode setImage:[UIImage imageNamed:@"VR-close_nor"] forState:UIControlStateNormal];
        [_closeMode setImage:[UIImage imageNamed:@"VR-close_nor"] forState:UIControlStateSelected];
        [_closeMode addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeMode;
}
#pragma mark - menuView的按钮
-(UIButton *)ceiling
{
    if (!_ceiling) {
        _ceiling = [[UIButton alloc]init];
        [_ceiling setImage:[UIImage imageNamed:@"VR-Ceiling_nor"] forState:UIControlStateNormal];
        [_ceiling setImage:[UIImage imageNamed:@"VR-Ceiling_sel"] forState:UIControlStateSelected];
        [_ceiling addTarget:self action:@selector(chooseCeilingFunction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ceiling;
}
-(UIButton *)war
{
    if (!_war) {
        _war = [[UIButton alloc]init];
        [_war setImage:[UIImage imageNamed:@"VR_Wall_nor"] forState:UIControlStateNormal];
        [_war setImage:[UIImage imageNamed:@"VR_Wall_sel"] forState:UIControlStateSelected];
        [_war addTarget:self action:@selector(chooseWarFunction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _war;
}
-(UIButton *)Cylinder
{
    if (!_Cylinder) {
        _Cylinder = [[UIButton alloc]init];
        [_Cylinder setImage:[UIImage imageNamed:@"VR-cylinder_nor"] forState:UIControlStateNormal];
        [_Cylinder setImage:[UIImage imageNamed:@"VR-cylinder_sel"] forState:UIControlStateSelected];
    }
    return _Cylinder;
}
-(UIButton *)Ball
{
    if (!_Ball) {
        _Ball = [[UIButton alloc]init];
        [_Ball setImage:[UIImage imageNamed:@"VR_Ball_nor"] forState:UIControlStateNormal];
        [_Ball setImage:[UIImage imageNamed:@"VR_Ball_sel"] forState:UIControlStateSelected];
    }
    return _Ball;
}
-(UIButton *)BallBowl
{
    if (!_BallBowl) {
        _BallBowl = [[UIButton alloc]init];
        [_BallBowl setImage:[UIImage imageNamed:@"VR-ball bowl_nor"] forState:UIControlStateNormal];
        [_BallBowl setImage:[UIImage imageNamed:@"VR-ball bowl_sel"] forState:UIControlStateSelected];
    }
    return _BallBowl;
}
-(UIButton *)BallHat
{
    if (!_BallHat) {
        _BallHat = [[UIButton alloc]init];
        [_BallHat setImage:[UIImage imageNamed:@"VR_ball hat_nor"] forState:UIControlStateNormal];
        [_BallHat setImage:[UIImage imageNamed:@"VR_ball hat_sel"] forState:UIControlStateSelected];
    }
    return _BallHat;
}
-(UIButton *)Rectangle
{
    if (!_Rectangle) {
        _Rectangle = [[UIButton alloc]init];
        [_Rectangle setImage:[UIImage imageNamed:@"VR-rectangle_nor"] forState:UIControlStateNormal];
        [_Rectangle setImage:[UIImage imageNamed:@"VR-rectangle_sel"] forState:UIControlStateSelected];
    }
    return _Rectangle;
}
-(UIButton *)Split
{
    if (!_Split) {
        _Split = [[UIButton alloc]init];
        [_Split setImage:[UIImage imageNamed:@"VR-four_nor"] forState:UIControlStateNormal];
        [_Split setImage:[UIImage imageNamed:@"VR-four_sel"] forState:UIControlStateSelected];    }
    return _Split;
}
-(UIButton *)dichotomia
{
    if (!_dichotomia) {
        _dichotomia = [[UIButton alloc]init];
        [_dichotomia setImage:[UIImage imageNamed:@"VR-tow_nor.png"] forState:UIControlStateNormal];
        [_dichotomia setImage:[UIImage imageNamed:@"VR-tow_sel.png"] forState:UIControlStateSelected];
    }
    return _dichotomia;
}

#pragma mark 180
-(UIButton *)curve_180{
    if (!_curve_180) {
        _curve_180 = [[UIButton alloc]init];
        [_curve_180 setImage:[UIImage imageNamed:@"VR_180_nor.png"] forState:UIControlStateNormal];
        [_curve_180 setImage:[UIImage imageNamed:@"VR_180_sel.png"] forState:UIControlStateSelected];
        BUTTON_TARGET(_curve_180, click_curve_180);
    }
    return _curve_180;
}

-(UIButton *)rectangle_180{
    if (!_rectangle_180) {
        _rectangle_180 = [[UIButton alloc]init];
        [_rectangle_180 setImage:[UIImage imageNamed:@"VR-rectangle_nor.png"] forState:UIControlStateNormal];
        [_rectangle_180 setImage:[UIImage imageNamed:@"VR-rectangle_sel.png"] forState:UIControlStateSelected];
        BUTTON_TARGET(_rectangle_180, click_rectangle_180);
    }
    return _rectangle_180;
}

-(UIButton *)cylindrical_180{
    if (!_cylindrical_180) {
        _cylindrical_180 = [[UIButton alloc]init];
        [_cylindrical_180 setImage:[UIImage imageNamed:@"VR-cylinder_nor.png"] forState:UIControlStateNormal];
        [_cylindrical_180 setImage:[UIImage imageNamed:@"VR-cylinder_sel.png"] forState:UIControlStateSelected];
        BUTTON_TARGET(_cylindrical_180, click_cylindrical_180);
    }
    return _cylindrical_180;
}

-(UIButton *)split_180{
    if (!_split_180) {
        _split_180 = [[UIButton alloc]init];
        [_split_180 setImage:[UIImage imageNamed:@"VR-four_nor.png"] forState:UIControlStateNormal];
        [_split_180 setImage:[UIImage imageNamed:@"VR-four_sel.png"] forState:UIControlStateSelected];
        BUTTON_TARGET(_split_180, click_split_180);
    }
    return _split_180;
}

-(UIButton *)three_180{
    if (!_three_180) {
        _three_180 = [[UIButton alloc]init];
        [_three_180 setImage:[UIImage imageNamed:@"180_3R_nor.png"] forState:UIControlStateNormal];
        [_three_180 setImage:[UIImage imageNamed:@"180_3R_sel.png"] forState:UIControlStateSelected];
        BUTTON_TARGET(_three_180, click_three_180);
    }
    return _three_180;
}

#pragma mark 按钮响应的方法  以下两个方法用于显示不同的鱼眼显示方式
- (void)chooseCeilingFunction{
    self.BallBowl.hidden = NO;
    self.BallHat.hidden = NO;
    self.Cylinder.hidden = NO;
    self.Split.hidden = NO;
    self.dichotomia.hidden = NO;
}

- (void)chooseWarFunction{
    self.BallBowl.hidden = YES;
    self.BallHat.hidden = YES;
    self.Cylinder.hidden = YES;
    self.Split.hidden = YES;
    self.dichotomia.hidden = YES;
}

- (void)removeSelf{
    [self removeFromSuperview];
}


-(void)showFunctionViewWith:(XMVRType)type{
    if (type == XMVR_TYPE_360D) {//根据不同的模式添加不同的功能按钮
//        [self.menuView addSubview:self.war];
//        [self.menuView addSubview:self.ceiling];
//        
//        [self.menuView addSubview:self.Ball];
//        [self.menuView addSubview:self.Rectangle];
//        
//        [self.menuView addSubview:self.BallBowl];
//        [self.menuView addSubview:self.BallHat];
//        [self.menuView addSubview:self.Cylinder];
//        [self.menuView addSubview:self.Split];
//        [self.menuView addSubview:self.dichotomia];
        
        self.war.hidden = NO;
        self.Ball.hidden = NO;
        self.ceiling.hidden = NO;
        self.Rectangle.hidden = NO;
        self.BallBowl.hidden = NO;
        self.BallHat.hidden = NO;
        self.Cylinder.hidden = NO;
        self.Split.hidden = NO;
        self.dichotomia.hidden = NO;
        
        self.curve_180.hidden = YES;
        self.rectangle_180.hidden = YES;
        self.cylindrical_180.hidden = YES;
        self.split_180.hidden = YES;
        self.three_180.hidden = YES;
        
    }else if (type == XMVR_TYPE_180D){
//        [self.menuView addSubview:self.curve_180];
//        [self.menuView addSubview:self.rectangle_180];
//        [self.menuView addSubview:self.cylindrical_180];
//        [self.menuView addSubview:self.split_180];
//        [self.menuView addSubview:self.three_180];
        
        self.war.hidden = YES;
        self.Ball.hidden = YES;
        self.ceiling.hidden = YES;
        self.Rectangle.hidden = YES;
        self.BallBowl.hidden = YES;
        self.BallHat.hidden = YES;
        self.Cylinder.hidden = YES;
        self.Split.hidden = YES;
        self.dichotomia.hidden = YES;
        
        self.curve_180.hidden = NO;
        self.rectangle_180.hidden = NO;
        self.cylindrical_180.hidden = NO;
        self.split_180.hidden = NO;
        self.three_180.hidden = NO;
    }else{
        [self removeFromSuperview];
    }
}

#pragma mark click 180 button method
-(void)click_curve_180:(UIButton *)btn{
    self.curve_180.selected = YES;
    self.rectangle_180.selected = NO;
    self.cylindrical_180.selected = NO;
    self.split_180.selected = NO;
    self.three_180.selected = NO;
}

-(void)click_rectangle_180:(UIButton *)btn{
    self.curve_180.selected = NO;
    self.rectangle_180.selected = YES;
    self.cylindrical_180.selected = NO;
    self.split_180.selected = NO;
    self.three_180.selected = NO;
}

-(void)click_cylindrical_180:(UIButton *)btn{
    self.curve_180.selected = NO;
    self.rectangle_180.selected = NO;
    self.cylindrical_180.selected = YES;
    self.split_180.selected = NO;
    self.three_180.selected = NO;
}

-(void)click_split_180:(UIButton *)btn{
    self.curve_180.selected = NO;
    self.rectangle_180.selected = NO;
    self.cylindrical_180.selected = NO;
    self.split_180.selected = YES;
    self.three_180.selected = NO;
}

-(void)click_three_180:(UIButton *)btn{
    self.curve_180.selected = NO;
    self.rectangle_180.selected = NO;
    self.cylindrical_180.selected = NO;
    self.split_180.selected = NO;
    self.three_180.selected = YES;
}

@end
