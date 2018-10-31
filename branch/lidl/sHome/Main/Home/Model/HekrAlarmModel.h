//
//  HekrAlarmModel.h
//  sHome
//
//  Created by shaop on 2017/4/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol HekrAlarmContent;

@class HekrAlarmContentData;

@interface HekrAlarmModel : JSONModel

@property (nonatomic, strong) NSArray<HekrAlarmContent> *content;

- (NSArray<Ignore> *)getTableHeaderDataSource;
- (NSArray<Ignore> *)getTableDataSource;

- (NSArray<Ignore> *)getTableHeaderDataSource:(NSString *) deviceID;
- (NSArray<Ignore> *)getTableDataSource:(NSString *) deviceID;
@end

@interface HekrAlarmContent : JSONModel

@property (nonatomic, strong) HekrAlarmContentData *data;

@property (nonatomic, strong) NSString *reportTime;

@end

@interface HekrAlarmContentData : JSONModel

@property (nonatomic, strong) NSString *answer_content;

@end
