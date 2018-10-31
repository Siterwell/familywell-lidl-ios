//
//  RecordConfigView.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/30.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordConfigView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *configTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UISlider *mainPer_recordSlider;
@property (nonatomic, strong) UISlider *mainRecordLength;

@property (nonatomic, strong) UISlider *subPer_recordSlider;
@property (nonatomic, strong) UISlider *subRecordLength;
@property (nonatomic, assign) BOOL autoEnable;
-(void)setConfig:(void *)pCfgMain andCfg:(void *)pCfgSub;
@property (nonatomic) UIButton *AutoEnableBtn;
@property (nonatomic, copy) void(^recordWayBlock)(const char *way);

@property (nonatomic) const char *recordWay;

@end
