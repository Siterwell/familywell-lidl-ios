//
//  SceneConditionVC.m
//  sHome
//
//  Created by shaop on 2017/1/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SceneConditionVC.h"
#import "ConditionCell.h"

@interface SceneConditionVC ()
@property (nonatomic , strong) UIButton *lastButton;
@end

@implementation SceneConditionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"选择执行条件", nil);
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.delegate) {
        [self.delegate sendNext:@(_selectType)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01;
    }
    else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 70;
    }else{
        return 175;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    NSString *str;
    if (section == 0) {
        str = NSLocalizedString(@"如果你添加了一个或者多个启动条件时，达到其中任何一个条件都会执行任务。", nil);
    }else{
        str = NSLocalizedString(@"如果添加了多个启动条件时，必须达到所有条件才会执行任务；\n 如果只添加了一个启动条件，此时满足该条件即执行任务；\n如果您还未理解此选项功能，选择默认选项或者咨询我们。", nil);
    }
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.text = str;
    label.numberOfLines = 0;
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(13);
        make.right.equalTo(view.mas_right).offset(-13);
        make.centerY.equalTo(view);
    }];
    
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConditionCell" forIndexPath:indexPath];
    [cell.selectBtn setImage:[UIImage imageNamed:@"noselect_icon"] forState:UIControlStateNormal];
    [cell.selectBtn setImage:[UIImage imageNamed:@"select_yellow_icon"] forState:UIControlStateSelected];

    if (indexPath.section == 0) {
        cell.titleLabel.text = NSLocalizedString(@"满足任一条件即触发", nil);
    }else{
        cell.titleLabel.text = NSLocalizedString(@"满足所有条件执行", nil);
    }
    
    if (indexPath.section == _selectType) {
        [cell.selectBtn setSelected:YES];
        _lastButton = cell.selectBtn;
    }else{
        [cell.selectBtn setSelected:NO];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConditionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.selectBtn.isSelected) {
        [cell.selectBtn setSelected:YES];
        [_lastButton setSelected:NO];
        _lastButton = cell.selectBtn;
        _selectType = indexPath.section;
    }
}


@end
