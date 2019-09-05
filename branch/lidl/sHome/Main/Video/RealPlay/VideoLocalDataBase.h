//
//  VideoDataBase.h
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoInfoModel.h"

@interface VideoLocalDataBase : NSObject

+ (instancetype)sharedDataBase;

- (NSMutableArray *)selectVideoInfoByInfoType:(NSInteger)infoType andDevId:(NSString *)devId;

- (NSMutableArray *)selectVideoInfo;
    
- (void)updateVideoInfo:(VideoInfoModel *)model;

- (BOOL)deletVideoInfo:(NSInteger)vId;

- (void)deletAllVideoInfo;

- (BOOL)deletVideoByFilePath:(NSString *)file_path;
@end
