//
//  VideoDataBase.h
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoInfoModel.h"

@interface VideoDataBase : NSObject

+ (instancetype)sharedDataBase;

- (VideoInfoModel *)selectVideoInfoByDevid:(NSString *)devid andUserName:(NSString *)userName;

- (NSMutableArray *)selectVideoInfo;
    
- (void)updateVideoInfo:(VideoInfoModel *)model;

- (BOOL)deletVideoInfo:(NSString *)devid andUserName:(NSString*)userName;

- (void)deletAllVideoInfo;


@end
