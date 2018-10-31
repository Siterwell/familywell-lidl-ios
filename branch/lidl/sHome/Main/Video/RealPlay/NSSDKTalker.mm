//
//  NSSDKTalker.m
//  FunSDKDemo
//
//  Created by zyj on 2017/3/4.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKTalker.h"
#import "Recode.h"
#import "GUI.h"
@interface NSSDKTalker ()
@property (nonatomic, strong) Recode *recde;
@property (nonatomic, assign) BOOL bTalking;
@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) int nResult;
@property (nonatomic, assign) int nSeq;
@end


@implementation NSSDKTalker
-(id)init{
    self = [super init];
    if (self) {
        self.bTalking = NO;
        self.isReady = NO;
        self.state = ETALKER_STATE_NONE;
        self.hTalk = 0;
        self.nResult = 0;
        self.nSeq = 0;
    }
    return self;
}

-(void)onStateChannelWithResult:(int)result{
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(OnTalkerStateChannage:Result:State:)]) {
        [self.delegate OnTalkerStateChannage:self Result:result State:self.state];
    }
    
}

-(void)startTalker{
    self.bTalking = YES;
    if (_recde == nil) {
        _recde = [[Recode alloc] init];
        [self.recde startRecode:self.device];
    }
    if (self.hTalk == 0) {
        self.nSeq++;
        self.hTalk = FUN_DevStarTalk(SDK_HANDLE, SZSTR(self.device), self.nSeq);
        self.state = ETALKER_STATE_READYING;
    }
    self.recde.sendData = self.isReady;
    [self onStateChannelWithResult:0];
}

-(void)startListening{
    if (_recde == nil){
        return;
    }
    self.recde.sendData = NO;
}

-(void)stop{
    if (_recde == nil){
        return;
    }
    [_recde stopRecode];
    self.bTalking = NO;
    FUN_DevStopTalk(self.hTalk);
    self.hTalk = 0;
    self.nSeq++;
    self.state = ETALKER_STATE_STOP;
    [self onStateChannelWithResult:0];
}

- (void)OnFunSDKResult:(NSSDKObject*)sender MsgId:(int)msgId Param1:(int)param1 Param2:(int)param2 Param3:(int)param3 String:(const char *)szStr Data:(char *)pData DataLen:(int)length Seq:(int)seq{
    if (EMSG_DEV_START_TALK == msgId) {
        //        if (self.nSeq != seq) {
        //            return;
        //        }
        
        if (self.state == ETALKER_STATE_STOP) {
            return;
        }
        
        if (param1 < 0) {
            self.nResult = param1;
            [self stop];
        } else {
            self.isReady = YES;
            self.state = _bTalking ? ETALKER_STATE_TALKING : ETALKER_STATE_LISTENING;
            self.recde.sendData = self.bTalking;
        }
        
        [self onStateChannelWithResult:param1];
    }
}
@end
