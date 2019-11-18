//
//  WarningListViewController.m
//  sHome
//
//  Created by CY on 2018/2/24.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "WarningListViewController.h"
#import "HKNetManager.h"
#import "DeviceListModel.h"
#import "WarningModel.h"
#import "SceneModel.h"
#import "SceneDataBase.h"
#import "ItemData.h"
#import "DeviceDataBase.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BatterHelp.h"
#import "EquipmentState.h"

@interface WarningListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource>

@property (nonatomic) UITableView *table;

@property (nonatomic) NSMutableArray<WarningModel *> *warningList;

@property (nonatomic, assign) NSInteger page;

@end

@implementation WarningListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
//    [self setupTable];
    [self table];
    [self getWarnings];
}

- (void)setupNav {
    self.view.backgroundColor = RGB(239, 239, 239);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sj_list_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToHome)];
    self.navigationItem.title = NSLocalizedString(@"设备告警历史记录", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"清空", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clearHistoryWarnings)];
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

//- (void)setupTable {
//    _warningList = [[NSMutableArray alloc] init];
//
//}

- (void)backToHome {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)getWarnings {
    if(self.page == 0){
    [MBProgressHUD showLoadToView:self.view];
    }

    __weak typeof(self) weakSelf = self;
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if (model) {
        [HKNetManager getWarningsWithDevTid:model.devTid andPage:self.page handler:^(NSArray<WarningModel *> *parseArray, BOOL isLast, NSError *error) {
            [weakSelf.warningList addObjectsFromArray:parseArray];
            weakSelf.page += 1;
            if (isLast == NO) {
                [weakSelf getWarnings];
            } else if (isLast == YES) {
                [weakSelf.table reloadData];
                [MBProgressHUD hideHUDForView:self.view];
            }

        }];
    }
}

- (void)clearHistoryWarnings {
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if (model) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"确定删除历史告警记录", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"删除", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [HKNetManager clearAllWarningsWithDevTid:model.devTid ctrlKey:model.ctrlKey handler:^(NSError *error) {
                self.page = 0;
                [self.warningList removeAllObjects];
                [weakSelf getWarnings];
            }];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.warningList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    if (self.warningList.count != 0) {
        cell.textLabel.text = [TimeHelper TimestampToData:[[self.warningList[indexPath.row].reportTime stringValue] substringToIndex:10]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    dic = [dic objectForKey:@"names"];
    if (self.warningList.count < indexPath.row) {
        return cell;
    }
    NSString *type = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(4, 2)];
    NSString *msg = @"";
    if ([type isEqualToString:@"AC"]) {
        NSString *sid = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(6, 2)];
        int mid = (int)strtoul([sid UTF8String],0,16);
        
        SceneModel *model = [[SceneDataBase sharedDataBase] selectScene:[NSString stringWithFormat:@"%d",mid]];
        if (model.scene_name) {
            msg = [NSString stringWithFormat:@"%@ %@",model.scene_name,NSLocalizedString(@"情景触发",nil)];
        }else{
            msg = [NSString stringWithFormat:@"%@%d %@",NSLocalizedString(@"情景",nil),mid,NSLocalizedString(@"触发",nil)];
        }
    } else {
        
        NSString *sid = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(6, 4)];
        int mid = 0;
        if (sid) {
            mid = (int)strtoul([sid UTF8String],0,16);
        }
        //            int mid = (int)strtoul([sid UTF8String],0,16);
        
        if(mid!=0){
            NSString * log_conntent = self.warningList[indexPath.row].answer_content;
            NSLog(@"WarningListViewController > answer_content=%@", log_conntent);
            ItemData *data = [[DeviceDataBase sharedDataBase] selectDevice:[NSString stringWithFormat:@"%d",mid]];
            
            if (22 > log_conntent.length) {
                // To avoid crash
                msg = @"";
            } else {
                NSString *deviceCode = [log_conntent substringWithRange:NSMakeRange(11, 3)];
                NSString *status = [log_conntent substringWithRange:NSMakeRange(14, 8)];
                NSString *alarm = [self getAlertWithDevType:deviceCode status:status];
                NSLog(@"WarningListViewController > deviceCode=%@, status=%@, alarm=%@", deviceCode, status, alarm);
                
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
        }
        else {
            NSString *status = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(14, 8)];
            //市电断开  //市电恢复//电池正常//电池异常
            if([status isEqualToString:@"00000000"]){
                msg = NSLocalizedString(@"市电断开", nil);
                
            }
            else if([status isEqualToString:@"00000001"]){
                msg = NSLocalizedString(@"市电恢复", nil);
            }
            else if([status isEqualToString:@"00000002"]){
                msg = NSLocalizedString(@"电池正常", nil);
            }
            else if([status isEqualToString:@"00000003"]){
                msg = NSLocalizedString(@"电池异常", nil);
            }else if([status isEqualToString:@"00000004"]){
                msg = NSLocalizedString(@"老人可能长时间未移动", nil);
            }else{
                msg = [NSString stringWithFormat:@"%@",NSLocalizedString(@"报警", nil)];
            }
            
        }
    }
    
    cell.detailTextLabel.text = msg;
    
    return cell;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"没有数据", nil) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}

-(NSString *)getAlertWithDevType:(NSString *)type status:(NSString *) statusa{
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    dic = [dic objectForKey:@"names"];
    NSString *battery = [statusa substringWithRange:NSMakeRange(2, 2)];
    NSString *status = [statusa substringWithRange:NSMakeRange(4, 2)];
    if([@"门磁" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TRIGGERED isEqualToString:status]){
             return  NSLocalizedString(@"门打开", nil);
        }else if([STATE_NORMAL isEqualToString:status]){
            if([[BatterHelp numberHexString:battery] integerValue] < 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
            return  NSLocalizedString(@"门关闭", nil);
            }
        }else if([STATE_DOOR_NOT_CLOSED isEqualToString:status]){
            return  NSLocalizedString(@"门没有关", nil);
        }else if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] < 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    } else if([@"SOS按钮" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TRIGGERED isEqualToString:status]){
            return  NSLocalizedString(@"求救", nil);
        }else if([STATE_DOOR_NOT_CLOSED isEqualToString:status] || [@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else if([STATE_NORMAL isEqualToString:status]){
            if([[BatterHelp numberHexString:battery] integerValue] < 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"正常", nil);
            }
        }else{
            if([[BatterHelp numberHexString:battery] integerValue] < 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"PIR探测器" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TRIGGERED isEqualToString:status]){
            return  NSLocalizedString(@"有人移动报警", nil);
        }else if([STATE_NORMAL isEqualToString:status]){
            if([[BatterHelp numberHexString:battery] integerValue] < 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"正常", nil);
            }
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            if([[BatterHelp numberHexString:battery] integerValue] < 15){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"SM报警器" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TEST isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([STATE_TRIGGERED isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] < 15 && [STATE_NORMAL isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"CO报警器" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TEST isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([STATE_TRIGGERED isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] < 15 && [STATE_NORMAL isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"水感报警器" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TEST isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([STATE_TRIGGERED isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] < 15 && [STATE_NORMAL isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"温湿度探测器" isEqualToString:[dic objectForKey:type]]){
        if([STATE_NORMAL isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] < 15){
            return NSLocalizedString(@"低电压", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"复合型烟感" isEqualToString:[dic objectForKey:type]]){
        if([@"17" isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([@"19" isEqualToString:status]){
            return  NSLocalizedString(@"火灾报警", nil);
        }else if([@"12" isEqualToString:status]){
            return  NSLocalizedString(@"故障", nil);
        }else if([@"15" isEqualToString:status]){
            return  NSLocalizedString(@"免打扰", nil);
        }else if([@"1B" isEqualToString:status]){
            return  NSLocalizedString(@"静音", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            if([STATE_NORMAL isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] < 15){
                return NSLocalizedString(@"低电压", nil);
            }else
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"气体探测器" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TEST isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([STATE_TRIGGERED isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] < 15 && [STATE_NORMAL isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"热感报警器" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TEST isEqualToString:status]){
            return  NSLocalizedString(@"测试报警", nil);
        }else if([STATE_TRIGGERED isEqualToString:status]){
            return  NSLocalizedString(@"报警", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else {
            if([[BatterHelp numberHexString:battery] integerValue] < 15 && [STATE_NORMAL isEqualToString:status]){
                return  NSLocalizedString(@"低电压", nil);
            }else{
                return  NSLocalizedString(@"报警", nil);
            }
        }
    }else if([@"情景开关" isEqualToString:[dic objectForKey:type]]){
        if([STATE_TRIGGERED isEqualToString:status]){
            return  NSLocalizedString(@"求救", nil);
        }else if([STATE_DOOR_NOT_CLOSED isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else{
            if([STATE_NORMAL isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] < 15){
                return NSLocalizedString(@"低电压", nil);
            }else
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"门锁" isEqualToString:[dic objectForKey:type]]){
        if([STATE_MUTE isEqualToString:status]){
            return  NSLocalizedString(@"开锁", nil);
        }else if([@"51" isEqualToString:status]){
            return  NSLocalizedString(@"密码开锁", nil);
        }else if([@"52" isEqualToString:status]){
            return  NSLocalizedString(@"卡开锁", nil);
        }else if([@"53" isEqualToString:status]){
            return  NSLocalizedString(@"指纹开锁", nil);
        }else if([@"10" isEqualToString:status]){
            return  NSLocalizedString(@"非法操作", nil);
        }else if([@"20" isEqualToString:status]){
            return  NSLocalizedString(@"强拆", nil);
        }else if([@"30" isEqualToString:status]){
            return  NSLocalizedString(@"胁迫", nil);
        }else if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else{
            if([STATE_NORMAL isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] < 15){
                return NSLocalizedString(@"低电压", nil);
            }else
                return NSLocalizedString(@"报警", nil);
        }
    }else if([@"智能插座" isEqualToString:[dic objectForKey:type]]){
        if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"双路开关" isEqualToString:[dic objectForKey:type]]){
        if([@"FF" isEqualToString:status]){
            return  NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"按键" isEqualToString:[dic objectForKey:type]]){
        if([STATE_NORMAL isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] < 15){
            return NSLocalizedString(@"低电压", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else if([@"调光模块" isEqualToString:[dic objectForKey:type]]){
        if([STATE_NORMAL isEqualToString:status] && [[BatterHelp numberHexString:battery] integerValue] < 15){
            return NSLocalizedString(@"低电压", nil);
        }else if([@"FF" isEqualToString:status]){
            return NSLocalizedString(@"离线", nil);
        }else{
            return NSLocalizedString(@"报警", nil);
        }
    }else{
       return NSLocalizedString(@"报警", nil);
    }
}


@end
