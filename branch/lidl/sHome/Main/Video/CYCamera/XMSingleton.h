//
//  XMSingleton.h
//  sHome
//
//  Created by CY on 2018/2/8.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoInfoModel.h"

@interface XMSingleton : NSObject
/** 当前摄像头的信息 */
@property (nonatomic) VideoInfoModel *vInfo;

@property (nonatomic, assign) int channelNum;

@property (nonatomic, copy) NSString *deviceSn;

+ (XMSingleton *)sharedXM;

@end
