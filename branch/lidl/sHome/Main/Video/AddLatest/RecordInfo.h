//
//  RecordInfo.h
//  XMeye
//
//  Created by dadalang on 14-1-12.
//  Copyright (c) 2014年 hzjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunSDK/netsdk.h"
@interface RecordInfo : NSObject
{
    int _channelID;
    int _fileType;
    int _fileSize;
    NSString* _fileName;
    SDK_SYSTEM_TIME _timeBegin;
    SDK_SYSTEM_TIME _timeEnd;
}

typedef enum Image_Type{
    Img_Type_H,//手动
    Img_Type_M,//移动侦测
    Img_Type_A,// 访客
    Img_Type_R,
    Img_Type_P, // 人体感应
}_Image_Type;

typedef enum CaptureImage_type{
    Capture_Type_N = 0, //普通
    Capture_Type_K, //遥控
    Capture_Type_B, //连拍
    Capture_Type_L, //延时拍
}CaptureImage_type;

typedef NS_ENUM(NSInteger, RecordSourceType) {
    RecordSourceTypeLocal,
    RecordSourceTypeDevice
};

typedef NS_ENUM(NSInteger, RecordType) {
    RecordTypePic,
    RecordTypeVideo,
    RecordTypePicFisheye,
    RecordTypeVideoFisheye
};

@property int channelNo;
@property int fileType;
@property int fileSize;
@property (strong, nonatomic) NSString* fileName;
@property (nonatomic,assign) enum Image_Type myImgType; 
@property (nonatomic,assign) enum CaptureImage_type capType;
@property (nonatomic,copy) NSString *picPath;

@property (assign,nonatomic) BOOL ifSelected;    // 是否被选中

@property (nonatomic,assign) BOOL ifDownLoad;     // 是否已经下载

@property SDK_SYSTEM_TIME timeBegin;
@property SDK_SYSTEM_TIME timeEnd;

@property (nonatomic,copy) NSString* name;
@property (nonatomic,assign) RecordSourceType sourceType;
@property (nonatomic,assign) RecordType recordType;
@property (nonatomic,copy) NSString* source;//设备ID
@property (nonatomic) NSDate* date;//日期
@property (nonatomic) NSDate* begintime;//开始时间
@property (nonatomic) NSDate* endtime;//结束时间
@property (nonatomic,assign) NSUInteger size;//文件大小
@property (nonatomic,copy) NSString* localFilePath;//原图的存储路径,调用FUN_DevDowonLoadByFile
@property (nonatomic) NSString* thumbnail;//缩略图的存储路径,调用FUN_DevSearchPic
@property (nonatomic,assign) NSUInteger savepos;
@property (nonatomic,assign) BOOL isSaving;
@property (nonatomic,assign) BOOL isSelected;
-(bool)isFishFile;
-(BOOL)isFishImage;
+(int)getFileType:(NSString *)filePath;
+(bool)isFishFile:(NSString *)filePath;

@end
