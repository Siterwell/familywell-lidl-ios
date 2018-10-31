//
//  TimeScenedDataBase.h
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeSceneModel.h"

@interface TimeScenedDataBase : NSObject

+ (instancetype)sharedDataBase;

- (NSMutableArray *)selectTimerScene;

- (NSMutableArray *)selectTimerSceneOrderById;

- (NSMutableArray *)selectTimerSceneByTimerId:(NSString *)timerId;

- (void)updateTimerScene:(TimeSceneModel *)model;

- (BOOL)deletTimerScene:(NSString *)timerId;

- (void)deletAllTimerScene;


@end
