//
//  FunDelegate.h
//  FunSDKDemo
//
//  Created by liuguifang on 16/5/10.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import <Foundation/Foundation.h>

//所有需要接收funsdk 消息的类均需要实现该协议中的 OnFunSDKResult 方法
@protocol FunDelegate <NSObject>

@required
-(void)OnFunSDKResult:(NSNumber *) pParam;

@end

