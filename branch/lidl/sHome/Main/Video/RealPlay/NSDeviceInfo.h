//
//  NSDeviceInfo.h
//  FunSDKDemo
//
//  Created by zyj on 2017/2/23.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunSDK/FunSDK.h"

@interface NSDeviceInfo : NSObject
@property (nonatomic, copy) NSString* sn;       // Device sn
@property (nonatomic, copy) NSString* userName; // Device Admin
@property (nonatomic, copy) NSString* password; // Device Password
@property (nonatomic,assign)int type; // Device type

@property (nonatomic, copy) NSString* name;     // LocalName(device customName)
@property (nonatomic,assign) int nNetState;            // Device net states
#pragma mark 鱼眼 编码类型 和 场景
@property (nonatomic, assign) int iCodecType;//编解码类型
@property (nonatomic, assign) int iSceneType;//场景
@property (nonatomic, assign) int centerOffSetX;
@property (nonatomic, assign) int centerOffSetY;
@property (nonatomic, assign) int radius;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

+(NSDeviceInfo *)NewDeviceInfo:(NSString *)sn andName:(NSString *)name andUserName:(NSString *)userName andPassword:(NSString *)password;
+(NSDeviceInfo *)NewDeviceInfo:(NSString *)sn andName:(NSString *)name andUserName:(NSString *)userName andPassword:(NSString *)password andType:(int)type;
+(NSDeviceInfo *)NewDeviceInfo:(NSString *)sn andName:(NSString *)name;
-(NSArray *)GetChannelNames;
-(NSString *)GetChannelNameAt:(NSInteger)index;
-(NSInteger)GetChannelCount;
-(void)SetChannelNames:(NSMutableArray *)names;
@end

