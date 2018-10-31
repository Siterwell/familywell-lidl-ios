//
//  NSSDKObject.h
//  FunSDKDemo
//
//  Created by zyj on 2017/3/2.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunDelegate.h"
#import "FunSDK/FunSDK.h"

#define SDK_HANDLE [self getSDKHandle]
@interface NSSDKObject : NSObject<FunDelegate>
@property (atomic, copy) NSString *device;
@property (atomic, assign) int channel;

- (void)OnFunSDKResult:(NSSDKObject*)sender MsgId:(int)msgId Param1:(int)param1 Param2:(int)param2 Param3:(int)param3 String:(const char *)szStr Data:(char *)pData DataLen:(int)length Seq:(int)seq;

-(void)setUserData:(id)userData;
-(id)getUserData;

-(int)getSDKHandle;
-(void)releaseSDKHandle;
@end
