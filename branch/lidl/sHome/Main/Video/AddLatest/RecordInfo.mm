//
//  RecordInfo.m
//  XMeye
//
//  Created by dadalang on 14-1-12.
//  Copyright (c) 2014年 hzjf. All rights reserved.
//

#import "RecordInfo.h"
#import "FunSDK/FunSDK.h"

@implementation RecordInfo
@synthesize channelNo = _channelID;
@synthesize fileType = _fileType;
@synthesize fileSize = _fileSize;
@synthesize fileName = _fileName;
@synthesize timeBegin = _timeBegin;
@synthesize timeEnd = _timeEnd;
@synthesize picPath = _picPath;
-(id) init{
    _channelID = 0;
    _fileType = 0;
    _fileSize = 0;
    _fileName = nil;
    _picPath = nil;
    _ifDownLoad = NO;
    _ifSelected = NO;
    memset(&_timeBegin, 0, sizeof(SDK_SYSTEM_TIME));
    memset(&_timeEnd, 0, sizeof(SDK_SYSTEM_TIME));
    return [super init];
}

-(bool)isFishFile{
    return [RecordInfo isFishFile:self.localFilePath];
}
-(BOOL)isFishImage{
    FishEyeFrameParam fishEyeFrameParam = {0};
    int ret = -1;
    ret = jpghead_read_exif((char *)[self.localFilePath UTF8String], &fishEyeFrameParam);
    
    if (ret == 0)  {
        //鱼眼
        if(fishEyeFrameParam.type == 0x03) {
            //如果是硬解
            return true;
        } else if(fishEyeFrameParam.type == 0x04){
            //如果是软解
            return true;
        } else if (fishEyeFrameParam.type == 0x05) {
            return false;
        } else {
            //未知
            return false;
        }
        
    } else {
        //非鱼眼产品
        return false;
    }
    
}
+(int)getFileType:(NSString *)filePath{
    FishEyeFrameParam fishEyeFrameParam = {0};
    fishEyeFrameParam.type = 0;
    FUN_JPGHead_Read_Exif((char *)[filePath UTF8String], &fishEyeFrameParam);
    return fishEyeFrameParam.type;
}
+(bool)isFishFile:(NSString *)filePath{
    if (filePath == nil) {
        return false;
    }
    FishEyeFrameParam fishEyeFrameParam = {0};
    int ret = -1;
    ret = jpghead_read_exif((char *)[filePath UTF8String], &fishEyeFrameParam);
    
    
    if ([filePath hasSuffix:@".fvideo"]) {
        return true;
    }
    
    if (ret == 0)  {
        //鱼眼
        if(fishEyeFrameParam.type == 0x03) {
            //如果是硬解
            return true;
        } else if(fishEyeFrameParam.type == 0x04){
            //如果是软解
            return true;
        } else if (fishEyeFrameParam.type == 0x05) {
            return false;
        } else {
            //未知
            return false;
        }
        
    } else {
        //非鱼眼产品
        return false;
    }
    
}

@end
