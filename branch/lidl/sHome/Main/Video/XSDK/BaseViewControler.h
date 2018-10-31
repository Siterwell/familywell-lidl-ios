//
//  FunBaseObject.h
//
//
//  Created by liuguifang on 16/5/10.
//  Copyright (c) 2016年 xiongmaitech. All rights reserved.
//

//#import <FunSDK/netsdk.h>
#import "GUI.h"
#import "ShowError.h"
#import <UIKit/UIKit.h>

#define SELF [self MsgHandle]
#define AS_HANDLE(x) (__bridge void*) x

@interface BaseViewController : UIViewController
@property (readonly, nonatomic) int hObj;
- (int)MsgHandle;
- (void)CloseHandle;

@end
