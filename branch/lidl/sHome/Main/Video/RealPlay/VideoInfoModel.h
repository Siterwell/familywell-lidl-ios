//
//  VideoInfoModel.h
//  sHome
//
//  Created by Apple on 2017/7/6.
//  Copyright © 2017年 shaop. All rights reserved.
//

@interface VideoInfoModel : NSObject

@property (nonatomic, strong) NSString<Ignore> *userName;
@property (nonatomic, strong) NSString<Ignore> *devid;
@property (nonatomic, strong) NSString<Ignore> *name;
@property (nonatomic, strong) NSString<Ignore> *imagePath;
@property (nonatomic, assign) NSInteger infoType; //1:抓图数据  2:视频录像
@property (nonatomic, assign) NSInteger vId; //主键
@property (nonatomic, strong) NSString<Ignore> *fileName;
@property (nonatomic, strong) NSString<Ignore> *filePath;
@property (nonatomic, strong) NSString<Ignore> *updataTime;

@end
