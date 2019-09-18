//
//  DeviceWarningListViewController.m
//  sHome
//
//  Created by CY on 2018/2/24.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "DeviceWarningListViewController.h"
#import "HKNetManager.h"
#import "DeviceListModel.h"
#import "WarningModel.h"
#import "SceneModel.h"
#import "SceneDataBase.h"
#import "ItemData.h"
#import "DeviceDataBase.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BatterHelp.h"

@interface DeviceWarningListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource>

@property (nonatomic) UITableView *table;

@property (nonatomic) NSMutableArray<WarningModel *> *warningList;

@property (nonatomic) NSMutableArray<WarningModel *> *deviceWarningList;

@property (nonatomic, assign) NSInteger page;

@end

@implementation DeviceWarningListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self table];
    [self getWarnings];
}

- (void)setupNav {
    self.view.backgroundColor = RGB(239, 239, 239);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sj_list_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    self.navigationItem.title = NSLocalizedString(@"设备告警历史记录", nil);
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.tableFooterView = [UIView new];
        _table.dataSource = self;
        _table.delegate = self;
        _table.emptyDataSetSource = self;
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _table;
}

- (NSMutableArray<WarningModel *> *)warningList {
    if (!_warningList) {
        _warningList = [[NSMutableArray<WarningModel *> alloc] init];
    }
    return _warningList;
}

- (NSMutableArray<WarningModel *> *)deviceWarningList {
    if (!_deviceWarningList) {
        _deviceWarningList = [[NSMutableArray<WarningModel *> alloc] init];
    }
    return _deviceWarningList;
}


- (void)backToHome {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)getWarnings {
    
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if (model ) {
        if(self.page == 0){
            [MBProgressHUD showLoadToView:self.view];
        }
        [HKNetManager getWarningsWithDevTid:model.devTid andPage:self.page handler:^(NSArray<WarningModel *> *parseArray, BOOL isLast, NSError *error) {
            [weakSelf.warningList addObjectsFromArray:parseArray];
            weakSelf.page += 1;
            if (isLast == NO) {
                [weakSelf getWarnings];
            } else if (isLast == YES) {
                
                [weakSelf.warningList enumerateObjectsUsingBlock:^(WarningModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSString *type = [obj.answer_content substringWithRange:NSMakeRange(4, 2)];
                    if([type isEqualToString:@"AD"]){
                        NSString *sid = [obj.answer_content substringWithRange:NSMakeRange(6, 4)];
                        int mid = 0;
                        if (sid) {
                            mid = (int)strtoul([sid UTF8String],0,16);
                        }
                        if(mid== [_dev_id intValue]){
                            [[weakSelf deviceWarningList] addObject:obj];
                        }
                    }
                    
                    
                }];
                
                [weakSelf.table reloadData];
                [MBProgressHUD hideHUDForView:self.view];
            }
            
        }];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceWarningList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (self.deviceWarningList.count != 0) {
        cell.textLabel.text = [TimeHelper TimestampToData:[[self.deviceWarningList[indexPath.row].reportTime stringValue] substringToIndex:10]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    dic = [dic objectForKey:@"names"];
    if (self.deviceWarningList.count < indexPath.row) {
        return cell;
    }
    NSString *msg = @"";
    NSString *sid = [self.deviceWarningList[indexPath.row].answer_content substringWithRange:NSMakeRange(6, 4)];
    int mid = 0;
    if (sid) {
        mid = (int)strtoul([sid UTF8String],0,16);
    }
    
    
    if(mid!=0){
        ItemData *data = [[DeviceDataBase sharedDataBase] selectDevice:[NSString stringWithFormat:@"%d",mid]];
        NSString *deviceCode = [self.deviceWarningList[indexPath.row].answer_content substringWithRange:NSMakeRange(11, 3)];
        NSString *status = [self.deviceWarningList[indexPath.row].answer_content substringWithRange:NSMakeRange(14, 8)];
        NSString *alarm = [WarningModel getAlertWithDevType:deviceCode status:status];
        if (!data) {
            NSString *deviceName = [dic objectForKey:deviceCode];
            
            msg = [NSString stringWithFormat:@"%@ %d %@",NSLocalizedString(deviceName, nil), mid, alarm];
            
        }else{
            
            
            NSString *content;
            if([data.customTitle isEqualToString:@""]){
                content  = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(data.title, nil),data.devID];
            }else{
                content = data.customTitle;
            }
            msg = [NSString stringWithFormat:@"%@ %@",content,alarm];
        }
    }
    
    cell.detailTextLabel.text = msg;
    
    return cell;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"没有数据", nil) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: NetiveColor}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}



@end

