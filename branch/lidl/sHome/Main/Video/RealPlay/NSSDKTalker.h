//
//  NSSDKTalker.h
//  FunSDKDemo
//
//  Created by zyj on 2017/3/4.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKObject.h"

typedef enum ETALKER_STATE{
    ETALKER_STATE_NONE,
    ETALKER_STATE_READYING,
    ETALKER_STATE_TALKING,
    ETALKER_STATE_LISTENING,
    ETALKER_STATE_STOP,
}ETALKER_STATE;

@class NSSDKTalker;
@protocol NSSDKTalkerDelegate <NSObject>
@required
-(void)OnTalkerStateChannage:(NSSDKTalker *)sender Result:(int)result State:(ETALKER_STATE)state;
@end

@interface NSSDKTalker : NSSDKObject
@property (nonatomic, weak, nullable) id <NSSDKTalkerDelegate> delegate;
@property (nonatomic, assign) ETALKER_STATE state;
@property (nonatomic, assign) FUN_HANDLE hTalk;
-(void)startTalker;
-(void)startListening;
-(void)stop;
@end
