//
//  TimeSwitchVc.m
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "TimeSwitchVC.h"
#import "TimeSwitchCell.h"
#import "DeviceListModel.h"
#import "SycnTimeSceneApi.h"
#import "TimeSceneModel.h"
#import "TimeScenedDataBase.h"
#import "deleteTimerSceneApi.h"
#import "MyUdp.h"
#import "BatterHelp.h"
#import "TestObject.h"
#import "EditTimeSwitchVC.h"
#import "AddTimeSceneApi.h"

@interface TimeSwitchVC ()<UITableViewDelegate , UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic,strong) NSMutableArray *timerSceneListArray;


@end

@implementation TimeSwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"定时", nil);
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.table.allowsSelectionDuringEditing = YES;
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addTimeScene) Title:NSLocalizedString(@"添加", nil) withTintColor:RGB(40, 184, 215)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSceneTimerData) name:@"addTimerSceneListSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSceneTimerData) name:@"updateTimerSceneListSuccess" object:nil];
    
    [self sendAndRecvSenceTimerData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self syncTimerScene];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)sendAndRecvSenceTimerData{
    
    //数据库加载设备列表数据
    [self loadSceneTimerData];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    //读取定时数据
    NSDictionary *dic = @{
                          @"action" : @"devSend",
                          @"params" : @{
                                  @"devTid" : model.devTid,
                                  @"data" : @{
                                          @"cmdId" : @36
                                          }
                                  }
                          };
    
    @weakify(self)
    if (![[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
        [[Hekr sharedInstance] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
            if (!error) {
                
                TimeSceneModel *model = [[TimeSceneModel alloc]initWithDivicedictionary:data error:nil];
                
                if (model.time.length>=16) {
                    
                    [[TimeScenedDataBase sharedDataBase] updateTimerScene:model];
                }
                
                if ([model.time hasSuffix:@"DEL"]) {
                    
                    [[TimeScenedDataBase sharedDataBase] deletTimerScene:[model.time substringToIndex:2]];
                    [self loadSceneTimerData];
                }
            }
        }];
    }else{
        [[MyUdp shared] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
            if (!error) {
                
                TimeSceneModel *model = [[TimeSceneModel alloc] initWithDivicedictionary:data error:nil];
                if (model.time.length>=16) {
                    [[TimeScenedDataBase sharedDataBase] updateTimerScene:model];
                }
                
                if ([model.time hasSuffix:@"DEL"]) {
                    
                    [[TimeScenedDataBase sharedDataBase] deletTimerScene:[model.time substringToIndex:2]];
                    [self loadSceneTimerData];
                }
                
            }
        }];
    }
    
}

- (void)syncTimerScene{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    NSString *SceneTimerListContent = @"";
    
    NSArray *allTimerSceneListArray = [[TimeScenedDataBase sharedDataBase] selectTimerSceneOrderById];
    
    if (allTimerSceneListArray.count > 0) {
        
        int maxId = 0;
        for (TimeSceneModel *model in allTimerSceneListArray) {
            if ([[BatterHelp numberHexString:model.timer_id] intValue] > maxId) {
                maxId = [[BatterHelp numberHexString:model.timer_id] intValue];
            }
        }
        SceneTimerListContent = [BatterHelp gethexBybinary:(maxId * 2 + 4)];
    }else {
        SceneTimerListContent = @"2";
    }
    long scene_count = SceneTimerListContent.length;
    for (int i = 0; i < 4 - scene_count; i++) {
        SceneTimerListContent = [@"0" stringByAppendingString:SceneTimerListContent];
    }
    
    //crc
    // 自定义情景CRC补位
    int arrayIndex = 0;
    if (allTimerSceneListArray.count > 0) {
        
        int maxId = 0;
        
        for (TimeSceneModel *model in allTimerSceneListArray) {
            if ([[BatterHelp numberHexString:model.timer_id] intValue] > maxId) {
                maxId = [[BatterHelp numberHexString:model.timer_id] intValue];
            }
        }
        
        for (int i = 0; i <= maxId; i++) {
            TimeSceneModel *model = allTimerSceneListArray[arrayIndex];
            if (i == [[BatterHelp numberHexString:model.timer_id] intValue]) {
                SceneTimerListContent = [SceneTimerListContent stringByAppendingString:model.timer_crc];
                NSLog(@"chen==%@", model.timer_crc);
                arrayIndex ++;
            }else{
                SceneTimerListContent = [SceneTimerListContent stringByAppendingString:@"0000"];
            }
        }
    }
    
    SycnTimeSceneApi *api = [[SycnTimeSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey Time:SceneTimerListContent];
    
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        
        if (!error) {
            
        }
    } failure:^(id data, NSError *error) {
    }];
    
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
    return [_timerSceneListArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimeSceneModel *tsceneModel = [_timerSceneListArray objectAtIndex:indexPath.section];
    
    TimeSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeSwitchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeModel = tsceneModel;
    cell.hwSwitch.tag = [tsceneModel.timer_id integerValue];
    [cell.hwSwitch addTarget:self action:@selector(timeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除", nil);
}

/**
 cell点击删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *deviceModel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    TimeSceneModel *model = _timerSceneListArray[indexPath.section];
    deleteTimerSceneApi *api = [[deleteTimerSceneApi alloc] initWithDevTid:deviceModel.devTid CtrlKey:deviceModel.ctrlKey TimerId:model.timer_id];
    __block TestObject *obj = [[TestObject alloc] init];
    
    [MBProgressHUD showLoadToView:GetWindow];
    [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        
        if (!error) {
            
            if ([[TimeScenedDataBase sharedDataBase] deletTimerScene:model.timer_id]) {
                
                [_timerSceneListArray removeObjectAtIndex:indexPath.section];
                [self.table deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }else{
                [MBProgressHUD showError:NSLocalizedString(@"删除失败", nil) ToView:GetWindow];
            }
            
//            [obj setValue:@"1" forKey:@"1"];
            obj = nil;
            
        }
        
    } failure:^(id data, NSError *error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//        [obj setValue:@"1" forKey:@"1"];
        obj = nil;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (obj) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            [MBProgressHUD showError:NSLocalizedString(@"删除失败", nil) ToView:GetWindow];
            obj = nil;
        }
    });
}

/**
 cell的编辑状态
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果点击掉是[系统]的编辑按钮，则进入删除状态
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"SceneStoryboard" bundle:nil];
    
    //系统情景跳转
    TimeSceneModel *model = _timerSceneListArray[indexPath.section];
    
    EditTimeSwitchVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"EditTimeSwitchVC"];
    vc.timeModel = model;
    vc.timerId = model.timer_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 控制按钮切换
- (void)timeSwitch:(id)sender{
    
    HWSwitch *hw = (HWSwitch*)sender;
    
    NSString *onOrOff = hw.on?@"01":@"00";
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    for (int i = 0; i < [_timerSceneListArray count]; i++) {
        TimeSceneModel *tModel = [_timerSceneListArray objectAtIndex:i];
        if ([tModel.timer_id integerValue] == hw.tag) {
            
            NSString *time = tModel.time;
            
            time = [time stringByReplacingCharactersInRange:NSMakeRange(2,2) withString:onOrOff];
            @weakify(self);
            
            AddTimeSceneApi *api = [[AddTimeSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey Time:time];
            __block NSObject *obj = [[NSObject alloc] init];
            [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
                @strongify(self);
                
                if (!error) {
                    
                }
                
            } failure:^(id data, NSError *error) {
                [obj setValue:@"1" forKey:@""];
                obj = nil;
            }];
            
            return;
        }
    }
}

#pragma mark 添加定时情景
- (void)addTimeScene{
    [self performSegueWithIdentifier:@"editTimeSwitch" sender:nil];
}

/**
 从数据库读取定时情景数据
 */
- (void)loadSceneTimerData{
    
    _timerSceneListArray = [[TimeScenedDataBase sharedDataBase] selectTimerScene];
    
    for (TimeSceneModel *time in _timerSceneListArray) {
        
        NSLog(@"koyangkoyan==fffff==%@====%@",time.time,time.timer_crc);
        
    }
    
    [self.table reloadData];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
