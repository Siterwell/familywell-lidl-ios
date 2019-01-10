//
//  NSSDKMediaPlayer.m
//  FunSDKDemo
//
//  Created by zyj on 2017/3/2.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKMediaPlayer.h"
#import "GUI.h"

@interface NSSDKMediaPlayer (){
}
@property (nonatomic,assign) FUN_HANDLE hPlayer;

//用于重新进入播放界面时 重新播放视频
@property (nonatomic, strong) id window;//播放窗口
@property (nonatomic, unsafe_unretained) H264_DVR_FINDINFO *timeInfo;//播放信息
@property (nonatomic, unsafe_unretained) BOOL bStopBySysMsg;//
@end

@implementation NSSDKMediaPlayer

-(id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.hPlayer = 0;
    self.delegate = nil;
    self.fishDelegate = nil;
    self.deviceSN = @"";
    self.nStreamType = 1;
    self.nChannel = 0;
    self.nSound = 0;
    self.bStopBySysMsg = NO;
    self.playState = ENSMEDIA_STATE_NONE;
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopCurrentPlayHandle:) name:@"appDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playCurrentPlayHandle:) name:@"appWillEnterForeground" object:nil];
    
    return self;
}

//当正在播放时 程序被用户退到后台  那么就关闭当前播放句柄
-(void)stopCurrentPlayHandle:(NSNotification *)noti{
    if (self.hPlayer != 0) {
        [self stop];
        self.bStopBySysMsg = YES;
    }
}

//当程序重新进入播放界面时 继续播放之前的视频
-(void)playCurrentPlayHandle:(NSNotification *)noti{
    if (self.bStopBySysMsg) {
        self.bStopBySysMsg = NO;
        if (self.playType == RealPlay) {//实时播放
            [self play:self.deviceSN andWnd:self.window andChannel:self.nChannel andStreamType:self.nStreamType andSeq:self.nSeq];
        }else{//录像回放
            [self play:self.deviceSN andWnd:self.window PlayTimeInfo:self.timeInfo andSeq:self.nSeq];
        }
    }
}

-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appWillEnterForeground" object:nil];
}

-(int)play:(NSString *)deviceId andWnd:(id)wnd andChannel:(int)chn andStreamType:(int)streamType andSeq:(int)seq{
    [self stop];
    self.playState = ENSMEDIA_STATE_PLAY;
    self.nSeq = seq;
    self.deviceSN = deviceId;
    self.nChannel = chn;
    self.window = wnd;
    self.nStreamType = streamType;
    self.hPlayer = FUN_MediaRealPlay(SDK_HANDLE, SZSTR(deviceId), chn, streamType, (__bridge void *)wnd, _nSeq);
    return 0;
}

-(int)play:(NSString *)deviceId andWnd:(id)wnd PlayTimeInfo:(H264_DVR_FINDINFO *)timeInfo andSeq:(int)seq{
    [self stop];
    self.playState = ENSMEDIA_STATE_PLAY;
    self.nSeq = seq;
    self.deviceSN = deviceId;
    self.window = wnd;
    self.timeInfo = timeInfo;
    self.hPlayer = FUN_MediaNetRecordPlayByTime(SDK_HANDLE, SZSTR(deviceId), timeInfo, (__bridge void *)wnd, seq);
    return 0;
}

-(int)pause:(BOOL)bPause{
    self.playState = bPause ? ENSMEDIA_STATE_PAUSE : ENSMEDIA_STATE_PLAY;
    return FUN_MediaPause(self.hPlayer, bPause ? 1 : 0);
}

-(int)stop{
    self.playState = ENSMEDIA_STATE_STOP;
    if (self.hPlayer) {
        FUN_MediaStop(self.hPlayer);
        self.hPlayer = 0;
        NSLog(@"播放器关闭了播放器关闭了");
    }
    return 0;
}

-(int)setSound:(int)nSound{
    self.nSound = nSound;
    return FUN_MediaSetSound(self.hPlayer, nSound, _nSeq);
}

-(int)seekTotime:(time_t)seekTime{
    return FUN_MediaSeekToTime(self.hPlayer, -1, (int)seekTime, _nSeq);
}

-(int)setFluency:(int)level{
    return FUN_MediaSetFluency(self.hPlayer, level, _nSeq);
}

-(int)snapImage:(NSString *)filePath{
    return FUN_MediaSnapImage(self.hPlayer, SZSTR(filePath), _nSeq);
}

-(int)snapThumbnail:(NSString *)filePath{
    return FUN_MediaGetThumbnail(self.hPlayer, SZSTR(filePath), _nSeq);
}

-(int)startRecord:(NSString *)filePath{
    self.isRecording = YES;
    //先生成一个缩略图
    FUN_MediaGetThumbnail(self.hPlayer, CSTR(filePath), _nSeq);
    return FUN_MediaStartRecord(self.hPlayer, SZSTR(filePath), _nSeq);
}

-(int)stopRecord{
    self.isRecording = NO;
    return FUN_MediaStopRecord(self.hPlayer, _nSeq);
}

-(int)fisheyeSnapImage:(NSString *)filePath{
    //1. .yuv的数据
    return FUN_MediaSnapImage(self.hPlayer,SZSTR(filePath), 2);//手动抓图seq = 0,封面抓图seq = 1, 鱼眼手动抓图seq = 2, 鱼眼封面抓图seq = 3
}

-(int)fisheyeStartRecord:(NSString *)filePath{
    //先生成一个缩略图
    FUN_MediaGetThumbnail(self.hPlayer, CSTR(filePath), _nSeq);
    return FUN_MediaStartRecord(self.hPlayer, CSTR(filePath));
}

#pragma mark - 鱼眼YUV
-(void)fisheyeYUV{
    self.isYuv = YES;
    FUN_SetIntAttr(self.hPlayer, EOA_MEDIA_YUV_USER, SDK_HANDLE);//返回Yuv数据
    FUN_SetIntAttr(self.hPlayer, EOA_SET_MEDIA_VIEW_VISUAL, 0);//自己画画面
}



#pragma mark FunSDKCallBack
-(void)OnFunSDKResult:(NSSDKObject *)sender MsgId:(int)msgId Param1:(int)param1 Param2:(int)param2 Param3:(int)param3 String:(const char *)szStr Data:(char *)pData DataLen:(int)length Seq:(int)seq{
    [super OnFunSDKResult:sender MsgId:msgId Param1:param1 Param2:param2 Param3:param3 String:szStr Data:pData DataLen:length Seq:seq];
    
    
    if (self.delegate == nil) {
        return;
    }
    switch (msgId) {
        case EMSG_START_PLAY:{
            if (param1 < 0) {
                self.playState = ENSMEDIA_STATE_STOP;
            }
            [self.delegate OnPlay:self Result:param1 Param1:param2];
            break;
        }
        case EMSG_PAUSE_PLAY:{
            if (param1 < 0) {
                self.playState = ENSMEDIA_STATE_STOP;
            }
            [self.delegate OnPause:self Result:param1 CurState:param2];
            break;
        }
        case EMSG_ON_PLAY_INFO:{
            [self.delegate OnPlayInfo:self StrInfo:szStr Param1:param1 Param2:param2];
            break;
        }
        case EMSG_ON_PLAY_END:{
            [self.delegate OnPlayEnd:self];
            break;
        }
            /***********************************鱼眼相关***************************************************/
#pragma mark -鱼眼相关处理
#pragma mark 用户自定义信息帧回调
        case EMSG_ON_FRAME_USR_DATA:{
            Fish_codec_type fishCodecType = fish_codec_unknown;
            int fishSceneType = 0;//场景
            
            if (param2 == 3 ) {
                fishCodecType = fish_codec_hard;
                
                SDK_FishEyeFrameHW *pFishFrameInfo = (SDK_FishEyeFrameHW *)(pData + 8);
                
                if (pFishFrameInfo->secene == SDK_FISHEYE_SECENE_P360_FE) {
                    fishSceneType = SDK_FISHEYE_SECENE_P360_FE;
                    
                    FUN_SetIntAttr(self.hPlayer, EOA_MEDIA_YUV_USER, SDK_HANDLE);//返回Yuv数据
                    FUN_SetIntAttr(self.hPlayer, EOA_SET_MEDIA_VIEW_VISUAL, 0);//自己画画面
                    self.isYuv = YES;
                    
                }else if (pFishFrameInfo->secene == SDK_FISHEYE_SECENE_RRRR_R) {
                    fishSceneType = SDK_FISHEYE_SECENE_RRRR_R;
                    
                    FUN_SetIntAttr(self.hPlayer, EOA_MEDIA_YUV_USER, 0);//不返回Yuv数据
                    FUN_SetIntAttr(self.hPlayer, EOA_SET_MEDIA_VIEW_VISUAL, 1);//底层画画面
                    self.isYuv = NO;
                }
            }
            else if(param2 == 4) {
                fishCodecType =fish_codec_soft;
                
                SDK_FishEyeFrameSW *pFishFrameInfo = (SDK_FishEyeFrameSW *)(pData + 8);
                
                FUN_SetIntAttr(self.hPlayer, EOA_MEDIA_YUV_USER, SDK_HANDLE);//返回Yuv数据
                FUN_SetIntAttr(self.hPlayer, EOA_SET_MEDIA_VIEW_VISUAL, 0);//自己画画面
                self.isYuv = YES;
                
                // 圆心偏差横坐标  单位:像素点
                short  centerOffsetX = pFishFrameInfo->centerOffsetX;
                //圆心偏差纵坐标  单位:像素点
                short centerOffsetY = pFishFrameInfo->centerOffsetY;
                //半径  单位:像素点
                short radius = pFishFrameInfo->radius;
                //圆心校正时的图像宽度  单位:像素点
                short imageWidth = pFishFrameInfo->imageWidth;
                //圆心校正时的图像高度  单位:像素点
                short imageHeight = pFishFrameInfo->imageHeight;
                //视角  0:俯视   1:平视
                if (pFishFrameInfo->viewAngle == 0) {
                    
                }
                //显示模式   0:360VR
                //                NSLog(@"%d",pFishFrameInfo->lensType);
                if (pFishFrameInfo->lensType == SDK_FISHEYE_LENS_360VR || pFishFrameInfo->lensType == SDK_FISHEYE_LENS_360LVR) {//360vr
                    
                    fishSceneType = XMVR_TYPE_360D;
                }else{//180Vr
                    fishSceneType = XMVR_TYPE_180D;
                }
                
                if ( self.fishDelegate && [self.fishDelegate respondsToSelector:@selector(OnYuvCenterOffSetX:offSetx:offY:radius:width:height:)] ) {
                    [self.fishDelegate OnYuvCenterOffSetX:self offSetx:centerOffsetX offY:centerOffsetY radius:radius width:imageWidth height:imageHeight];
                }
            }else if (param2 == 5)
            {
                //                没有鱼眼类型的摇头机 先注销掉
                //                fishCodecType =fish_codec_robot;
                //                FUN_SetIntAttr(self.hPlayer, EOA_MEDIA_YUV_USER, SDK_HANDLE);//返回Yuv数据
                //                FUN_SetIntAttr(self.hPlayer, EOA_SET_MEDIA_VIEW_VISUAL, 0);//自己画画面
                //                self.isYuv = YES;
                
            }
            
            if ( self.fishDelegate && [self.fishDelegate respondsToSelector:@selector(OnYuvPlayer:codecType:scene:)] ) {
                [self.fishDelegate OnYuvPlayer:self codecType:fishCodecType scene:fishSceneType];
            }
            
            break;
        }
#pragma mark YUV数据回调
        case EMSG_ON_YUV_DATA:{
            if ( self.fishDelegate && [self.fishDelegate respondsToSelector:@selector(OnYuvPlayer:width:height:pYUV:)] ) {
                [self.fishDelegate OnYuvPlayer:self width:param2 height:param3 pYUV:(unsigned char *)pData];
            }
            
            break;
        }
            /*******************************************************************************************************/
            
        case EMSG_ON_PLAY_BUFFER_BEGIN:{
            break;
        }
        case EMSG_ON_PLAY_BUFFER_END:{
            break;
        }
        case EMSG_ON_Media_Thumbnail:{
            NSLog(@"[RYAN] NSSDKMediaPlayer > EMSG_ON_Media_Thumbnail > path: %@", NSSTR(szStr));
            [self.delegate OnSnapThumbnail:self  Result:param1 FilePath:NSSTR(szStr)];
            break;
        }
        case EMSG_SAVE_IMAGE_FILE:{
            NSLog(@"[RYAN] NSSDKMediaPlayer > EMSG_SAVE_IMAGE_FILE > path: %@", NSSTR(szStr));
            [self.delegate OnSnapImage:self  Result:param1 FilePath:NSSTR(szStr)];
            break;
        }
        case EMSG_START_SAVE_MEDIA_FILE:{
            [self.delegate OnStartRecord:self  Result:param1 FilePath:NSSTR(szStr)];
            break;
        }
        case EMSG_STOP_SAVE_MEDIA_FILE:{
            [self.delegate OnStopRecord:self  Result:param1 FilePath:NSSTR(szStr)];
            break;
        }
        default:
            break;
    }
}
@end
