//
//  BaseService.m
//  MobileProject
//
//  Created by shaop on 16/8/16.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseRequestService.h"

@implementation BaseRequestService


//公共头部设置
- (NSDictionary *)requestHeaderFieldValueDictionary
{
    NSDictionary *headerDictionary=@{@"platform":@"ios",
                                     @"Accept":@"application/json",
                                     @"Content-Type":@"application/json"
                                     };
    return headerDictionary;
}

@end
