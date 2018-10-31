//
//  FunctionScrollView.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/2.
//  Copyright © 2017年 riceFun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFCustomButton.h"

@interface FunctionScrollView : UIScrollView<UIScrollViewDelegate>

//第一页上的控件
@property (nonatomic, strong) RFCustomButton *upBtn;
@property (nonatomic, strong) RFCustomButton *downBtn;
@property (nonatomic, strong) RFCustomButton *leftBtn;
@property (nonatomic, strong) RFCustomButton *rightBtn;

@property (nonatomic, strong) RFCustomButton *zoomUpBtn;
@property (nonatomic, strong) RFCustomButton *zoomDownBtn;
@property (nonatomic, strong) RFCustomButton *focusUpBtn;
@property (nonatomic, strong) RFCustomButton *focusDownBtn;
@property (nonatomic, strong) RFCustomButton *irisUpBtn;
@property (nonatomic, strong) RFCustomButton *irisDownBtn;

@property (nonatomic, strong) RFCustomButton *szysdBtn;
@property (nonatomic, strong) RFCustomButton *ysdListBtn;

//第二页上的控件
@property (nonatomic, strong) RFCustomButton *intercomBtn;//对讲
@property (nonatomic, strong) RFCustomButton *iconLbrBtn;//图片库
@property (nonatomic, strong) RFCustomButton *videoLbrBtn;//视频库

//第三页上的控件：先不加



@end
