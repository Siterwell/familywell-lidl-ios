//
//  NSSDKPTZContoller.m
//  FunSDKDemo
//
//  Created by zyj on 2017/3/4.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKPTZContoller.h"
#import "GUI.h"
@interface NSSDKPTZContoller ()
@end

@implementation NSSDKPTZContoller
-(int)PTZControl:(int)nPTZCommand IsStop:(BOOL)bStop Speed:(int)speed{
    FUN_DevPTZControl(SDK_HANDLE, SZSTR(self.device), self.channel, nPTZCommand, bStop ? true : false, speed);
    return 0;
}

@end
