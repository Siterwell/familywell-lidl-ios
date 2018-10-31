//
//  TimerSceneHelp.m
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "TimerSceneHelp.h"
#import "TimeSceneModel.h"
#import "TimeScenedDataBase.h"
#import "BatterHelp.h"

@implementation TimerSceneHelp

+ (NSString *)getSceneTime:(NSString *)timerId timerOn:(NSString *)timerOn SceneId:(NSString *)sceneid TimerWeek:(NSString *)week TimerH:Hour TimerM:Minute{

    NSString *time = @"";
    int timeLength = 2;
    
    //自定义编号
    if (!timerId) {
        NSMutableArray *array = [[TimeScenedDataBase sharedDataBase] selectTimerScene];

//        while (YES) {
//            if (![self isAddSceneId:time_id]) {
//                time_id = [NSString stringWithFormat:@"%d",[time_id intValue] + 1];
//            }else{
//                break;
//            }
//        }
        
        int maxId = 0;
        
        for (TimeSceneModel *model in array) {
            
            if ([model.timer_id intValue] > maxId) {
                maxId = [model.timer_id intValue];
            }
        }
        
        NSString *time_id = [NSString stringWithFormat:@"%d",maxId + 1];
        
        for (int i = 0 ; i < maxId; i ++ ) {
            
            if ([[TimeScenedDataBase sharedDataBase] selectTimerSceneByTimerId:[NSString stringWithFormat:@"%d",i]].count == 0) {
                time_id = [NSString stringWithFormat:@"%d",i];
                break;
            }
        }

        time = [BatterHelp gethexBybinary:[time_id intValue]];
        
    }else{
        time = [BatterHelp gethexBybinary:[timerId intValue]];
    }
    if (time.length == 1) {
        time = [@"0" stringByAppendingString:time];
    }
    timeLength += 1;
    
    //使能
    time = [time stringByAppendingString:timerOn];
    timeLength += 1;
    
    //情景模式
    time = [time stringByAppendingString:sceneid];
    timeLength += 1;
    
    //周次
    time = [time stringByAppendingString:[week length] < 2 ? [NSString stringWithFormat:@"0%@", week]: week];
    timeLength += 1;
    
    //时间
    NSString *Hhex = [BatterHelp gethexBybinary:[Hour intValue]];
    NSString *Mhex = [BatterHelp gethexBybinary:[Minute intValue]];
    NSString *hm = [NSString stringWithFormat:@"%@%@",[Hhex length] < 2?[NSString stringWithFormat:@"0%@",Hhex]:Hhex,[Mhex length] < 2?[NSString stringWithFormat:@"0%@",Mhex]:Mhex];
    time = [time stringByAppendingString:hm];
    timeLength += 1;
    
    //cRC
    time = [time stringByAppendingString:[BatterHelp getTimerSceneCRCCode:time]];
    timeLength += 1;
    
//    //设置长度
//    NSString *topString = [BatterHelp gethexBybinary:timeLength];
//    if (topString.length < 4) {
//        for (int i = 0; i < 4 - [BatterHelp gethexBybinary:timeLength].length; i++) {
//            topString = [@"0" stringByAppendingString:topString];
//        }
//    }
//    time = [topString stringByAppendingString:time];
    
    return time;
}

+ (BOOL)isAddSceneId:(NSString *)timerId{
    NSMutableArray *array = [[TimeScenedDataBase sharedDataBase] selectTimerScene];
    for (TimeSceneModel *model in array) {
        if ([model.timer_id isEqualToString:timerId]) {
            return NO;
        }
    }
    return YES;
}

@end
