//
//  TimerSceneHelp.h
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerSceneHelp : NSObject

+ (NSString *)getSceneTime:(NSString *)timerId timerOn:(NSString *)timerOn SceneId:(NSString *)sceneid TimerWeek:(NSString *)week TimerH:Hour TimerM:Minute;

@end
