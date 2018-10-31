//
//  NSSDKObject.m
//  FunSDKDemo
//
//  Created by zyj on 2017/3/2.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKObject.h"
#import "FunSDK/ObjMsgHandle.h"

@interface NSSDKObject()<FunDelegate>{
    id _userData;
    CObjMsgHandle _msgHandle;
}
@end

@implementation NSSDKObject
-(void)setUserData:(id)userData{
    _userData = userData;
}

-(id)getUserData{
    return _userData;
}


- (void)OnFunSDKResult:(NSSDKObject*)sender MsgId:(int)msgId Param1:(int)param1 Param2:(int)param2 Param3:(int)param3 String:(const char *)szStr Data:(char *)pData DataLen:(int)length Seq:(int)seq{
    
}

- (void)OnFunSDKResult:(NSNumber*)pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent* msg = (MsgContent*)nAddr;
    [self OnFunSDKResult:self MsgId:msg->id Param1:msg->param1 Param2:msg->param2 Param3:msg->param3 String:msg->szStr Data:msg->pObject DataLen:msg->nDataLen Seq:msg->seq];
}

-(int)getSDKHandle{
    return _msgHandle.GetId(self);
}

-(void)releaseSDKHandle{
    _msgHandle.UnInit();
}
@end
