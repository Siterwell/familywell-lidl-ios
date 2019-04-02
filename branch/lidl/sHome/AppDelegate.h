//
//  AppDelegate.h
//  sHome
//
//  Created by shaop on 2016/12/5.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSafeCategory.h"

extern NSDictionary * ApiMap;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) BOOL shouldShowMore;

+ (int)shouldLoginCheck;
+ (void)enableLoginCheck:(BOOL)enable;

@end

