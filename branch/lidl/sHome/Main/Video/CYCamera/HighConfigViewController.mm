//
//  HighConfigViewController.m
//  sHome
//
//  Created by CY on 2018/2/10.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "HighConfigViewController.h"

#import "RecordConfigViewController.h"
#import "AlarmConfigViewController.h"
#import "PictureConfigViewController.h"
//#import "SeniorConfigVc.h"
#import "XMSingleton.h"

#import "AlarmConfigVc.h"

@interface HighConfigViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *titles;

@end

@implementation HighConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"高级设置", nil);
    self.view.backgroundColor = RGB(239, 239, 239);
    self.titles = @[NSLocalizedString(@"录像配置", nil)];
//    self.titles = @[NSLocalizedString(@"录像配置", nil),  NSLocalizedString(@"报警配置", nil), NSLocalizedString(@"图像配置", nil), NSLocalizedString(@"其他配置", nil)];
    [self setupHighConfigUI];
}

- (void)setupHighConfigUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.tableFooterView = [UIView new];
    table.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = nil;
    vc.title = self.titles[indexPath.row];
    if (indexPath.row == 0) {
        RecordConfigViewController *recordVc = [[RecordConfigViewController alloc] init];
        recordVc.channelNum = [XMSingleton sharedXM].channelNum;
        recordVc.deviceSN = [XMSingleton sharedXM].deviceSn;
        vc = recordVc;
    }
    else if (indexPath.row == 1) {
        AlarmConfigViewController *alarmVc = [[AlarmConfigViewController alloc] init];
        alarmVc.channelNum = [XMSingleton sharedXM].channelNum;
        alarmVc.deviceSN = [XMSingleton sharedXM].deviceSn;
//        AlarmConfigVc *alarmVc = [[AlarmConfigVc alloc] init];
        
        vc = alarmVc;
    }
    else if (indexPath.row == 2) {
        vc = [[PictureConfigViewController alloc] init];
    }
    else if (indexPath.row == 3) {
//        vc = [[SeniorConfigVc alloc] init];
        vc = [[PictureConfigViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:NO];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 2 || indexPath.row == 3) {
//        return 0;
//    }
//    return 44;
//}

@end
