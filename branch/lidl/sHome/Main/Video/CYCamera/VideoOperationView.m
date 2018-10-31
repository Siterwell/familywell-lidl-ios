//
//  VideoOperationView.m
//  sHome
//
//  Created by CY on 2018/3/27.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "VideoOperationView.h"

@implementation VideoOperationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = RGBA(128, 198, 233, 0.85);
    
    CGFloat x = [UIScreen mainScreen].bounds.size.width / 4;
    for (int i = 0; i < 3; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x*(i+1), 7, 1, self.frame.size.height - 14)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
    }
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"stop_icon"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateSelected];
//    [playBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 30, 15, 30)];
    playBtn.frame = CGRectMake(1, 0, self.frame.size.width/4-1, self.frame.size.height);
    [self addSubview:playBtn];
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn = playBtn;
    
    UIButton *soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [soundBtn setImage:[UIImage imageNamed:@"volume_icon"] forState:UIControlStateNormal];
    [soundBtn setImage:[UIImage imageNamed:@"mute_icon"] forState:UIControlStateSelected];
//    [soundBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 30, 15, 30)];
    soundBtn.frame = CGRectMake(self.frame.size.width/4+1, 0, self.frame.size.width/4-1, self.frame.size.height);
    [self addSubview:soundBtn];
    [soundBtn addTarget:self action:@selector(soundBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *captureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [captureBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
//    [captureBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 27, 15, 27)];
    captureBtn.frame = CGRectMake(self.frame.size.width*2/4+2, 0, self.frame.size.width/4-1, self.frame.size.height);
    [self addSubview:captureBtn];
    [captureBtn addTarget:self action:@selector(captureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullBtn setImage:[UIImage imageNamed:@"enlarge_icon"] forState:UIControlStateNormal];
//    [fullBtn setImageEdgeInsets:UIEdgeInsetsMake(14, 23, 14, 23)];
    fullBtn.frame = CGRectMake(self.frame.size.width*3/4+3, 0, self.frame.size.width/4, self.frame.size.height);
    [self addSubview:fullBtn];
    [fullBtn addTarget:self action:@selector(fullBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.fullBtn = fullBtn;
}

- (void)playBtnClick:(UIButton *)sender {
    if (self.playBtnClickBlock) {
        sender.selected = !sender.selected;
        self.playBtnClickBlock();
    }
}

- (void)soundBtnClick:(UIButton *)sender {
    if (self.soundBtnClickBlock) {
        sender.selected = !sender.selected;
        self.soundBtnClickBlock();
    }
}

- (void)captureBtnClick {
    if (self.captureBtnClickBlock) {
        self.captureBtnClickBlock();
    }
}

- (void)fullBtnClick {
    if (self.fullBtnClickBlock) {
        self.fullBtnClickBlock();
    }
}

@end
