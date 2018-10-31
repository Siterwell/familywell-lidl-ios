//
//  MemoryConfigView.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/22.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoryConfigView : UIView
@property (nonatomic, strong) UITableView *memoryTableView;//显示数据的表视图
@property (nonatomic, strong) UISegmentedControl *OverWriteSegment;//录像满时的处理方式
@property (nonatomic, strong) UIButton *formatterButton;//格式化

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic) UIButton *stopBtn;
@property (nonatomic) UIButton *circleBtn;

@property (nonatomic, assign) CGFloat occupation;

@end
