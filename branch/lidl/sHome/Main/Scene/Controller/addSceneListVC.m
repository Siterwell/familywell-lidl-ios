//
//  addSceneListVC.m
//  sHome
//
//  Created by shaop on 2016/12/20.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "addSceneListVC.h"
#import "AddSceneListCell.h"
#import "SceneListItemData.h"
#import "addSceneListItemVC.h"
#import "executeSceneItemVC.h"
#import "SceneConditionVC.h"
#import "ItemData.h"
#import "ItemDataHelp.h"
#import "addSceneApi.h"
#import "DeviceListModel.h"
#import "SceneListTitleCell.h"
#import "SetTimeVC.h"
#import "NoramlStatusVC.h"
#import "DelayTimeVC.h"
#import "OutletStatusVC.h"
#import "SystemSceneDataBase.h"
#import "BatterHelp.h"
#import "SceneDataBase.h"

#import "HumitureStatusVC.h"
#import "DoubleSwitchStatusVC.h"
#import "LightStatusVC.h"
#import "TempControlSetVC.h"
#import "AppDelegate.h"

@interface addSceneListVC ()

@property (nonatomic , weak) UITextField *titleTextFiled;

@end

@implementation addSceneListVC


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.shouldShowMore = NO;
    
    if (self.outItemDatas.count) {
        for (int i = 0; i < _outItemDatas.count; i++) {
            SceneListItemData *data = _outItemDatas[i];
            if ([data.title containsString:@"门锁"]) {
                appDelegate.shouldShowMore = YES;
            }
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_selectType) {
        _selectType = 0;
    }
    if (!_outItemDatas) {
        _outItemDatas = [[NSMutableArray alloc] init];
    }
    if (!_inItemDatas) {
        _inItemDatas = [[NSMutableArray alloc] init];
    }
    
    for (ItemData *data in _outItemDatas) {
        if ([data.image isEqualToString:@""] || data.image == nil) {
            [MBProgressHUD showError:NSLocalizedString(@"没有找到相关设备，可能被删除", nil) ToView:[UIApplication sharedApplication].keyWindow];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    for (ItemData *data in _inItemDatas) {
        if ([data.image isEqualToString:@""] || data.image == nil) {
            [MBProgressHUD showError:NSLocalizedString(@"没有找到相关设备，可能被删除", nil) ToView:[UIApplication sharedApplication].keyWindow];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    UITextField * enterTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width-40, 30)];
    enterTextField.backgroundColor = RGB(242, 242, 245);
    enterTextField.layer.cornerRadius = 15.0f;
    enterTextField.placeholder = NSLocalizedString(@"请输入情景名称", nil);
    enterTextField.textColor = [UIColor blackColor];
    CGRect frame = enterTextField.frame;
    frame.size.width = 20;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    enterTextField.leftViewMode = UITextFieldViewModeAlways;
    enterTextField.leftView = leftview;
    _titleTextFiled = enterTextField;
    if (_sceneTitle) {
        _titleTextFiled.text = _sceneTitle;
    }else{
        //自定义编号
        NSMutableArray *array = [[SceneDataBase sharedDataBase] selectScenewithoutDefault];
        int maxId = 1;
        
        for (SceneModel *model in array) {
            if ([model.scene_id intValue] > maxId) {
                maxId = [model.scene_id intValue];
            }
        }
        
        NSString *scene_id = [NSString stringWithFormat:@"%d",maxId + 1];
        
        for (int i = 1 ; i <= maxId; i ++ ) {
            if (![[SceneDataBase sharedDataBase] selectScene:[NSString stringWithFormat:@"%d",i]].scene_content) {
                scene_id = [NSString stringWithFormat:@"%d",i];
                break;
            }
        }
        
        NSString  *content = [BatterHelp gethexBybinary:[scene_id intValue]];
        if (content.length<2) {
            content = [@"0" stringByAppendingString:content];
        }
        _titleTextFiled.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"My action", nil),content];
    }
    
    self.navigationItem.titleView = enterTextField;
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(popself) image:@"back_icon" highImage:@"back_icon" withTintColor:[UIColor whiteColor]];

}

-(void)dealloc{
    NSLog(@">>>");
}

- (void)popself{
    NSString *content = [ItemDataHelp SceneContentWithOutputArray:_outItemDatas inputAraary:_inItemDatas type:_selectType name:_titleTextFiled.text sceneid:_sceneId];
    
    if ([[content substringWithRange:NSMakeRange(0, content.length-4) ]isEqualToString:self.scene_content] || _inItemDatas.count < 1 || _outItemDatas.count < 1) {
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
        [self clickItem];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)clickItem{
    
    if ([_titleTextFiled.text isEqualToString:@""]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入情景名称", nil) ToView:self.view];
        return;
    }
    
    SceneModel *sModel = [[SceneDataBase sharedDataBase] selectSceneByName:_titleTextFiled.text];
    
    if (![NSLocalizedString(_sceneTitle, nil) isEqualToString:_titleTextFiled.text] && sModel != nil&&[sModel.scene_name isEqualToString:_titleTextFiled.text]) {
        [MBProgressHUD showError:NSLocalizedString(@"输入情景名称重复", nil) ToView:self.view];
        return;
    }
    
    if ([self.titleTextFiled.text containsString:@"@"] || [self.titleTextFiled.text containsString:@"$"]) {
        [MBProgressHUD showError:NSLocalizedString(@"名称含有非法字符", nil) ToView:self.view];
        return;
    }
    
    NSStringEncoding enc = NSUTF8StringEncoding;//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *namedata = [_titleTextFiled.text dataUsingEncoding:enc];
    if (namedata.length >= 25) {
        [MBProgressHUD showError:NSLocalizedString(@"情景名称过长", nil) ToView:self.view];
        return;
    }
    
//    if (_outItemDatas.count>0 && _inItemDatas.count>0) {
    if (_inItemDatas.count > 0) {
    
//        if (![self checkItemDevice:_outItemDatas] || ![self checkItemDevice:_inItemDatas]) {
//            [MBProgressHUD showError:NSLocalizedString(@"请添加设备", nil) ToView:self.view];
//            return;
//        }
        
        SceneListItemData *lastItem = _inItemDatas.lastObject;
        if ([lastItem.image isEqualToString:@"blue_ys_icon"]) {
            [MBProgressHUD showError:NSLocalizedString(@"输出必须含有设备", nil) ToView:self.view];
            return;
        }

        if (_outItemDatas.count <=0) {
            [MBProgressHUD showError:NSLocalizedString(@"必须含有输入条件", nil) ToView:self.view];
            return;
        }
        
//        for (int i = 1 ; i < _inItemDatas.count ;i++) {
//            
//            SceneListItemData *item = _inItemDatas[i];
//            SceneListItemData *last_item = _inItemDatas[i-1];
//
//            if ([item.custmTitle isEqualToString:last_item.custmTitle]) {
//                [MBProgressHUD showError:NSLocalizedString(@"不能有相邻的设置", nil) ToView:self.view];
//                return;
//            }
//        }
        
        NSString *content = [ItemDataHelp SceneContentWithOutputArray:_outItemDatas inputAraary:_inItemDatas type:_selectType name:_titleTextFiled.text sceneid:_sceneId];
        
        
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        
        
        @weakify(self);
        addSceneApi *api = [[addSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneTpye:@"0" SceneContent:content];
        __block NSObject *obj = [[NSObject alloc] init];
        [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
            @strongify(self);
            
            if (!_sceneId) {
                NSMutableArray *array = [[SystemSceneDataBase sharedDataBase] selectScene:[config objectForKey:selectSystemItem]];
                SystemSceneModel *s_model = array[0];
                
                if (s_model.answer_content.length < 32) {
                    
                } else {
                    int number = (int)strtoul([[s_model.answer_content substringWithRange:NSMakeRange(38, 4)] UTF8String],0,16);
                    number ++;
                    NSString *cnmber = [BatterHelp gethexBybinary:number];
                    int length = (int)cnmber.length ;
                    for (int i = length; i<4; i++) {
                        cnmber = [@"0" stringByAppendingString:cnmber];
                    }
                    s_model.answer_content = [s_model.answer_content stringByReplacingCharactersInRange:NSMakeRange(38, 4) withString:cnmber];
                    _sceneId = [content substringWithRange:NSMakeRange(4, 2)];
                    
//                    s_model.answer_content = [s_model.answer_content stringByAppendingString:_sceneId];
                    NSMutableString *tempContent = [[NSMutableString alloc] initWithString:s_model.answer_content];
                    [tempContent insertString:_sceneId atIndex:s_model.answer_content.length - 2];
                    s_model.answer_content = tempContent;
//                    [[SystemSceneDataBase sharedDataBase] updateScene:s_model];
                    
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate sendNext:@"1"];
                
            }else{
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate sendNext:@"2"];
            }
//            [obj setValue:@"1" forKey:@""];
            obj = nil;
//
        } failure:^(id data, NSError *error) {
//            [obj setValue:@"1" forKey:@""];
            obj = nil;
        }];
        
//        addSceneApi *api = [[addSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneTpye:@"1" SceneContent:content];
//        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
//            @strongify(self);
//            [self.navigationController popViewControllerAnimated:YES];
//            [self.delegate sendNext:nil];
//        } failure:^(id data, NSError *error) {
//            
//        }];
        
    }else{
        [MBProgressHUD showError:NSLocalizedString(@"请选择自定义情景", nil) ToView:self.view];
    }
}

- (BOOL) checkItemDevice:(NSMutableArray *)array{
    
    for (SceneListItemData *item in array) {
        if (item.deviceId || [item.title isEqualToString:@"点击执行"] || [item.image isEqualToString:@"blue_clock_icon"] || [item.title isEqualToString:@"手机通知"]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    else if (section == 1){
        return 1;
    }
    else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SceneListTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleViewCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.editBtn.hidden = YES;
            cell.titleLabel.text = NSLocalizedString(@"执行条件/", nil);
            return cell;
        }else{
            AddSceneListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentViewCell" forIndexPath:indexPath];
            cell.cellType = AddSceneCellTypeOutPut;
            cell.itemDatas = _outItemDatas;
            
            [cell.subCollectionView reloadData];
            //删除item
            cell.delegate = [RACSubject subject];
            @weakify(self);
            [cell.delegate subscribeNext:^(id x) {
                @strongify(self);
                [self.outItemDatas removeObjectAtIndex:[x intValue]];
                [self.tableView reloadData];
                
                AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                appDelegate.shouldShowMore = NO;
                
                if (self.outItemDatas.count) {
                    for (int i = 0; i < _outItemDatas.count; i++) {
                        SceneListItemData *data = _outItemDatas[i];
                        if ([data.title containsString:@"门锁"]) {
                            appDelegate.shouldShowMore = YES;
                        }
                    }
                }
                
            }];
            //添加item
            cell.toListItemdelegate = [RACSubject subject];
            [cell.toListItemdelegate subscribeNext:^(id x) {
                @strongify(self);
                [self performSegueWithIdentifier:@"toSelectSceneListItem" sender:x];
            }];
            //编辑item
            cell.outClickItemdelegate = [RACSubject subject];
            [cell.outClickItemdelegate subscribeNext:^(id x) {
                SceneListItemData *item = x;
                NSIndexPath *index;
                for (int i = 0; i < _outItemDatas.count; i++) {
                    SceneListItemData *data = _outItemDatas[i];
                    if ([data.title isEqualToString:item.title]) {
                        index = [NSIndexPath indexPathForItem:i inSection:0];
                    }
                }
                
                if ([item.image isEqualToString:@"blue_clock_icon"]) {
                    [self performSegueWithIdentifier:@"toSetTime" sender:index];
                }
                else if ([item.image isEqualToString:@"blue_wsdjcy_icon"]) {
                    HumitureStatusVC *vc = [[HumitureStatusVC alloc] init];
                    vc.title = item.custmTitle;
                    vc.selectCode = item.action;
                    
                    vc.delegate = [RACSubject subject];
                    @weakify(self);
                    [vc.delegate subscribeNext:^(id x) {
                        @strongify(self);
                        SceneListItemData *item1 = item;
                        item1.action = x;
                        [self.navigationController popViewControllerAnimated:YES];
                        [self.tableView reloadData];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"enableClickDevice" ofType:@"plist"];
                    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
                    
                    NSArray *array = dic[@"outDevice"];
                    for (NSString *name in array) {
                        if ([item.title isEqualToString:name]) {
                            [self performSegueWithIdentifier:@"toNormalStatus" sender:index];
                        }
                    }
                }
            }];
            
            return cell;
        }
    }
    else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
        if (_selectType == 0) {
            cell.textLabel.text = NSLocalizedString(@"满足任一条件即触发", nil);
        }else{
            cell.textLabel.text = NSLocalizedString(@"满足所有条件执行", nil);
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = RGB(91, 91, 91);
        return cell;
    }
    else {
        if (indexPath.row == 0) {
            SceneListTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleViewCell" forIndexPath:indexPath];
            cell.editBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = NSLocalizedString(@"按顺序执行以下动作", nil);
            cell.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.titleLabel.numberOfLines = 0;
            
            [cell.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-120);
            }];
            return cell;
        } else {
            AddSceneListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentViewCell" forIndexPath:indexPath];
            cell.cellType = AddSceneCellTypeInPut;
            cell.itemDatas = _inItemDatas;
            
            [cell.subCollectionView reloadData];
            //删除item
            cell.delegate = [RACSubject subject];
            @weakify(self);
            [cell.delegate subscribeNext:^(id x) {
                @strongify(self);
                [self.inItemDatas removeObjectAtIndex:[x intValue]];
                //                cell.itemDatas = self.inItemDatas;
                //                [cell.subCollectionView reloadData];
                [self.tableView reloadData];
            }];
            //添加item
            cell.toExecutedelegate = [RACSubject subject];
            [cell.toExecutedelegate subscribeNext:^(id x) {
                @strongify(self);
                [self performSegueWithIdentifier:@"toExecute" sender:x];
            }];
            //编辑item
            cell.inClickItemdelegate = [RACSubject subject];
            [cell.inClickItemdelegate subscribeNext:^(id x) {
                NSIndexPath *index = x;
                SceneListItemData *data = _inItemDatas[index.row];
                
                if ([data.image isEqualToString:@"blue_ys_icon"]) {
                    [self performSegueWithIdentifier:@"toDelayTime" sender:[NSIndexPath indexPathForRow:index.row inSection:2]];
                }
                else if ([data.title isEqualToString:@"双路开关"]) {
                    DoubleSwitchStatusVC *vc = [[DoubleSwitchStatusVC alloc] init];
                    vc.title = data.custmTitle;
                    vc.selectCode = data.action;
                    vc.delegate = [RACSubject subject];
                    @weakify(self);
                    [vc.delegate subscribeNext:^(id x) {
                        @strongify(self);
                        SceneListItemData *item1 = data;
                        item1.action = x;
                        [self.navigationController popViewControllerAnimated:YES];
                        [self.tableView reloadData];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else if ([data.title isEqualToString:@"调光模块"]) {
                    LightStatusVC *vc = [[LightStatusVC alloc] init];
                    vc.title = data.custmTitle;
                    vc.selectCode = data.action;
                    vc.delegate = [RACSubject subject];
                    @weakify(self);
                    [vc.delegate subscribeNext:^(id x) {
                        @strongify(self);
                        SceneListItemData *item2 = data;
                        item2.action = x;
                        [self.navigationController popViewControllerAnimated:YES];
                        [self.tableView reloadData];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([data.title isEqualToString:@"温控器"]) {
                    TempControlSetVC *vc = [[TempControlSetVC alloc] init];
                    vc.title = data.custmTitle;
                    vc.selectCode = data.action;
                    vc.delegate = [RACSubject subject];
                    @weakify(self);
                    [vc.delegate subscribeNext:^(id x) {
                        @strongify(self);
                        SceneListItemData *item2 = data;
                        item2.action = x;
                        [self.navigationController popViewControllerAnimated:YES];
                        [self.tableView reloadData];
                    }];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else {
                    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"enableClickDevice" ofType:@"plist"];
                    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
                    
                    NSArray *array = dic[@"inDevice"];
                    for (NSString *name in array) {
                        if ([data.title isEqualToString:name]) {
                            [self performSegueWithIdentifier:@"toNormalStatus" sender:[NSIndexPath indexPathForRow:index.row inSection:2]];
                        }
                    }
                }
            }];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"toChooseConditions" sender:nil];
    }
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Main_Screen_Width/4+10;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            int count = (int)_outItemDatas.count;
            int row = count/3;
            return (Main_Screen_Width/4+10)*(row+1);
        }
    }else if(indexPath.section == 2){
        if (indexPath.row != 0) {
            int count = (int)_inItemDatas.count;
            int row = count/3;
            return (Main_Screen_Width/4+10)*(row+1);
        } 
    }
    
    return UITableViewAutomaticDimension;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toSelectSceneListItem"]) {
        //跳转选择启动条件列表
        NSMutableArray *items = sender;
        addSceneListItemVC *vc = segue.destinationViewController;
        vc.selectItems = items;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = x;
            [_outItemDatas addObject:item];
            [self.tableView reloadData];
        }];
    }else if ([segue.identifier isEqualToString:@"toChooseConditions"]){
        //选择执行条件
        SceneConditionVC *vc = segue.destinationViewController;
        vc.selectType = _selectType;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            self.selectType = [x integerValue];
            [self.tableView reloadData];
        }];
    }else if ([segue.identifier isEqualToString:@"toExecute"]) {
        //选择执行选项
        NSMutableArray *items = [sender mutableCopy];
        executeSceneItemVC *vc = segue.destinationViewController;
        vc.selectsItems = items;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = x;
            [_inItemDatas addObject:item];
            [self.tableView reloadData];
        }];
    }else if ([segue.identifier isEqualToString:@"toSetTime"]) {
        //选择设置时间
        NSIndexPath *indexPath = sender;
        __block SceneListItemData *item = self.outItemDatas[indexPath.row];
        
        SetTimeVC *vc = segue.destinationViewController;
        vc.hour = item.hour;
        vc.minute = item.minute;
        vc.week = item.week;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            TimeModel *model = x;
            item = self.outItemDatas[indexPath.row];
            item.week = model.week;
            item.hour = model.Hour;
            item.minute = model.Minute;
            item.title = [NSString stringWithFormat:@"%@:%@",item.hour,item.minute];
            [self.navigationController popViewControllerAnimated:YES];
            [self.tableView reloadData];
        }];
    }else if ([segue.identifier isEqualToString:@"toDelayTime"]) {
        //延迟类
        NSIndexPath *indexPath = sender;
        __block SceneListItemData *item = self.inItemDatas[indexPath.row];

        DelayTimeVC *vc = segue.destinationViewController;
        vc.minute = item.minute;
        vc.second = item.second;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            TimeModel *model = x;
            item = self.inItemDatas[indexPath.row];
            item.minute = model.Minute;
            item.second = model.Seconde;
            item.title = [NSString stringWithFormat:@"%@:%@",item.minute,item.second];
            [self.navigationController popViewControllerAnimated:YES];
            [self.tableView reloadData];
        }];
    }else if ([segue.identifier isEqualToString:@"toNormalStatus"]){
        //正常类
        NSIndexPath *indexPath = sender;
        NoramlStatusVC *vc = segue.destinationViewController;
        SceneListItemData *item;
        if (indexPath.section == 0) {
            item = self.outItemDatas[indexPath.row];
        }else{
            item = self.inItemDatas[indexPath.row];
        }
        
        vc.deviceName = item.title;
        vc.selectCode = item.action;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item;
            if (indexPath.section == 0) {
                item = self.outItemDatas[indexPath.row];
            }else{
                item = self.inItemDatas[indexPath.row];
            }
            item.action = x;
            [self.navigationController popViewControllerAnimated:YES];
            [self.tableView reloadData];
        }];
    }else if ([segue.identifier isEqualToString:@"toOutletStatus"]){
        //插座类
        NSIndexPath *indexPath = sender;

        OutletStatusVC *vc = segue.destinationViewController;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = self.inItemDatas[indexPath.row];
            item.action = x;
            [self.navigationController popViewControllerAnimated:YES];
            [self.tableView reloadData];
        }];
    }
}



@end
