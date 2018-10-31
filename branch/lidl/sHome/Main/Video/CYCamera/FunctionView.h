//
//  FunctionView.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/2.
//  Copyright © 2017年 riceFun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFCustomButton.h"

@interface FunctionView : UIView//停止、静音、截图、录像 四个按钮父视图

//刷新 静音 高清 截图 全屏

@property (nonatomic, strong) RFCustomButton *playOrStopBtn; //刷新
@property (nonatomic, strong) RFCustomButton *soundBtn; //静音
@property (nonatomic, strong) RFCustomButton *captureBtn; //截图
@property (nonatomic, strong) RFCustomButton *recordBtn; //录像
@property (nonatomic, strong) RFCustomButton *playBtn;  //播放
@property (nonatomic, strong) RFCustomButton *stopBtn; //暂停
@property (nonatomic, strong) RFCustomButton *fullScreenBtn; //全屏
@property (nonatomic, strong) RFCustomButton *resolutionBtn; //清晰度

@end
