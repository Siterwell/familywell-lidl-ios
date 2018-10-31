//
//  SelectDateViewVc.h
//  sHome
//
//  Created by Apple on 2017/8/21.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDateViewVc : UIViewController

/**
 *  点击返回日期
 */
@property (nonatomic, copy) void(^selectCalendarBlock)(NSString *date);

@end
