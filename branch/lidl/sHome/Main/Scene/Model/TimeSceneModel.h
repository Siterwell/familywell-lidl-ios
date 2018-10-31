//
//  TimeSceneModel.h
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "JSONModel+DeviceDic.h"
#import "TimeModel.h"

@interface TimeSceneModel : JSONModel

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString<Ignore> *timer_id;
@property (nonatomic, strong) NSString<Ignore> *timer_on;//是否使用
@property (nonatomic, strong) TimeModel<Ignore> *timeWHMS;
@property (nonatomic, strong) NSString<Ignore> *sence_group;
@property (nonatomic, strong) NSString<Ignore> *sence_name;
@property (nonatomic, strong) NSString<Ignore> *timer_crc;

- (void)creatModel;
@end
