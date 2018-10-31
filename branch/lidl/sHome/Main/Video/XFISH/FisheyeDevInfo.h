//
//  FisheyeDevInfo.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/7.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FisheyeDevInfo : NSObject

@property (nonatomic, assign) int iCodecType;//编解码类型
@property (nonatomic, assign) int iSceneType;//场景
@property (nonatomic, assign) int centerOffSetX;
@property (nonatomic, assign) int centerOffSetY;
@property (nonatomic, assign) int radius;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

@end
