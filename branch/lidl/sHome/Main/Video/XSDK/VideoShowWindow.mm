//
//  VideoShowWindow.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/8.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "VideoShowWindow.h"

@implementation VideoShowWindow
- (VideoShowWindow *)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.showWindow = [[DisplayView alloc]initWithFrame:frame];
        self.showWindow.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (DisplayView *)getAndShowWindow{
    self.showWindow.hidden = NO;
    if (_SoftVR != nil) {
        _SoftVR.view.hidden = YES;
    }
    return self.showWindow;
}

-(FisheyeDevInfo *)fisheyeDevInfo{
    if(!_fisheyeDevInfo){
        _fisheyeDevInfo = [[FisheyeDevInfo alloc]init];
    }
    return _fisheyeDevInfo;
}

-(VRGLViewController *)SoftVR{
    if (!_SoftVR) {
        _SoftVR = [[VRGLViewController alloc]init];
        _SoftVR.view.frame = self.showWindow.frame;
        _SoftVR.view.backgroundColor = [UIColor orangeColor];
        [self.parentVC addChildViewController:_SoftVR];
        [self.parentVC.view addSubview:_SoftVR.view];
        self.showWindow.hidden = YES;
    }
    return _SoftVR;
}

/*************************鱼眼相关*******************************/
#pragma mark 鱼眼用户自定义信息帧代理回调
-(void)OnYuvPlayer:(NSSDKMediaPlayer *)sender codecType:(Fish_codec_type)codec scene:(int)scene{
    //如果codec或者scene发生了变化，那么需要重新生成GLView
    if (codec != self.fisheyeDevInfo.iCodecType || scene != self.fisheyeDevInfo.iSceneType) {
        [self mediaCodecType:codec scene:scene];
    }
    
    //配置成功后，储存收到的codec和scene
    self.fisheyeDevInfo.iCodecType = codec;
    self.fisheyeDevInfo.iSceneType = scene;
}

#pragma mark 鱼眼codec配置
-(void)mediaCodecType:(Fish_codec_type)codec scene:(int)scene {
    if(codec == fish_codec_hard && scene == SDK_FISHEYE_SECENE_P360_FE){
    } else if(codec ==fish_codec_soft) {
        if (scene == XMVR_TYPE_360D) {
            [self.SoftVR setVRType:XMVR_TYPE_360D];
        }else if (scene == XMVR_TYPE_180D) {
            [self.SoftVR setVRType:XMVR_TYPE_180D];
        }
        
        if (self.fisheyeDevInfo.width != 0 && self.fisheyeDevInfo.height != 0) {
            [self.SoftVR setVRFecParams:self.fisheyeDevInfo.centerOffSetX yCenter:self.fisheyeDevInfo.centerOffSetY radius:self.fisheyeDevInfo.radius Width:self.fisheyeDevInfo.width Height:self.fisheyeDevInfo.height];
        }
    }
    //没有鱼眼类型的摇头机  先注销掉
    //    else if (codec ==fish_codec_robot) {
    //        [self.SoftVR setVRType:XMVR_TYPE_SPE_CAM01];
    //        scene = XMVR_TYPE_SPE_CAM01;
    //
    //        if (self.fisheyeDevInfo.width != 0 && self.fisheyeDevInfo.height != 0) {
    //            [self.SoftVR setVRFecParams:self.fisheyeDevInfo.centerOffSetX yCenter:self.fisheyeDevInfo.centerOffSetY radius:self.fisheyeDevInfo.radius Width:self.fisheyeDevInfo.width Height:self.fisheyeDevInfo.height];
    //        }
    //    }
}

-(void)OnYuvCenterOffSetX:(NSSDKMediaPlayer *)sender offSetx:(short)OffSetx offY:(short)OffSetY radius:(short)radius width:(short)width height:(short)height{
    //保存当前传过来的数据
    self.fisheyeDevInfo.centerOffSetX = OffSetx;
    self.fisheyeDevInfo.centerOffSetY = OffSetY;
    self.fisheyeDevInfo.radius = radius;
    self.fisheyeDevInfo.width = width;
    self.fisheyeDevInfo.height = height;
    self.SoftVR.view.hidden = NO;
    _showWindow.hidden = YES;
    [self.SoftVR setVRFecParams:OffSetx yCenter:OffSetY radius:radius Width:width Height:height];
}

-(void)OnYuvPlayer:(NSSDKMediaPlayer *)sender width:(int)width height:(int)height pYUV:(unsigned char *)pYUV{
    [self.SoftVR PushData:width height:height YUVData:pYUV];
}
/****************************************************************************/

@end
