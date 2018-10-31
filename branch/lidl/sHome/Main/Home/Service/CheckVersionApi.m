//
//  CheckVersionApi.m
//  sHome
//
//  Created by shaop on 2017/4/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "CheckVersionApi.h"

@implementation CheckVersionApi

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

-(SERVERCENTER_TYPE)centerType
{
    return UPDATEVERSION_SERVERCENTER;
}

@end
