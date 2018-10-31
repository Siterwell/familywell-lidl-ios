//
//  VideoShowWindow.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/8.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayView.h"
#import "VRGLViewController.h"
#import "NSSDKMediaPlayer.h"
#import "FisheyeDevInfo.h"

typedef enum {
    ShowWindowScreenNoFull,
    ShowWindowScreenFull
}NScreenFullState;

@interface VideoShowWindow : NSObject<SDKMediaFishPlayerDelegate>
@property (nonatomic, strong) DisplayView *showWindow;
@property (nonatomic, strong) VRGLViewController *SoftVR;
@property (nonatomic, strong) UIViewController *parentVC;
@property (nonatomic, strong) FisheyeDevInfo *fisheyeDevInfo;
@property (nonatomic, assign) NScreenFullState screenFullState;
- (VideoShowWindow *)initWithFrame:(CGRect)frame;
- (DisplayView *)getAndShowWindow;
@end
