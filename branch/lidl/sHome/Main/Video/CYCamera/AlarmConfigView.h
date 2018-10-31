//
//  AlarmConfigView.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/27.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmConfigCell.h"

@interface AlarmConfigView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *alarmTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic) int level;

@property (nonatomic, strong) AlarmConfigCell *alarmCell00;
@property (nonatomic, strong) AlarmConfigCell *alarmCell01;
@property (nonatomic, strong) AlarmConfigCell *alarmCell02;
@property (nonatomic, strong) AlarmConfigCell *alarmCell03;
@property (nonatomic, strong) AlarmConfigCell *alarmCell10;
@property (nonatomic, strong) AlarmConfigCell *alarmCell11;
@property (nonatomic, strong) AlarmConfigCell *alarmCell12;
@property (nonatomic, strong) AlarmConfigCell *alarmCell13;
@property (nonatomic, strong) AlarmConfigCell *alarmCell20;

@property (nonatomic, copy) void(^sensitivityBlock)(int sensitivity);


@end
