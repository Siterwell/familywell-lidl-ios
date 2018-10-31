//
//  NSString+DealInternet.m
//  XMFamily
//
//  Created by Megatron on 9/12/14.
//  Copyright (c) 2014 Megatron. All rights reserved.
//

#import "NSString+Exsmaple.h"
#import "NSString+Extention.h"

@implementation NSString (Exsmaple)
+(void)CreateFilePath:(NSString *)fullPath{
    if (fullPath == nil) {
        return;
    }
    NSString *fileName = [fullPath lastPathComponent];
    if (fileName == nil) {
        return;
    }
    NSString *filePath = [fullPath substringWithRange:NSMakeRange(0, [fullPath length] - [fileName length])];
    if (fileName == nil) {
        return;
    }
     NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
+(NSString *)getMp4FilePath:(NSString *)deviceSn Channel:(int)channelNum{
    NSString *fileFullPath = [NSString stringWithFormat:@"%@Records/%@_%02d_%@.mp4",
            [NSString GetDocumentPath],
            deviceSn,
            channelNum,
            [NSString GetSystemTimeString2]
            ];
    [NSString CreateFilePath:fileFullPath];
    return fileFullPath;
}

+(NSString *)getJPGFilePath:(NSString *)deviceSn Channel:(int)channelNum{
    NSString *fileFullPath = [NSString stringWithFormat:@"%@Images/%@_%02d_%@.jpg",
            [NSString GetDocumentPath],
            deviceSn,
            channelNum,
            [NSString GetSystemTimeString2]
            ];
    [NSString CreateFilePath:fileFullPath];
    return fileFullPath;
}

+(NSString *)getJPGFilePathByDevSn:(NSString *)deviceSn{
    NSString *fileFullPath = [NSString stringWithFormat:@"%@Images/%@/currentImage.jpg",
                              [NSString GetDocumentPath],
                              deviceSn
                              ];
    [NSString CreateFilePath:fileFullPath];
    return fileFullPath;
}




@end
