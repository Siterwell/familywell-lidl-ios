//
//  TimeSwitchCell.h
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWSwitch.h"
#import "TimeSceneModel.h"

@interface TimeSwitchCell : UITableViewCell

@property (nonatomic,strong) HWSwitch *hwSwitch;
@property (nonatomic,strong) TimeSceneModel *timeModel;

@end
