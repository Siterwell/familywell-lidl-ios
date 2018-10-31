//
//  EditTimeSwitchVC.m
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "EditTimeSwitchVC.h"
#import "SelectTimePickerCell.h"
#import "SelectScenePickerCell.h"
#import "SystemSceneDataBase.h"
#import "SelectDayCell.h"
#import "BatterHelp.h"
#import "TimerSceneHelp.h"
#import "AddTimeSceneApi.h"
#import "DeviceListModel.h"

@interface EditTimeSwitchVC ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) SelectTimePickerCell *timePickerCell;
@property (strong,nonatomic) SelectScenePickerCell *scenePickerCell;
@property (strong,nonatomic) SelectDayCell *dayCell;

@end

@implementation EditTimeSwitchVC
{
    BOOL isDayChanged;
    NSMutableArray *_systemSceneListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"编辑定时", nil);
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(popSelf) image:@"back_icon" highImage:@"back_icon" withTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(confirmAction) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
    isDayChanged = NO;
}

- (void)popSelf {
    //周次
    NSString *mo = @"0";
    NSString *tu = @"0";
    NSString *we = @"0";
    NSString *th = @"0";
    NSString *fr = @"0";
    NSString *sa = @"0";
    NSString *su = @"0";
    
    if (_dayCell.mondayBtn.isSelected) {
        mo = @"1";
    }else{
        mo = @"0";
    }
    
    if (_dayCell.tuesdayBtn.isSelected) {
        tu = @"1";
    }else{
        tu = @"0";
    }
    
    if (_dayCell.wednesdayBtn.isSelected) {
        we = @"1";
    }else{
        we = @"0";
    }
    
    if (_dayCell.thursdayBtn.isSelected) {
        th = @"1";
    }else{
        th = @"0";
    }
    
    if (_dayCell.fridayBtn.isSelected) {
        fr = @"1";
    }else{
        fr = @"0";
    }
    
    if (_dayCell.saturdayBtn.isSelected) {
        sa = @"1";
    }else{
        sa = @"0";
    }
    
    if (_dayCell.sundayBtn.isSelected) {
        su = @"1";
    }else{
        su = @"0";
    }
    
    NSString *week = [NSString stringWithFormat:@"%@%@%@%@%@%@%@0",su,sa,fr,th,we,tu,mo];
    week = [BatterHelp getDecimalBybinary:week];
    week = [BatterHelp gethexBybinary:[week longLongValue]];
    if ([week isEqualToString:@"0"]) {
//        [MBProgressHUD showSuccess:NSLocalizedString(@"请选择星期", nil) ToView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //时间
    NSInteger hourIndex = [_timePickerCell.timePicker selectedRowInComponent:0];
    NSInteger secondIndex = [_timePickerCell.timePicker selectedRowInComponent:2];
    
    NSString *Hour = [_timePickerCell.hourArray objectAtIndex:hourIndex%24];
    NSString *Minute = [_timePickerCell.secondArray objectAtIndex:secondIndex%60];
    
    //情景模式
    NSInteger sceneIndex = [_scenePickerCell.scenePicker selectedRowInComponent:0];
    NSString *sceneId = ((SystemSceneModel*)[_systemSceneListArray objectAtIndex:sceneIndex%_systemSceneListArray.count]).sence_group;
    sceneId = [NSString stringWithFormat:@"0%d",[sceneId intValue]];
    
    NSString *time = [TimerSceneHelp getSceneTime:(_timeModel!=nil?_timeModel.timer_id:nil) timerOn:self.timeModel == nil?@"01":self.timeModel.timer_on SceneId:sceneId TimerWeek:week TimerH:Hour TimerM:Minute];
    
    if ([self.timeModel.time isEqualToString:time]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否保存此次修改", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    @weakify(self)
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"不保存", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"保存", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self)
        [self confirmAction];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self lodaSystemData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        _timePickerCell = [tableView dequeueReusableCellWithIdentifier:@"SelectTimePickerCell"];
        _timePickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.timeModel != nil) {
            _timePickerCell.H = _timeModel.timeWHMS.Hour;
            _timePickerCell.M = _timeModel.timeWHMS.Minute;
        } else {
            _timePickerCell.H = @"00";
            _timePickerCell.M = @"00";
        }
        
        return _timePickerCell;
    }else if (indexPath.section == 1){
        _scenePickerCell = [tableView dequeueReusableCellWithIdentifier:@"SelectScenePickerCell"];
        _scenePickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _scenePickerCell.systemScenes = _systemSceneListArray;
        if (self.timeModel != nil) {
            _scenePickerCell.sceneId = _timeModel.sence_group;
        } else {
            _scenePickerCell.sceneId = @"0";
        }
        return _scenePickerCell;
    }else{
        _dayCell = [tableView dequeueReusableCellWithIdentifier:@"SelectDayCell"];
        _dayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.timeModel != nil&&!isDayChanged) {
            _dayCell.week = _timeModel.timeWHMS.week;
        }
        _dayCell.dayChanged = ^{
            isDayChanged = YES;
        };
        return _dayCell;
    }
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark 确定
- (void)confirmAction
{
    //周次
    NSString *mo = @"0";
    NSString *tu = @"0";
    NSString *we = @"0";
    NSString *th = @"0";
    NSString *fr = @"0";
    NSString *sa = @"0";
    NSString *su = @"0";
    
    if (_dayCell.mondayBtn.isSelected) {
        mo = @"1";
    }else{
        mo = @"0";
    }
    
    if (_dayCell.tuesdayBtn.isSelected) {
        tu = @"1";
    }else{
        tu = @"0";
    }
    
    if (_dayCell.wednesdayBtn.isSelected) {
        we = @"1";
    }else{
        we = @"0";
    }
    
    if (_dayCell.thursdayBtn.isSelected) {
        th = @"1";
    }else{
        th = @"0";
    }
    
    if (_dayCell.fridayBtn.isSelected) {
        fr = @"1";
    }else{
        fr = @"0";
    }
    
    if (_dayCell.saturdayBtn.isSelected) {
        sa = @"1";
    }else{
        sa = @"0";
    }
    
    if (_dayCell.sundayBtn.isSelected) {
        su = @"1";
    }else{
        su = @"0";
    }
    
    NSString *week = [NSString stringWithFormat:@"%@%@%@%@%@%@%@0",su,sa,fr,th,we,tu,mo];
    week = [BatterHelp getDecimalBybinary:week];
    week = [BatterHelp gethexBybinary:[week longLongValue]];
    if ([week isEqualToString:@"0"]) {
        [MBProgressHUD showSuccess:NSLocalizedString(@"请选择星期", nil) ToView:self.view];
        return;
    }
    
    //时间
    NSInteger hourIndex = [_timePickerCell.timePicker selectedRowInComponent:0];
    NSInteger secondIndex = [_timePickerCell.timePicker selectedRowInComponent:2];
    
    NSString *Hour = [_timePickerCell.hourArray objectAtIndex:hourIndex%24];
    NSString *Minute = [_timePickerCell.secondArray objectAtIndex:secondIndex%60];
    
    //情景模式
    NSInteger sceneIndex = [_scenePickerCell.scenePicker selectedRowInComponent:0];
    NSString *sceneId = ((SystemSceneModel*)[_systemSceneListArray objectAtIndex:sceneIndex%_systemSceneListArray.count]).sence_group;
    sceneId = [NSString stringWithFormat:@"0%d",[sceneId intValue]];
    
    NSString *time = [TimerSceneHelp getSceneTime:(_timeModel!=nil?_timeModel.timer_id:nil) timerOn:self.timeModel == nil?@"01":self.timeModel.timer_on SceneId:sceneId TimerWeek:week TimerH:Hour TimerM:Minute];
    
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    
    @weakify(self);
    
    AddTimeSceneApi *api = [[AddTimeSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey Time:time];
    __block NSObject *obj = [[NSObject alloc] init];
    [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
        @strongify(self);
        
        if (!error) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            if (self.timerId == nil) {
                [MBProgressHUD showError:NSLocalizedString(@"添加失败", nil) ToView:GetWindow];
            }else{
                [MBProgressHUD showError:NSLocalizedString(@"修改失败", nil) ToView:GetWindow];
            }
            
        }
        
    } failure:^(id data, NSError *error) {
        [obj setValue:@"1" forKey:@""];
        obj = nil;
    }];

    
}

/**
 从数据库读取系统情景数据
 */
- (void)lodaSystemData{
    _systemSceneListArray = [[SystemSceneDataBase sharedDataBase] selectScene];
//    [self.table reloadData];
}


@end
