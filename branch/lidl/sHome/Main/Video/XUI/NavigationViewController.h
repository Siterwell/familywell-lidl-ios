//
//  NavigaterViewController.h
//  FunSDKDemo
//
//  Created by liuguifang on 16/5/17.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import "BaseViewControler.h"

@interface NavigationViewController : BaseViewController

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton* back;
@property (nonatomic, strong) UIButton* rightBtn;



-(void)setRightBtnText:(NSString *)text;
-(void)btnBackClicked;
-(void)btnRightClicked;

@property (nonatomic, strong) UIButton* centerBtn;
-(void)setCenterBtnText:(NSString *)text;
-(void)btnCenterClicked;

@property (nonatomic, strong) UIButton *rightBtn2;
-(void)setrightBtn2Text:(NSString *)text;
-(void)btnRightClicked2;
@end
