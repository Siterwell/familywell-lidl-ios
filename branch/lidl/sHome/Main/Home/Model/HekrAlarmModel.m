//
//  HekrAlarmModel.m
//  sHome
//
//  Created by shaop on 2017/4/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "HekrAlarmModel.h"
#import "TimeHelper.h"
#import "BatterHelp.h"
#import "DeviceDataBase.h"
#import "SceneDataBase.h"

@implementation HekrAlarmModel

- (NSArray *)getTableDataSource{
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    dic = [dic objectForKey:@"names"];
    if (self.content) {
        NSMutableArray *array = [NSMutableArray array];//日期
        NSMutableArray *dayArray = [[NSMutableArray alloc] init];//具体
        for (int i = 0; i<self.content.count; i++) {
            
            HekrAlarmContent *content = self.content[i];

            NSString *type = [content.data.answer_content substringWithRange:NSMakeRange(4, 2)];
           
            NSString *msg = @"";
            
            if ([type isEqualToString:@"AC"]) {
                NSString *sid = [content.data.answer_content substringWithRange:NSMakeRange(6, 2)];
                int mid = (int)strtoul([sid UTF8String],0,16);
                
                SceneModel *model = [[SceneDataBase sharedDataBase] selectScene:[NSString stringWithFormat:@"%d",mid]];
                if (model.scene_name) {
                    msg = [NSString stringWithFormat:@"    %@ %@",model.scene_name,NSLocalizedString(@"情景触发",nil)];
                }else{
                    msg = [NSString stringWithFormat:@"    %@%d %@",NSLocalizedString(@"情景",nil),mid,NSLocalizedString(@"触发",nil)];
                }
                
            }else
            {
                NSString *sid = [content.data.answer_content substringWithRange:NSMakeRange(6, 4)];

                int mid = (int)strtoul([sid UTF8String],0,16);

                ItemData *data = [[DeviceDataBase sharedDataBase] selectDevice:[NSString stringWithFormat:@"%d",mid]];
                if (!data) {
                    NSString *deviceCode = [content.data.answer_content substringWithRange:NSMakeRange(11, 3)];
                    NSString *deviceName = [dic objectForKey:deviceCode];
                    msg = [NSString stringWithFormat:@"    %@ %d %@",NSLocalizedString(deviceName, nil), mid, NSLocalizedString(@"报警", nil)];

                }else{
                    

                    

                    NSString *content;
                    if([data.customTitle isEqualToString:@""]){
                        content = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(data.title, nil),data.devID];
                    }else{
                        content = data.customTitle;
                    }
                    msg = [NSString stringWithFormat:@"    %@ %@",content,NSLocalizedString(@"报警", nil)];
                }
            }
            
            msg = [[TimeHelper TimestampToMinute:[content.reportTime substringToIndex:10]] stringByAppendingString:msg];
            
            
            if (i != 0) {
                HekrAlarmContent *lastContent = self.content[i - 1];
                NSString *time1 = [TimeHelper TimestampToDay:[lastContent.reportTime substringToIndex:10]];
                NSString *time2 = [TimeHelper TimestampToDay:[content.reportTime substringToIndex:10]];
                if (![time1 isEqualToString:time2] && dayArray.count>0) {
                    [array addObject:dayArray];
                    dayArray = [[NSMutableArray alloc] init];
                }
            }
            
            [dayArray addObject:msg];
        }
        if (dayArray.count>0) {
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//            for (NSString *str in dayArray) {
//                [dic setValue:str forKey:str];
//            }
//            [dayArray removeAllObjects];
//            [dayArray addObjectsFromArray:[dic allKeys]];
//            
//            [array addObject:dayArray];
            
            NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
            for (unsigned i = 0; i < [dayArray count]; i++){
                if ([categoryArray containsObject:[dayArray objectAtIndex:i]] == NO){
                    [categoryArray addObject:[dayArray objectAtIndex:i]];
                }
            }
            [dayArray removeAllObjects];
            [dayArray addObjectsFromArray:categoryArray];
            [array addObject:dayArray];
        }
        
        return [array copy];
    }else{
        return nil;
    }
}

- (NSArray *)getTableHeaderDataSource{
    
    if (self.content) {
        NSMutableArray *array = [NSMutableArray array];//日期
        for (int i = 0; i<self.content.count; i++) {
            
            HekrAlarmContent *content = self.content[i];
            
            if (array.count != 0) {
                HekrAlarmContent *lastContent = self.content[i - 1];
                NSString *time1 = [TimeHelper TimestampToDay:[lastContent.reportTime substringToIndex:10]];
                NSString *time2 = [TimeHelper TimestampToDay:[content.reportTime substringToIndex:10]];
                if (![time1 isEqualToString:time2]) {
                    [array addObject:time2];
                }
            }else{
                NSString *time2 = [TimeHelper TimestampToDay:[content.reportTime substringToIndex:10]];
                [array addObject:time2];
            }
            
        }
        
        return [array copy];
    }else{
        return nil;
    }
}

- (NSArray<Ignore> *)getTableHeaderDataSource:(NSString *)deviceID{
    
    if (self.content) {
        NSMutableArray *array = [NSMutableArray array];//日期
        for (int i = 0; i<self.content.count; i++) {
            
            HekrAlarmContent *content = self.content[i];
            NSString *type = [content.data.answer_content substringWithRange:NSMakeRange(4, 2)];
            NSString *sid = [content.data.answer_content substringWithRange:NSMakeRange(6, 4)];
            if(![type isEqualToString:@"AC"]) {
                int mid = (int)strtoul([sid UTF8String],0,16);
                
                ItemData *data = [[DeviceDataBase sharedDataBase] selectDevice:[NSString stringWithFormat:@"%d",mid]];
                if (!data || ![data.devID isEqualToString:deviceID]) {
                    continue;
                }else{
                }
            }else{
                continue;
            }
            
            if (array.count != 0) {
                HekrAlarmContent *lastContent = self.content[i - 1];
                NSString *time1 = [TimeHelper TimestampToDay:[lastContent.reportTime substringToIndex:10]];
                NSString *time2 = [TimeHelper TimestampToDay:[content.reportTime substringToIndex:10]];
                if (![time1 isEqualToString:time2]) {
                    [array addObject:time2];
                }
            }else{
                NSString *time2 = [TimeHelper TimestampToDay:[content.reportTime substringToIndex:10]];
                [array addObject:time2];
            }
            
        }
        
        return [array copy];
    }else{
        return nil;
    }
}

- (NSArray<Ignore> *)getTableDataSource:(NSString *) deviceID{
    
    
    if (self.content) {
        NSMutableArray *array = [NSMutableArray array];//日期
        NSMutableArray *dayArray = [[NSMutableArray alloc] init];//具体
        for (int i = 0; i<self.content.count; i++) {
            
            HekrAlarmContent *content = self.content[i];
            
            NSString *type = [content.data.answer_content substringWithRange:NSMakeRange(4, 2)];
            NSString *sid = [content.data.answer_content substringWithRange:NSMakeRange(6, 4)];
            NSString *msg = @"";
            
            if (![type isEqualToString:@"AC"]) {
                int mid = (int)strtoul([sid UTF8String],0,16);
                
                ItemData *data = [[DeviceDataBase sharedDataBase] selectDevice:[NSString stringWithFormat:@"%d",mid]];
                if (!data || ![data.devID isEqualToString:deviceID]) {
                    continue;
                }else{
                    NSString *content;
                    if([data.customTitle isEqualToString:@""]){
                        content = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(data.title, nil),data.devID];
                    }else{
                        content = data.customTitle;
                    }
                    msg = [NSString stringWithFormat:@"    %@ %@",content,NSLocalizedString(@"报警", nil)];
                }
            }else{
                continue;
            }
            
            msg = [[TimeHelper TimestampToMinute:[content.reportTime substringToIndex:10]] stringByAppendingString:msg];
            
            
            if (i != 0) {
                HekrAlarmContent *lastContent = self.content[i - 1];
                NSString *time1 = [TimeHelper TimestampToDay:[lastContent.reportTime substringToIndex:10]];
                NSString *time2 = [TimeHelper TimestampToDay:[content.reportTime substringToIndex:10]];
                if (![time1 isEqualToString:time2] && dayArray.count>0) {
                    [array addObject:dayArray];
                    dayArray = [[NSMutableArray alloc] init];
                }
            }
            
            [dayArray addObject:msg];
        }
        if (dayArray.count>1) {
            [array addObject:dayArray];
        }
        
        return [array copy];
    }else{
        return nil;
    }
}

@end

@implementation HekrAlarmContent

@end

@implementation HekrAlarmContentData

@end
