//
//  Helper.h
//  
//
//  Created by wcq on 14/11/5.
//  Copyright (c) 2014年 wcq. All rights reserved.
//

#ifndef SDKDemo_Helper_h
#define SDKDemo_Helper_h
#import <UIKit/UIKit.h>
#import "NSUserDefaults+Extention.h"

// 当前系统版本
#define iOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
// 当前设备屏幕的宽高
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define INFO_BAR_HEIGHT 20
#define TOP_BAR_HEIGHT [GView topBarHeight]
#define TOP_HEIGHT ([GView topBarHeight] + INFO_BAR_HEIGHT)
#define TEXT_FIELD_HEIGHT 50
#define ITEM_SIDE_WIDTH 20
#define ITEM_ITEM_Y 5
#define ITEM_ITEM_Y_B 15
#define LABEL_HEIGH 20

#define BUTTON_TARGET(button,selectorName) [button addTarget:self action:@selector(selectorName:) forControlEvents:UIControlEventTouchUpInside]
#define BUTTON_TARGET_DOWN(button,selectorName) [button addTarget:self action:@selector(selectorName:) forControlEvents:UIControlEventTouchDown]

@interface GView : NSObject
+(int)topBarHeight;
+(UITextField *)newTextField:(UIViewController *)parent top:(int *)nTop tip:(NSString *)tip;
+(UITextField *)newTextField:(UIViewController *)parent top:(int *)nTop text:(NSString *)text tip:(NSString *)tip;
+(UIButton *)newButton:(UIViewController *)parent top:(int *)nTop title:(NSString *)title action:(SEL)action;
+(UILabel *)newLabel:(UIViewController *)parent top:(int *)nTop text:(NSString *)text;
+(UILabel *)newTip:(UIViewController *)parent top:(int *)nTop text:(NSString *)text;
@end

@interface UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size;
@end

#endif
