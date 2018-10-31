//
//  TimeSceneModel.m
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "TimeSceneModel.h"
#import "BatterHelp.h"
#import "SystemSceneDataBase.h"

@implementation TimeSceneModel

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    
    
    if (self = [super initWithDictionary:dict error:err]) {

        if (self.time.length >= 16) {
            self.timer_id = [self getTimerIdFromTime];
            self.timer_on = [self getTimerOnFromTime];
            self.timeWHMS = [self getTimerWHMSFromTime];
            self.sence_group = [self getTimerSenceGroupFromTime];
            self.sence_name = [self getTimerSenceNameBySenceGroup];
            self.timer_crc = [self getTimerCrcFromTime];
        }
    }
    return self;
}

- (void)creatModel{
    self.timer_on = [self getTimerOnFromTime];
    self.timeWHMS = [self getTimerWHMSFromTime];
    self.sence_group = [self getTimerSenceGroupFromTime];
    self.sence_name = [self getTimerSenceNameBySenceGroup];
    self.timer_crc = [self getTimerCrcFromTime];

}

- (NSString *)getTimerIdFromTime{
    NSString *timerId = [self.time substringWithRange:NSMakeRange(0, 2)];
    return timerId;
}

- (NSString *)getTimerOnFromTime{
    NSString *timerOn = [self.time substringWithRange:NSMakeRange(2, 2)];
    return timerOn;
}

- (NSString *)getTimerSenceGroupFromTime{
    NSString *senceGroup = [self.time substringWithRange:NSMakeRange(4, 2)];
    return senceGroup;
}

- (NSString *)getTimerSenceNameBySenceGroup{
    NSString *senceGroup = [self.time substringWithRange:NSMakeRange(4, 2)];
    NSMutableArray *systemSceneListArray = [[SystemSceneDataBase sharedDataBase] selectScene];
    SystemSceneModel *model = systemSceneListArray[[senceGroup integerValue]];
    return model.scene_name;
}

- (TimeModel *)getTimerWHMSFromTime{
    
    TimeModel *timeMd = [[TimeModel alloc] init];
    NSString *timeW = [self.time substringWithRange:NSMakeRange(6, 2)];
    timeW = [BatterHelp getBinaryByhex:timeW];
    
    NSString *timeH = [self.time substringWithRange:NSMakeRange(8, 2)];
    NSString *timeM = [self.time substringWithRange:NSMakeRange(10, 2)];
    
    timeMd.week = timeW;
    timeMd.Hour = [[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeH]] length] < 2?[NSString stringWithFormat:@"0%@",[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeH]] ]:[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeH]];
    timeMd.Minute = [[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeM]] length] < 2?[NSString stringWithFormat:@"0%@",[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeM]] ]:[NSString stringWithFormat:@"%@",[BatterHelp numberHexString:timeM]];;

    return timeMd;
}

- (NSString *)getTimerCrcFromTime{
    
    NSString *timeContext = [self.time substringToIndex:self.time.length - 4];
//    NSString *crc = [timeContext stringByAppendingString:[BatterHelp getTimerSceneCRCCode:timeContext]];
    NSString *crc = [BatterHelp getTimerSceneCRCCode:timeContext];
    
    return crc;
}


@end
