//
//  NSString+DealInternet.h
//  XMFamily
//
//  Created by Megatron on 9/12/14.
//  Copyright (c) 2014 Megatron. All rights reserved.
//

#import <Foundation/Foundation.h>

#define N_RESOLUTION_COUNT 19

@interface NSString (Exsmaple)

+(NSString *)getMp4FilePath:(NSString *)deviceSn Channel:(int)channelNum;
+(NSString *)getJPGFilePath:(NSString *)deviceSn Channel:(int)channelNum;
+(NSString *)getJPGFilePathByDevSn:(NSString *)deviceSn;

@end
