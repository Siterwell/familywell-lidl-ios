#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>


#define kNumberBuffers 3
#define t_sample     SInt16
#define kSamplingRate   8000
#define kNumberChannels  1
#define kBitesPerChannels  (sizeof(t_sample) * 8)
#define kBytesPerFrame   (kNumberChannels * sizeof(t_sample))
#define kFrameSize      640


typedef struct AQCallbackStruct
{
    //音频流描述对象
    AudioStreamBasicDescription mDataFormate;
    //音频队列
    AudioQueueRef        queue;
    AudioQueueBufferRef  mBuffers[kNumberBuffers];
    AudioFileID          outputFile;
    
    unsigned long        frameSize;
    long long           recPtr;
    int               run;
    
} AQCallbackStruct;

@interface Recode : NSObject
{
    AQCallbackStruct aqc;
    AudioFileTypeID  fileFormat;
}

@property (nonatomic,strong) NSString *deviceMac;
@property (nonatomic) BOOL     sendData;;
- (id)init;
- (void)startRecode:(NSString *)devMac;
- (void)stopRecode;
- (void)processAudioBuffer:(AudioQueueBufferRef) buffer withQueue:(AudioQueueRef)queue;
@property (nonatomic, assign)AQCallbackStruct aqc;


@end
