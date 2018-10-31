//
//  NSSDKPTZContoller.h
//  FunSDKDemo
//
//  Created by zyj on 2017/3/4.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKObject.h"

@interface NSSDKPTZContoller : NSSDKObject

-(int)PTZControl:(int)nPTZCommand IsStop:(BOOL)bStop Speed:(int)speed;
@end
