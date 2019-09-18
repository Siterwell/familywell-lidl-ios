//
//  PictureConfigView.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/24.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureConfigView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *picConfigTableView;//配置内容表视图  方便后期加数据
@property (nonatomic,strong) UISwitch *picFlipRightLeftSwitch;//图片左右翻转
@property (nonatomic,strong) UISwitch *picFlipUpDownSwitch;//图片左右翻转

@property (nonatomic) UIButton *lrBtn;
@property (nonatomic) UIButton *udBtn;

@property (readonly, nonatomic) int hObj;

@property (nonatomic,assign) int msgHandle;
@property (nonatomic,strong) NSDate *datenow;
@property (strong, nonatomic) void (^click)();
- (void)CloseHandle;

@end
