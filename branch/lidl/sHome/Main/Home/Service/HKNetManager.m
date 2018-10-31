//
//  HKNetManager.m
//  sHome
//
//  Created by CY on 2017/11/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "HKNetManager.h"

#define kWarningPath  @"/api/v1/notification?type=WARNING"

#define kClearWarningsPath  @"/api/v1/notification"

@implementation HKNetManager

+ (id)clearAllWarningsWithDevTid:(NSString *)devTid ctrlKey:(NSString *)ctrlKey handler:(void (^)(NSError *))handler {
    NSDictionary *params = @{@"devTid": devTid,
                             @"ctrlKey": ctrlKey,
                             @"type": @"WARNING"
                             };
    return [self DELETE:[NSString stringWithFormat:@"%@%@",(ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]),kClearWarningsPath] parameters:params completionHandler:^(id responseObj, NSError *error) {
        !handler ?: handler(error);
    }];
}

+ (id)getWarningsWithDevTid:(NSString *)devTid andPage:(NSInteger)page handler:(void (^)(NSArray<WarningModel *> *, BOOL, NSError *))handler {
    NSDictionary *params = @{@"devTid": devTid,
                             @"page"  : @(page),
                             @"size"  : @20  };
    return [self GET:[NSString stringWithFormat:@"%@%@",(ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]),kWarningPath] parameters:params completionHandler:^(id responseObj, NSError *error) {
        BOOL last = [responseObj[@"last"] boolValue];
        NSArray *array = responseObj[@"content"];
        NSMutableArray *pArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WarningModel *model = [[WarningModel alloc] init];
            model.content = obj[@"content"];
            model.reportTime = obj[@"reportTime"];
            model.subject = obj[@"subject"];
            model.answer_content = obj[@"data"][@"answer_content"];
            [pArray addObject:model];
        }];
        !handler ?: handler(pArray, last, error);
    }];
}

@end
