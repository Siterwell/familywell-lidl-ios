//
//  VRFunctionView.h
//  XMEye
//
//  Created by riceFun on 16/12/1.
//  Copyright © 2016年 Megatron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRSoft.h"
@interface VRFunctionView : UIView

@property (nonatomic, assign) XMVRType VRType;

//funcView1 360
@property (nonatomic, strong) UIView *menuView;//显示整个鱼眼显示选项的View

@property (nonatomic, strong) UIButton *war;//装在墙壁上;
@property (nonatomic, strong) UIButton *ceiling;//装在天花板上

@property (nonatomic, strong) UIButton *Ball;//球 Shape_Ball
@property (nonatomic, strong) UIButton *Rectangle;//矩形 Shape_Cylinder

@property (nonatomic, strong) UIButton *BallBowl; //碗状和Ball_Hat相反 Shape_Ball_Bowl
@property (nonatomic, strong) UIButton *BallHat;// 球/半球,帽子型 Shape_Ball_Hat
@property (nonatomic, strong) UIButton *Cylinder;//圆柱 Shape_Cylinder
@property (nonatomic, strong) UIButton *Split; //四分按钮
@property (nonatomic, strong) UIButton *dichotomia;//二分按钮

//funcView2 180
@property (nonatomic, strong) UIButton *curve_180;
@property (nonatomic, strong) UIButton *rectangle_180;
@property (nonatomic, strong) UIButton *cylindrical_180;
@property (nonatomic, strong) UIButton *split_180;
@property (nonatomic, strong) UIButton *three_180;

@property (nonatomic, strong) UIView *modeView;
@property (nonatomic, strong) UIButton *closeMode;//最左边打开(关闭)menuView  


-(void)showFunctionViewWith:(XMVRType)type;
@end
