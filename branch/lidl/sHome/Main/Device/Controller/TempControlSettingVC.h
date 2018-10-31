//
//  TempControlSettingVC.h
//  sHome
//
//  Created by TracyHenry on 2018/9/3.
//  Copyright © 2018年 shaop. All rights reserved.
//

#ifndef TempControlSettingVC_h
#define TempControlSettingVC_h
#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "ItemData.h"

@interface TempControlSettingVC : BaseVC
@property (nonatomic,assign) NSInteger workmode_index;
@property (nonatomic, strong) ItemData *data;
@end

#endif /* TempControlSettingVC_h */
