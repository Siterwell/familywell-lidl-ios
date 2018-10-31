//
//  VideoOperationView.h
//  sHome
//
//  Created by CY on 2018/3/27.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoOperationView : UIView

@property (nonatomic) UIButton *playBtn;

@property (nonatomic) UIButton *fullBtn;

@property (nonatomic, copy) void(^playBtnClickBlock)(void);

@property (nonatomic, copy) void(^soundBtnClickBlock)(void);

@property (nonatomic, copy) void(^captureBtnClickBlock)(void);

@property (nonatomic, copy) void(^fullBtnClickBlock)(void);

@end
