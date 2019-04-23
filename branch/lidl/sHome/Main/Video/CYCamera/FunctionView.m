//
//  FunctionView.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/2.
//  Copyright © 2017年 riceFun. All rights reserved.
//

#import "FunctionView.h"
#import "GUI.h"

@implementation FunctionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.playOrStopBtn = [[RFCustomButton alloc]init];
//        [self.playOrStopBtn setTitle:TS("StopOrPlay") forState:UIControlStateNormal];
//        [self.playOrStopBtn setBackgroundColor:[UIColor lightGrayColor]];
//        
//        self.soundBtn= [[RFCustomButton alloc]init];
//        [self.soundBtn setTitle:TS("Mute") forState:UIControlStateNormal];
//        [self.soundBtn setBackgroundColor:[UIColor grayColor]];
        
        self.backgroundColor = RGBA(128, 198, 233, 0.85);
//        self.recordBtn= [[RFCustomButton alloc]init];
//        [self.recordBtn setBackgroundColor:[UIColor clearColor]];
        
        self.playBtn = [[RFCustomButton alloc]init];
        [self.playBtn setImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
//        [self.playBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 23.5, 15, 23.5)];
        [self.playBtn setBackgroundColor:[UIColor clearColor]];
        
        self.soundBtn = [[RFCustomButton alloc] init];
        [self.soundBtn setImage:[UIImage imageNamed:@"volume_icon"] forState:UIControlStateNormal];
        [self.soundBtn setImage:[UIImage imageNamed:@"mute_icon"] forState:UIControlStateSelected];
//        [self.soundBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 19, 15, 19)];
        [self.soundBtn setBackgroundColor:[UIColor clearColor]];
        
        self.resolutionBtn = [[RFCustomButton alloc] init];
        [self.resolutionBtn setImage:[UIImage imageNamed:@"gq_icon"] forState:UIControlStateNormal];
        [self.resolutionBtn setImage:[UIImage imageNamed:@"bq_icon"] forState:UIControlStateSelected];
//        [self.resolutionBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
        self.resolutionBtn.backgroundColor = [UIColor clearColor];
        
        self.captureBtn= [[RFCustomButton alloc]init];
        [self.captureBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
//        [self.captureBtn setImageEdgeInsets:UIEdgeInsetsMake(13, 20, 13, 20)];
        [self.captureBtn setBackgroundColor:[UIColor clearColor]];
        
        self.fullScreenBtn= [[RFCustomButton alloc]init];
        [self.fullScreenBtn setImage:[UIImage imageNamed:@"enlarge_icon"] forState:UIControlStateNormal];
//        [self.fullScreenBtn setImageEdgeInsets:UIEdgeInsetsMake(14, 23, 14, 23)];
        [self.fullScreenBtn setBackgroundColor:[UIColor clearColor]];
        
        CGFloat x = [UIScreen mainScreen].bounds.size.width / 5;
        for (int i = 0; i < 4; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x*(i+1), 7, 1, self.frame.size.height - 14)];
            line.backgroundColor = [UIColor whiteColor];
            [self addSubview:line];
        }
        
        [self setSubViewsFrame];
        
        [self addSubview:self.playBtn];
        [self addSubview:self.soundBtn];
        [self addSubview:self.resolutionBtn];
        [self addSubview:self.captureBtn];
        [self addSubview:self.fullScreenBtn];

    }
    return self;
}

- (void)setSubViewsFrame{
//    self.playOrStopBtn.frame = CGRectMake(0, 0, self.frame.size.width/4, self.frame.size.height);
//    self.soundBtn.frame = CGRectMake(self.frame.size.width/4, 0, self.frame.size.width/4, self.frame.size.height);
//    self.captureBtn.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/4, self.frame.size.height);
//    self.recordBtn.frame = CGRectMake(self.frame.size.width*3/4, 0, self.frame.size.width/4, self.frame.size.height);
    
    self.playBtn.frame = CGRectMake(1, 0, self.frame.size.width/5-1, self.frame.size.height);
    self.soundBtn.frame = CGRectMake(self.frame.size.width/5+1, 0, self.frame.size.width/5-1, self.frame.size.height);
    self.resolutionBtn.frame = CGRectMake(self.frame.size.width*2/5+2, 0, self.frame.size.width/5-1, self.frame.size.height);
    self.captureBtn.frame = CGRectMake(self.frame.size.width*3/5+3, 0, self.frame.size.width/5, self.frame.size.height);
    self.fullScreenBtn.frame = CGRectMake(self.frame.size.width*4/5+4, 0, self.frame.size.width/5-1, self.frame.size.height);

}



@end
