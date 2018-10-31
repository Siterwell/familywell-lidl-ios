//
//  XMSingleton.m
//  sHome
//
//  Created by CY on 2018/2/8.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "XMSingleton.h"

@implementation XMSingleton

+ (XMSingleton *)sharedXM {
    static XMSingleton *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[XMSingleton alloc] init];
        }
    });
    return instance;
}



@end
