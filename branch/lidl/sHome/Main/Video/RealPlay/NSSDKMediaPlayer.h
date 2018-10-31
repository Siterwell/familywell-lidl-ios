//
//  NSSDKMediaPlayer.h
//  FunSDKDemo
//
//  Created by zyj on 2017/3/2.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayView.h"
#import "NSSDKObject.h"
#import "VRSoft.h"
#import "FunSDK/FunSDK.h"

/*************************鱼眼相关*******************************/

//鱼眼codec类型
typedef enum : int{
    fish_codec_unknown = -1,
    fish_codec_hard = 3,//硬件编解码
    fish_codec_soft = 4,//软件编解码
    //    fish_codec_robot = 5,//摇头机  没有鱼眼类型的摇头机 先注销掉
}Fish_codec_type;

//鱼眼安装方式(application)
typedef enum : int {
    fish_app_ceiling = 0,
    fish_app_war,
} Fish_app_type;

/***************************************************************/






@class NSSDKMediaPlayer;
@protocol SDKMediaPlayerDelegate <NSObject>
@required
-(void)OnPlay:(NSSDKMediaPlayer *)sender Result:(int)result Param1:(int)Param1;
-(void)OnPause:(NSSDKMediaPlayer *)sender Result:(int)result CurState:(int)state;
-(void)OnPlayEnd:(NSSDKMediaPlayer *)sender;
-(void)OnPlayInfo:(NSSDKMediaPlayer *)sender StrInfo:(const char *)szStr Param1:(int)Param1 Param2:(int)Param2;
-(void)OnStartRecord:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath;
-(void)OnStopRecord:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath;
-(void)OnSnapImage:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath;
-(void)OnSnapThumbnail:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath;
@end


/*************************鱼眼代理方法*******************************/
@protocol SDKMediaFishPlayerDelegate <NSObject>
@required
//用户自定义信息帧回调
-(void)OnYuvPlayer:(NSSDKMediaPlayer*)sender codecType:(Fish_codec_type)codec scene:(int)scene;
//YUV数据回调
-(void)OnYuvPlayer:(NSSDKMediaPlayer*)sender width:(int)width height:(int)height pYUV:(unsigned char *)pYUV;
//鱼眼软解
-(void)OnYuvCenterOffSetX:(NSSDKMediaPlayer*)sender  offSetx:(short)OffSetx offY:(short)OffSetY  radius:(short)radius width:(short)width height:(short)height ;
@end
/*****************************************************************/

typedef enum ENSMEDIA_STATE{
    ENSMEDIA_STATE_NONE,
    ENSMEDIA_STATE_PLAY,
    ENSMEDIA_STATE_PAUSE,
    ENSMEDIA_STATE_STOP,
}ENSMEDIA_STATE;

//当前播放Player属于哪个控制器 实时播放/录像回放
typedef NS_ENUM(NSInteger ,PlayType) {
    RealPlay,//实时播放
    RecordPlay//录像回放
};

@interface NSSDKMediaPlayer : NSSDKObject
@property (nonatomic, weak, nullable) id <SDKMediaPlayerDelegate> delegate;
@property (nonatomic, weak, nullable) id <SDKMediaFishPlayerDelegate> fishDelegate;
@property (nonatomic, copy) NSString *deviceSN;
@property (nonatomic, unsafe_unretained) int nChannel;
@property (nonatomic, unsafe_unretained) int nStreamType;   //码流类型（0：主码流 1：副码流）
@property (nonatomic, unsafe_unretained) int nSeq;
@property (nonatomic, unsafe_unretained) ENSMEDIA_STATE playState;
@property (nonatomic, unsafe_unretained) int nSound;
@property (nonatomic, unsafe_unretained) BOOL isRecording;
@property (nonatomic, unsafe_unretained) BOOL isYuv;//是否是鱼眼
@property (nonatomic, unsafe_unretained) PlayType playType;//当前player属于哪个控制器



-(int)play:(NSString *)deviceId andWnd:(id)wnd andChannel:(int)chn andStreamType:(int)streamType andSeq:(int)seq;
-(int)play:(NSString *)deviceId andWnd:(id)wnd PlayTimeInfo:(H264_DVR_FINDINFO *)timeInfo andSeq:(int)seq;
-(int)pause:(BOOL)bPause;
-(int)stop;
-(int)setSound:(int)nSound; // -1表示静音 0～100表示音量
-(int)seekTotime:(time_t)seekTime;
-(int)setFluency:(int)level;
-(int)snapImage:(NSString *)filePath;
-(int)snapThumbnail:(NSString *)filePath;
-(int)startRecord:(NSString *)filePath;
-(int)stopRecord;
/*************************鱼眼相关*******************************/
#pragma mark - 鱼眼抓图，手动抓图seq = 0,封面抓图seq = 1, 鱼眼手动抓图seq = 2, 鱼眼封面抓图seq = 3
-(int)fisheyeSnapImage:(NSString *)filePath;
#pragma mark - 鱼眼设备开始录像
-(int)fisheyeStartRecord:(NSString *)filePath;
#pragma mark - 鱼眼YUV
-(void)fisheyeYUV;
/****************************************************************/



@end
