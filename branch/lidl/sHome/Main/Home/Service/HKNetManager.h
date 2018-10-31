//
//  HKNetManager.h
//  sHome
//
//  Created by CY on 2017/11/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "HKBaseNetManager.h"
#import "WarningModel.h"

@interface HKNetManager : HKBaseNetManager

+ (id)getWarningsWithDevTid:(NSString *)devTid andPage:(NSInteger)page handler:(void(^)(NSArray<WarningModel *> *parseArray, BOOL isLast, NSError *error))handler;

+ (id)clearAllWarningsWithDevTid:(NSString *)devTid ctrlKey:(NSString *)ctrlKey handler:(void(^)(NSError *error))handler;

@end
