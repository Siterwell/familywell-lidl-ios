//
//  TempControlTimerListVC.m
//  sHome
//
//  Created by tracyhenry on 2018/11/6.
//  Copyright © 2018 shaop. All rights reserved.
//

#import "TempControlTimerListVC.h"
#import "SceneModel.h"
#import "SceneDataBase.h"
#import "GS361TimerCell.h"
#import "TempControlTimerEditVC.h"
#import "SceneListItemData.h"
#import "BatterHelp.h"
#import "DeviceListModel.h"
#import "deleteSceneApi.h"
#import "TestObject.h"
#import "SystemSceneDataBase.h"
#import "PushSystemSceneApi.h"
#import "SystemSceneHelp.h"

@interface TempControlTimerListVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray <SceneModel *>*scene_arry;

@end

@implementation TempControlTimerListVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定时切换", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addAction) image:@"topadd_blue_icon" highImage:@"topadd_blue_icon" withTintColor:ThemeColor];

    [self table];
    _scene_arry = [[SceneDataBase sharedDataBase] selectScenewithGS361:_devID];
    [self bubbleAscendingOrderSortWithArray:_scene_arry];
    [[self table] reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _scene_arry = [[SceneDataBase sharedDataBase] selectScenewithGS361:_devID];
    [self bubbleAscendingOrderSortWithArray:_scene_arry];
    [[self table] reloadData];
}

#pragma mark -lazy

- (UITableView *)table {
    
    if(!_table){
        _table= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = 70;
        _table.separatorInset = UIEdgeInsetsZero;
        _table.tableFooterView = [[UIView alloc] init];
        _table.backgroundColor = RGB(239, 239, 243);
        [self.view addSubview:_table];
        [_table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(15);
        }];
    }
    
    return _table;
}

#pragma mark -delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellId = @"cell";
    GS361TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[GS361TimerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
    }
    SceneModel *scc = [_scene_arry objectAtIndex:indexPath.row];
    SceneListItemData *data = [scc.scene_outdevice_array objectAtIndex:0];
    SceneListItemData *data2 = [scc.scene_indevice_array objectAtIndex:0];
    NSString *action = data2.action;
    NSString *status1 = [action substringWithRange:NSMakeRange(0, 2)];
    int ds = [[BatterHelp numberHexString:status1] intValue];
    int xiaoshu = (0x20) & ds;
    int sta =  ((0x1F) & ds);
    NSString *temp = [[NSString stringWithFormat:@"%d",sta] stringByAppendingString:(xiaoshu==0?@".0°C":@".5°C")];
    [cell setWeek:data.week];
    [cell setTime:[NSString stringWithFormat:@"%.2d",[data.hour intValue]] withMin:[NSString stringWithFormat:@"%.2d",[data.minute intValue]]];
    [cell setSceneGroup:temp];
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SceneModel *model = [_scene_arry objectAtIndex:indexPath.row];
    TempControlTimerEditVC *vc = [[TempControlTimerEditVC alloc] init];
    vc.mid = model.scene_id;
    vc.devID = _devID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _scene_arry.count;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"删除", nil);
}
/**
 cell点击删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //情景列表的删除
    
    SceneModel *model = _scene_arry[indexPath.row];
    
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *deviceModel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        
        deleteSceneApi *deleteapi = [[deleteSceneApi alloc] initWithDevTid:deviceModel.devTid CtrlKey:deviceModel.ctrlKey SceneTpye:model.scene_id SceneId:model.scene_id];
        __block TestObject *obj = [[TestObject alloc] init];
        [MBProgressHUD showLoadToView:GetWindow];
        @weakify(self)
        [deleteapi startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
            @strongify(self)
            
            [[SystemSceneDataBase sharedDataBase] deleteSelectScene:model.scene_id];
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            
            [_scene_arry enumerateObjectsUsingBlock:^(SceneModel *mmodel, NSUInteger idx, BOOL *stop) {
                if (mmodel == model) {
                    *stop = YES;
                    
                    if (*stop == YES) {
                        
                        [_scene_arry removeObjectAtIndex:indexPath.row];
                        [[SceneDataBase sharedDataBase] deletScene:model.scene_id];
                        [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self pushSystemData:model.scene_id];
           
                    }
                }
            }];
            
            
            
            //            [obj setValue:@"1" forKey:@"1"];
            obj = nil;
        } failure:^(id data, NSError *error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            //            [obj setValue:@"1" forKey:@"1"];
            obj = nil;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (obj) {
                [MBProgressHUD hideHUDForView:GetWindow animated:YES];
                [MBProgressHUD showError:NSLocalizedString(@"删除失败", nil) ToView:GetWindow];
                obj = nil;
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
                    [config setObject:NetworkAppStatus forKey:AppStatus];
                }
            }
        });
    
}


#pragma -mark method
-(void)addAction{
    TempControlTimerEditVC *vc = [[TempControlTimerEditVC alloc] init];
    vc.devID = _devID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSystemData:(NSString *)scene_group{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    NSMutableArray *systemlist = [[SystemSceneDataBase sharedDataBase] selectScene];
    
    for (SystemSceneModel *models in systemlist) {
        NSString *content = [SystemSceneHelp getSceneContent:models.scene_name SceneId:models.sence_group ButtonCotent:@"" sceneArray:[models getSelectArray] color:models.scene_color andButtonsDetail:@"" withoutScene_group:scene_group];
        SystemSceneModel * a = [[SystemSceneModel alloc] init];
        a.scene_name = models.scene_name;
        a.sence_group = models.sence_group;
        a.answer_content = [content substringWithRange:NSMakeRange(0, content.length-4)];
        [[SystemSceneDataBase sharedDataBase] updateScene:a];
        PushSystemSceneApi *api = [[PushSystemSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneContent:content];
        [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
        } failure:^(id data, NSError *error) {
        }];
    }
}

//按照时间顺序重排
- (void)bubbleAscendingOrderSortWithArray:(NSMutableArray <SceneModel *>*)ascendingArr
{
    for (int i = 0; i < ascendingArr.count; i++) {
        for (int j = 0; j < ascendingArr.count - 1 - i;j++) {
            SceneModel *ad1 = ascendingArr[j];
            SceneModel *ad2 = ascendingArr[j+1];
            SceneListItemData *data1 = [ad1.scene_outdevice_array objectAtIndex:0];
             SceneListItemData *data2 = [ad2.scene_outdevice_array objectAtIndex:0];
            if([data1.hour intValue]>[data2.hour intValue]){
                SceneModel * temp = ascendingArr[j];
                ascendingArr[j] = ascendingArr[j + 1];
                ascendingArr[j + 1] = temp;
            }else if([data1.hour intValue]==[data2.hour intValue]){
                if([data1.hour intValue]>[data2.hour intValue]){
                    SceneModel * temp = ascendingArr[j];
                    ascendingArr[j] = ascendingArr[j + 1];
                    ascendingArr[j + 1] = temp;
                }
            }
        }
    }

}
@end
