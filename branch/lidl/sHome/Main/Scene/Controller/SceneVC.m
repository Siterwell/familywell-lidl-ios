//
//  SceneVC.m
//  sHome
//
//  Created by shaop on 2016/12/13.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "SceneVC.h"
#import "SceneTitleCell.h"
#import "AddSceneVC.h"
#import "addSceneListVC.h"
#import "TimeSwitchVC.h"
#import "DeviceListModel.h"
#import "SceneListCell.h"
#import "SceneDataBase.h"
#import "SystemSceneCell.h"
#import "deleteSceneApi.h"
#import "SystemSceneDataBase.h"
#import "ChooseSystemSceneApi.h"
#import "BatterHelp.h"
#import "SycnSceneApi.h"
#import "TestObject.h"
#import "ClickSceneApi.h"
#import "PushSystemSceneApi.h"
#import "DeleteSystemSceneApi.h"
#import "SceneGroupSelectModel.h"
#import "MyUdp.h"
#import "SystemSceneHelp.h"
#import "Encryptools.h"
@interface SceneVC ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *sceneListArray;
@property (strong, nonatomic) NSMutableArray *systemSceneListArray;

@end

@implementation SceneVC
{
    int _clickSection;
    int _selectSystemItem;
    
    NSString *_runDevice;
    
    BOOL _isSelecting;
    
    BOOL _isLoading;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"情景列表", nil);
    
    //初始化设备列表
    _sceneListArray = [[NSMutableArray alloc] init];
    _systemSceneListArray = [[NSMutableArray alloc] init];
    
    _systemSceneListArray = [[SystemSceneDataBase sharedDataBase] selectScene];
    self.table.allowsSelectionDuringEditing = YES;
    
    //加载信息
    [MBProgressHUD showProgressToView:GetWindow Text:NSLocalizedString(@"情景加载中",nil)];
    _isLoading = YES;
    
//    [self requestSenceInfo];
    
    //消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaListData) name:@"addSceneListSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaListData) name:@"updateSceneListSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaSystemData) name:@"addSystemSceneListSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaSystemData) name:@"updateSystemSceneListSuccess" object:nil];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(timeSwitch) Title:NSLocalizedString(@"定时切换",nil) withTintColor:RGB(40, 184, 215)];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addAction:) image:@"topadd_blue_icon" highImage:@"topadd_blue_icon" withTintColor:RGB(40, 184, 215)];
    
    [self sendAndRecvSenceData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

//加载情景信息
//- (void)requestSenceInfo{
//    //开始加载
//    @weakify(self)
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        @strongify(self)
//        if (_isLoading){
//            [MBProgressHUD hideHUD];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"似乎加载失败了，是否重试？",nil) preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重试",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                [MBProgressHUD showProgressToView:GetWindow Text:NSLocalizedString(@"情景加载中",nil)];
//                _isLoading = YES;
//                [self requestSenceInfo];
//
//            }]];
//
//            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }]];
//
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    });
//}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.alpha = 1;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if (model != nil) {
        [self syncScene];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [AppDelegate enableLoginCheck:true];
}

- (void)viewDidDisappear:(BOOL)animated{
    [AppDelegate enableLoginCheck:false];
}

- (void)sendAndRecvSenceData {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if (model == nil) {
        NSLog(@"[RYAN] sendAndRecvSenceData > no avaible device");
        return;
    }
    
    //判断运行的设备是否发生变化
    if (![_runDevice isEqualToString:model.devTid]) {
        
        _clickSection = 3;
        
        
        
        //原始选中情景
        _selectSystemItem = 0;
        //查看是否有历史选中情景
        if ([config objectForKey:selectSystemItem]) {
            _selectSystemItem = [[config objectForKey:selectSystemItem] intValue];
        }
        
        //数据库加载设备列表数据
        [self lodaListData];
        //数据库加载系统情景列表数据
        //        [self lodaSystemData];
        
        
        //无法放在一起些...读取cmd = 26（系统情景）的数据
        NSDictionary *dic = @{
                              @"action" : @"devSend",
                              @"params" : @{
                                      @"devTid" : model.devTid,
                                      @"data" : @{
                                              @"cmdId" : @26
                                              }
                                      }
                              };
        
        NSDictionary *scyDic = @{
                                 @"action" : @"devSend",
                                 @"params" : @{
                                         @"devTid" : model.devTid,
                                         @"data" : @{
                                                 @"cmdId" : @27
                                                 }
                                         }
                                 };
        NSDictionary *scenScyDic = @{
                                     @"action" : @"devSend",
                                     @"params" : @{
                                             @"devTid" : model.devTid,
                                             @"data" : @{
                                                     @"cmdId" : @28
                                                     }
                                             }
                                     };
        NSDictionary *dic2 = @{
                              @"action" : @"devSend",
                              @"params" : @{
                                      @"devTid" : model.devTid,
                                      @"data" : @{
                                              @"cmdId" : @126
                                              }
                                      }
                              };
        
        NSDictionary *scyDic2 = @{
                                 @"action" : @"devSend",
                                 @"params" : @{
                                         @"devTid" : model.devTid,
                                         @"data" : @{
                                                 @"cmdId" : @127
                                                 }
                                         }
                                 };
        NSDictionary *scenScyDic2 = @{
                                     @"action" : @"devSend",
                                     @"params" : @{
                                             @"devTid" : model.devTid,
                                             @"data" : @{
                                                     @"cmdId" : @128
                                                     }
                                             }
                                     };
        
        @weakify(self)
            ////* 外网26 */
            [[Hekr sharedInstance] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    SystemSceneModel *model = [[SystemSceneModel alloc] initWithDivicedictionary:data error:nil];
                    if (model.answer_content.length>32) {
                        [[SystemSceneDataBase sharedDataBase] updateScene:model];
                        
                    }else if (model.answer_content.length == 6 && [[model.answer_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]){
                        //删除情景
                        
                        NSString *senceID = [model.answer_content substringWithRange:NSMakeRange(4, 2)];
                        senceID = [NSString stringWithFormat:@"%@",[BatterHelp numberHexString:senceID]];
                        
                        if ([[BatterHelp numberHexString:senceID] intValue] >= 3) {
                            //id大于3进行删除。
                            [[SystemSceneDataBase sharedDataBase] deletSystemScene:senceID];
                            [self lodaSystemData];
                        }else{
                            //TODO:小于3代表系统情景，在这里进行颜色重新划分
                                [[SystemSceneDataBase sharedDataBase] updateScene:model];
                                [self lodaSystemData];
                            }
                        
                    }
                }
            }];
            ////* 外网126加密 */
            [[Hekr sharedInstance] recv:dic2 obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    NSNumber *msgId=data[@"msgId"];
                    SystemSceneModel *model = [[SystemSceneModel alloc] initWithDivicedictionary:data error:nil];
                        int newa = [Encryptools getDescryption:[model.sence_group intValue] withMsgId:[msgId intValue]];
                        [model setSence_group:[NSString stringWithFormat:@"%d",newa]];
                    if (model.answer_content.length>32) {
                        [[SystemSceneDataBase sharedDataBase] updateScene:model];
                        
                    }else if (model.answer_content.length == 6 && [[model.answer_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]){
                        //删除情景
                        
                        NSString *senceID = [model.answer_content substringWithRange:NSMakeRange(4, 2)];
                        senceID = [NSString stringWithFormat:@"%@",[BatterHelp numberHexString:senceID]];
                        
                        if ([[BatterHelp numberHexString:senceID] intValue] >= 3) {
                            //id大于3进行删除。
                            [[SystemSceneDataBase sharedDataBase] deletSystemScene:senceID];
                            [self lodaSystemData];
                        }else{
                            //TODO:小于3代表系统情景，在这里进行颜色重新划分
                            [[SystemSceneDataBase sharedDataBase] updateScene:model];
                            [self lodaSystemData];
                        }
                        
                    }
                }
            }];
            ////* 外网28 */
            [[Hekr sharedInstance] recv:scenScyDic obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    @strongify(self)
                    SceneGroupSelectModel *model =  [[SceneGroupSelectModel alloc] initWithDivicedictionary:data error:nil];
                    if (model) {
                        for (int i = 0; i < _systemSceneListArray.count; i++) {
                            SystemSceneModel *mmodel = _systemSceneListArray[i];
                            if (mmodel.sence_group == model.sence_group) {
                                [config setObject:[NSString stringWithFormat:@"%d",i] forKey:selectSystemItem];
                                _selectSystemItem = i;
                                NSLog(@"\n\n\n\n\n\n\n\n\n选中了%d\n\n\n\n\n\n\n\n\n",_selectSystemItem);
                                [self lodaSystemData];
                                [MBProgressHUD hideHUD];
                                break;
                            }
                        }
                        
                    }else{
                        
                    }
                }
            }];
            ////* 外网128加密 */
            [[Hekr sharedInstance] recv:scenScyDic2 obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    @strongify(self)
                    NSNumber *msgId=data[@"msgId"];
                    SceneGroupSelectModel *model =  [[SceneGroupSelectModel alloc] initWithDivicedictionary:data error:nil];
                    int newa = [Encryptools getDescryption:[model.sence_group intValue] withMsgId:[msgId intValue]];
                    [model setSence_group:[NSString stringWithFormat:@"%d",newa]];

                    if (model) {
                        for (int i = 0; i < _systemSceneListArray.count; i++) {
                            SystemSceneModel *mmodel = _systemSceneListArray[i];
                            if (mmodel.sence_group == model.sence_group) {
                                [config setObject:[NSString stringWithFormat:@"%d",i] forKey:selectSystemItem];
                                _selectSystemItem = i;
                                NSLog(@"\n\n\n\n\n\n\n\n\n选中了%d\n\n\n\n\n\n\n\n\n",_selectSystemItem);
                                [self lodaSystemData];
                                [MBProgressHUD hideHUD];
                                break;
                            }
                        }
                        
                    }else{
                        
                    }
                }
            }];
            ////* 外网27 */
            [[Hekr sharedInstance] recv:scyDic obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    @strongify(self)
                    SceneModel *model =  [[SceneModel alloc] initWithDivicedictionary:data error:nil];
                    if (model.scene_content.length == 6 && [[model.scene_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]) {
                        //删除情景
                        
                        NSString *senceID = [model.scene_content substringWithRange:NSMakeRange(4, 2)];
                        senceID = [NSString stringWithFormat:@"%@",[BatterHelp numberHexString:senceID]];
                        [[SceneDataBase sharedDataBase] deletScene:senceID];
                        [self lodaListData];
                    }else {
                        SceneModel *model = [[SceneModel alloc] initWithDivicedictionary:data error:nil];
                        if (model.scene_content.length>32) {
                            [[SceneDataBase sharedDataBase] updateScene:model];
                        } else if ([model.scene_content isEqualToString:@"OVER"]){
                            [MBProgressHUD hideHUD];
                            
                        }
                    }
                }
            }];
           ////* 外网127加密 */
            [[Hekr sharedInstance] recv:scyDic2 obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    @strongify(self)
                    SceneModel *model =  [[SceneModel alloc] initWithDivicedictionary:data error:nil];
                    if (model.scene_content.length == 6 && [[model.scene_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]) {
                        //删除情景
                        
                        NSString *senceID = [model.scene_content substringWithRange:NSMakeRange(4, 2)];
                        senceID = [NSString stringWithFormat:@"%@",[BatterHelp numberHexString:senceID]];
                        [[SceneDataBase sharedDataBase] deletScene:senceID];
                        [self lodaListData];
                    }else {
                        SceneModel *model = [[SceneModel alloc] initWithDivicedictionary:data error:nil];
                        if (model.scene_content.length>32) {
                            [[SceneDataBase sharedDataBase] updateScene:model];
                        } else if ([model.scene_content isEqualToString:@"OVER"]){
                            [MBProgressHUD hideHUD];
                            
                        }
                    }
                }
            }];
            ////* 内网26 */
            [[MyUdp shared] recv:dic obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    SystemSceneModel *model = [[SystemSceneModel alloc] initWithDivicedictionary:data error:nil];
                    if (model.answer_content.length>32) {
                        [[SystemSceneDataBase sharedDataBase] updateScene:model];
                        
                    }else if (model.answer_content.length == 6 && [[model.answer_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]){
                        //删除情景
                        NSString *senceID = [model.answer_content substringWithRange:NSMakeRange(4, 2)];
                        senceID = [NSString stringWithFormat:@"%@",[BatterHelp numberHexString:senceID]];
                        if ([[BatterHelp numberHexString:senceID] intValue] > 3) {
                            //id大于3进行删除。
                            [[SystemSceneDataBase sharedDataBase] deletSystemScene:senceID];
                            [self lodaSystemData];
                        }else{
                            //TODO:小于3代表系统情景，在这里进行颜色重新划分
                                [[SystemSceneDataBase sharedDataBase] updateScene:model];
                                [self lodaSystemData];
//
                        }
                    }
                }
            }];
            
            ////* 内网126加密 */
            [[MyUdp shared] recv:dic2 obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    NSNumber *msgId=data[@"msgId"];
                    SystemSceneModel *model = [[SystemSceneModel alloc] initWithDivicedictionary:data error:nil];
                    int newa = [Encryptools getDescryption:[model.sence_group intValue] withMsgId:[msgId intValue]];
                    [model setSence_group:[NSString stringWithFormat:@"%d",newa]];
                    if (model.answer_content.length>32) {
                        [[SystemSceneDataBase sharedDataBase] updateScene:model];
                        
                    }else if (model.answer_content.length == 6 && [[model.answer_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]){
                        //删除情景
                        NSString *senceID = [model.answer_content substringWithRange:NSMakeRange(4, 2)];
                        senceID = [NSString stringWithFormat:@"%@",[BatterHelp numberHexString:senceID]];
                        if ([[BatterHelp numberHexString:senceID] intValue] > 3) {
                            //id大于3进行删除。
                            [[SystemSceneDataBase sharedDataBase] deletSystemScene:senceID];
                            [self lodaSystemData];
                        }else{
                            //TODO:小于3代表系统情景，在这里进行颜色重新划分
                            [[SystemSceneDataBase sharedDataBase] updateScene:model];
                            [self lodaSystemData];
                            //
                        }
                    }
                }
            }];
            ////* 内网28 */
            [[MyUdp shared] recv:scenScyDic obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    @strongify(self)
                    SceneGroupSelectModel *model =  [[SceneGroupSelectModel alloc] initWithDivicedictionary:data error:nil];
                    if (model) {
                        [config setObject:[NSString stringWithFormat:@"%@",model.sence_group] forKey:selectSystemItem];
                        _selectSystemItem = [model.sence_group intValue];
                        [self lodaSystemData];
                        [MBProgressHUD hideHUD];
                    }
                }
            }];
            ////* 内网128加密 */
            [[MyUdp shared] recv:scenScyDic2 obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    @strongify(self)
                    NSNumber *msgId=data[@"msgId"];
                    SceneGroupSelectModel *model =  [[SceneGroupSelectModel alloc] initWithDivicedictionary:data error:nil];
                    int newa = [Encryptools getDescryption:[model.sence_group intValue] withMsgId:[msgId intValue]];
                    [model setSence_group:[NSString stringWithFormat:@"%d",newa]];
                    if (model) {
                        [config setObject:[NSString stringWithFormat:@"%@",model.sence_group] forKey:selectSystemItem];
                        _selectSystemItem = [model.sence_group intValue];
                        [self lodaSystemData];
                        [MBProgressHUD hideHUD];
                    }
                }
            }];
            ////* 内网27 */
            [[MyUdp shared] recv:scyDic obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    @strongify(self)
                    SceneModel *model =  [[SceneModel alloc] initWithDivicedictionary:data error:nil];
                    if (model.scene_content.length == 6 && [[model.scene_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]) {
                        //删除情景
                        NSString *senceID = [model.scene_content substringWithRange:NSMakeRange(4, 2)];
                        senceID = [NSString stringWithFormat:@"%@",[BatterHelp numberHexString:senceID]];
                        [[SceneDataBase sharedDataBase] deletScene:senceID];
                        [self lodaListData];
                    }else {
                        SceneModel *model = [[SceneModel alloc] initWithDivicedictionary:data error:nil];
                        if (model.scene_content.length>32) {
                            [[SceneDataBase sharedDataBase] updateScene:model];
                        } else if ([model.scene_content isEqualToString:@"OVER"]){
                            [MBProgressHUD hideHUD];
                        }
                        
                    }
                }
            }];
            
            ////* 内网127 */
            [[MyUdp shared] recv:scyDic2 obj:self callback:^(id obj, id data, NSError *error) {
                if (!error) {
                    @strongify(self)
                    SceneModel *model =  [[SceneModel alloc] initWithDivicedictionary:data error:nil];
                    if (model.scene_content.length == 6 && [[model.scene_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]) {
                        //删除情景
                        NSString *senceID = [model.scene_content substringWithRange:NSMakeRange(4, 2)];
                        senceID = [NSString stringWithFormat:@"%@",[BatterHelp numberHexString:senceID]];
                        [[SceneDataBase sharedDataBase] deletScene:senceID];
                        [self lodaListData];
                    }else {
                        SceneModel *model = [[SceneModel alloc] initWithDivicedictionary:data error:nil];
                        if (model.scene_content.length>32) {
                            [[SceneDataBase sharedDataBase] updateScene:model];
                        } else if ([model.scene_content isEqualToString:@"OVER"]){
                            [MBProgressHUD hideHUD];
                        }
                        
                    }
                }
            }];
        }
    
    _runDevice = model.devTid;
//    [self syncScene];
    
    //
    //查看是否有历史选中情景
    if ([config objectForKey:selectSystemItem]&&_selectSystemItem!=[[config objectForKey:selectSystemItem] intValue]) {
        _selectSystemItem = [[config objectForKey:selectSystemItem] intValue];
        [self.table reloadData];
    }
}


/**
 从数据库读取列表数据
 */
- (void)lodaListData{
    if (_systemSceneListArray.count > _selectSystemItem+1) {
         SystemSceneModel *model = _systemSceneListArray[_selectSystemItem];
        _sceneListArray = [[SceneDataBase sharedDataBase] selectSceneWithArray:model.scene_list_array];
    }   
    
    [self lodaSystemData];
//    [self.table reloadData];
}

/**
 从数据库读取系统情景数据
 */
- (void)lodaSystemData{
    _systemSceneListArray = [[SystemSceneDataBase sharedDataBase] selectScene];
     if (_systemSceneListArray.count >= _selectSystemItem+1) {
         SystemSceneModel *model = _systemSceneListArray[_selectSystemItem];
         _sceneListArray = [[[SceneDataBase sharedDataBase] selectSceneWithArray:model.scene_list_array] mutableCopy];
         NSLog(@"\n\n\n\n\n\n\n\n\n 情景id数量：%lu\n\n\n\n\n\n\n\n",(unsigned long)model.scene_list_array.count);
//         [self.table reloadData];
     }
    [self.table reloadData];
    
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.sceneListArray.count + 1;
    }else{
        return self.systemSceneListArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 1 && indexPath.row == 0){
        //情景列表标题
        SceneTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneTitleCell"];
        cell.titleLabel.text = NSLocalizedString(@"自动执行列表", nil);
        cell.addBtn.tag = 1;
        [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if (indexPath.section == 0){
        //情景列表数据 1...3为固定数据，4之后采用在家模式的图标，然后增加
        SystemSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemSceneCell"];
        SystemSceneModel *model = _systemSceneListArray[indexPath.row];

        //单选框
        cell.selectSceneBtn.tag = 100 + indexPath.row;
        [cell.selectSceneBtn setImage:[UIImage imageNamed:@"noselect_icon"] forState:UIControlStateNormal];
        [cell.selectSceneBtn setImage:[UIImage imageNamed:@"select_blue_icon"] forState:UIControlStateSelected];
        SystemSceneModel *thisModel;
        if (_systemSceneListArray.count >= _selectSystemItem+1) {
            thisModel = _systemSceneListArray[_selectSystemItem];
            
            if ([thisModel.sence_group isEqualToString:model.sence_group]) {
                cell.selectSceneBtn.selected = YES;
            }else{
                cell.selectSceneBtn.selected = NO;
            }
        }
        
        
        [cell.selectSceneBtn addTarget:self action:@selector(selectSystemCell:) forControlEvents:UIControlEventTouchUpInside];
        
        
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = NSLocalizedString(@"在家模式", nil);
                if (_selectSystemItem == indexPath.row) {
                    cell.headerImageView.image = [UIImage imageNamed:@"zjms_hover_icon"];
                    cell.titleLabel.textColor = RGB(40, 184, 215);
                }else{
                    cell.headerImageView.image = [UIImage imageNamed:@"zjms_icon"];
                    cell.titleLabel.textColor = RGB(51, 51, 51);
                }
                break;
            case 1:
                cell.titleLabel.text = NSLocalizedString(@"离家模式", nil);
                if (_selectSystemItem == indexPath.row) {
                    cell.headerImageView.image = [UIImage imageNamed:@"ljms_hover_icon"];
                    cell.titleLabel.textColor = RGB(40, 184, 215);
                }else{
                    cell.headerImageView.image = [UIImage imageNamed:@"ljms_icon"];
                    cell.titleLabel.textColor = RGB(51, 51, 51);
                }
                break;
            case 2:
                cell.titleLabel.text = NSLocalizedString(@"睡眠模式", nil) ;
                if (_selectSystemItem == indexPath.row) {
                    cell.headerImageView.image = [UIImage imageNamed:@"smms_hover_icon"];
                    cell.titleLabel.textColor = RGB(40, 184, 215);
                }else{
                    cell.headerImageView.image = [UIImage imageNamed:@"smms_icon"];
                    cell.titleLabel.textColor = RGB(51, 51, 51);
                }
                break;
            default:{
                
                cell.titleLabel.text = model.scene_name;
                if ([thisModel.sence_group isEqualToString:model.sence_group]) {
                    cell.headerImageView.image = [UIImage imageNamed:@"other_hover_icon"];
                    cell.titleLabel.textColor = RGB(40, 184, 215);
                }else{
                    cell.headerImageView.image = [UIImage imageNamed:@"other_icon"];
                    cell.titleLabel.textColor = RGB(51, 51, 51);
                }
                break;
            }
        }
        
        cell.color.backgroundColor = [UIColor whiteColor];

        if (model.scene_color != nil&&![model.scene_color isEqual:[NSNull null]]) {
            
            if ([model.scene_color isEqualToString:@"00"]||[model.scene_color isEqualToString:@"F8"]) {
                
            }else if ([model.scene_color isEqualToString:@"F1"]){
//                cell.color.backgroundColor = RGB(25,181,254);
                cell.color.backgroundColor = HEXCOLOR(0x33a7ff);
            }else if ([model.scene_color isEqualToString:@"F2"]){
//                cell.color.backgroundColor = RGB(122,13,142);
                cell.color.backgroundColor = HEXCOLOR(0xc968ed);
            }else if ([model.scene_color isEqualToString:@"F3"]){
//                cell.color.backgroundColor = RGB(255,121,175);
                cell.color.backgroundColor = HEXCOLOR(0xf067bb);
            }else if ([model.scene_color isEqualToString:@"F4"]){
//                cell.color.backgroundColor = RGB(46,204,113);
                cell.color.backgroundColor = HEXCOLOR(0x53f6ab);
            }else if ([model.scene_color isEqualToString:@"F5"]){
//                cell.color.backgroundColor = RGB(38,166,91);
                cell.color.backgroundColor = HEXCOLOR(0xa5f7b2);
            }else if ([model.scene_color isEqualToString:@"F6"]){
//                cell.color.backgroundColor = RGB(249,105,14);
                cell.color.backgroundColor = HEXCOLOR(0xf56735);
            }else if ([model.scene_color isEqualToString:@"F7"]){
//                cell.color.backgroundColor = RGB(26,56,144);
                cell.color.backgroundColor = HEXCOLOR(0x4d94ff);
            }else if ([model.scene_color isEqualToString:@"F0"]){
//                cell.color.backgroundColor = RGB(10, 114, 58);
                cell.color.backgroundColor = HEXCOLOR(0x11da28);
            }
        }else{
            switch ([model.sence_group integerValue]) {
                case 0:
//                    cell.color.backgroundColor = RGB(10, 114, 58);
                    cell.color.backgroundColor = HEXCOLOR(0x11da28);
                    break;
                case 1:
//                    cell.color.backgroundColor = RGB(25,181,254);
                    cell.color.backgroundColor = HEXCOLOR(0x33a7ff);
                    break;
                case 2:
//                    cell.color.backgroundColor = RGB(122,13,142);
                    cell.color.backgroundColor = HEXCOLOR(0xc968ed);
                    break;
                case 3:
                    //                    cell.color.backgroundColor = RGB(122,13,142);
                    cell.color.backgroundColor = HEXCOLOR(0xf067bb);
                    break;
                case 4:
                    //                    cell.color.backgroundColor = RGB(122,13,142);
                    cell.color.backgroundColor = HEXCOLOR(0x53f6ab);
                    break;
                case 5:
                    //                    cell.color.backgroundColor = RGB(122,13,142);
                    cell.color.backgroundColor = HEXCOLOR(0xa5f7b2);
                    break;
                case 6:
                    //                    cell.color.backgroundColor = RGB(122,13,142);
                    cell.color.backgroundColor = HEXCOLOR(0xf56735);
                    break;
                case 7:
                    //                    cell.color.backgroundColor = RGB(122,13,142);
                    cell.color.backgroundColor = HEXCOLOR(0x4d94ff);
                    break;
            }

        }
        
        return cell;

    }
    else{
        //情景列表数据
        SceneListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListSceneCell"];
        cell.idLabel.text = [NSString stringWithFormat:@"%02ld",(long)indexPath.row];
        SceneModel *model = _sceneListArray[indexPath.row-1];
        
        if([model.scene_id isEqualToString:@"129"]){
            cell.titleLabel2.scrollTitle = NSLocalizedString(@"PIR默认情景", nil);
            cell.titleLabel2.scrollTitleColor = RGBA(0, 0, 0, 0.5);
            cell.titleLabel.text = @"";
            cell.titleLabel.textColor = RGBA(0, 0, 0, 0.5);
            cell.clickButton.hidden = YES;
        }else if([model.scene_id isEqualToString:@"130"]){
            cell.titleLabel2.scrollTitle = NSLocalizedString(@"门磁默认情景", nil);
            cell.titleLabel2.scrollTitleColor = RGBA(0, 0, 0, 0.5);
            cell.titleLabel.text = @"";
             cell.titleLabel.textColor = RGBA(0, 0, 0, 0.5);
            cell.clickButton.hidden = YES;
        }else if([model.scene_id isEqualToString:@"131"]){
            cell.titleLabel2.scrollTitle = NSLocalizedString(@"老人看护默认情景", nil);
            cell.titleLabel2.scrollTitleColor = RGBA(0, 0, 0, 0.5);
            cell.titleLabel.text = @"";
            cell.titleLabel.textColor = RGBA(0, 0, 0, 0.5);
            cell.clickButton.hidden = YES;
        }else{
            //右侧的箭头是否显示
            cell.titleLabel2.scrollTitleColor = RGBA(0, 0, 0, 1);
            cell.titleLabel2.scrollTitle = model.scene_name;
            cell.titleLabel.textColor = RGBA(0, 0, 0, 1);
            cell.titleLabel.text = @"";
            if ([model.isShouldClick isEqualToString:@"1"]) {
                cell.clickButton.hidden = NO;
            }else{
                cell.clickButton.hidden = YES;
            }
            cell.clickButton.tag = [model.scene_id integerValue];
            [cell.clickButton addTarget:self action:@selector(clickCellButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        //根据内容宽度动态决定是否走马灯显示
        if(cell.titleLabel2.upLabel.frame.size.width<=300){
            [cell.titleLabel2 endScrolling];
        }else{
            [cell.titleLabel2 beginScrolling];
        }
        
        
        return cell;
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

/**
 选中cell事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if (![model.online isEqualToString:@"1"]) {
        [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"当前网关为:%@", nil),NSLocalizedString(@"离线", nil) ] ToView:self.view];
        return;
    }
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"SceneStoryboard" bundle:nil];

    if (indexPath.section == 0) {
        //系统情景跳转
        SystemSceneModel *model = _systemSceneListArray[indexPath.row];

        AddSceneVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddSceneVC"];
        vc.systemSceneId = model.sence_group;
        vc.selectArray = model.scene_list_array;
        vc.color = model.scene_color;
        vc.answer_content = model.answer_content;
        switch (indexPath.row) {
            case 0:
                vc.sceneTitle = @"在家";
                break;
            case 1:
                vc.sceneTitle = @"离家";
                break;
            case 2:
                vc.sceneTitle = @"睡眠";
                break;
            default:
                vc.sceneTitle = model.scene_name;

                break;
        }
        vc.delegate = [RACSubject subject];
        //从详情页面返回后重新获取数据
        [vc.delegate subscribeNext:^(id x) {
            
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *gateway_model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            

        }];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else{
        //情景列表页面
        if (_sceneListArray.count > indexPath.row - 1) {
            SceneModel *model = _sceneListArray[indexPath.row-1];
            if([model.scene_id integerValue] > 128){
                NSString * ds = @"";
                if([model.scene_id integerValue] == 129){
                   ds = NSLocalizedString(@"PIR默认情景说明", nil);
                }else if([model.scene_id integerValue] == 130){
                   ds = NSLocalizedString(@"门磁默认情景说明", nil);
                }else if([model.scene_id integerValue] == 131){
                    ds = NSLocalizedString(@"老人看护默认情景说明", nil);
                }
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:ds preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                addSceneListVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"addSceneListVC"];
                vc.sceneTitle = model.scene_name;
                vc.outItemDatas = [model.scene_outdevice_array mutableCopy];
                vc.selectType = [model.scene_select_type intValue];
                vc.inItemDatas = [model.scene_indevice_array mutableCopy];
                vc.sceneId = model.scene_id;
                vc.scene_content = model.scene_content;
                vc.delegate = [RACSubject subject];
                //从详情页面返回后重新获取数据
                [vc.delegate subscribeNext:^(id x) {
                    
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
            

        }
        
    }
}


/**
 cell点击删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row > 0) {
        //情景列表的删除
        
        SceneModel *model = _sceneListArray[indexPath.row-1];
        
        if([model.scene_id integerValue] > 128 ){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"无法删除默认情景", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
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
                
                [self.sceneListArray enumerateObjectsUsingBlock:^(SceneModel *mmodel, NSUInteger idx, BOOL *stop) {
                    if (mmodel == model) {
                        *stop = YES;
                        
                        if (*stop == YES) {
                            
                            [self.sceneListArray removeObjectAtIndex:indexPath.row-1];
                            [[SceneDataBase sharedDataBase] deletScene:model.scene_id];
                            [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                            [self pushSystemData:model.scene_id];
                            //[self lodaSystemData];
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

    }else if (indexPath.section == 0 && indexPath.row > 2){
        //删除情景组
        if (indexPath.row == _selectSystemItem) {
            [MBProgressHUD showError:NSLocalizedString(@"不能删除当前情景", nil) ToView:GetWindow];
            return;
        }
        
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *deviceModel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        SystemSceneModel *model = _systemSceneListArray[indexPath.row];
        DeleteSystemSceneApi *api = [[DeleteSystemSceneApi alloc] initWithDevTid:deviceModel.devTid CtrlKey:deviceModel.ctrlKey SceneGroup:model.sence_group];
        __block TestObject *obj = [[TestObject alloc] init];
        
        [MBProgressHUD showLoadToView:GetWindow];
        [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            if ([[SystemSceneDataBase sharedDataBase] deletSystemScene:model.sence_group]) {
            
                [self.systemSceneListArray removeObjectAtIndex:indexPath.row];
                [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                //单选框tag重新遍历
                if (indexPath.row < [self.systemSceneListArray count] - 1) {
                    
                    for (int indexa = (int)indexPath.row; indexa <=([self.systemSceneListArray count] - 1);indexa++) {
                        SystemSceneCell *oldSelectCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexa inSection:0]];
                        oldSelectCell.selectSceneBtn.tag = oldSelectCell.selectSceneBtn.tag - 1;
                    }
                }
                
                if (indexPath.row < _selectSystemItem) {
                    _selectSystemItem = _selectSystemItem - 1;
                    
                }else if(indexPath.row == _selectSystemItem&&indexPath.row == [self.systemSceneListArray count] + 1){
                    
                    _selectSystemItem = _selectSystemItem - 1;
                    
                    SystemSceneCell *newSelectCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectSystemItem inSection:0]];
                   
                   
                    [self changeCellStyle:_selectSystemItem andCell:newSelectCell andIsNoYes:YES];
                    [self reloadDataForSceneList];
                }else if(indexPath.row == _selectSystemItem&&indexPath.row < [self.systemSceneListArray count] + 1){
                    //删除选中的
                    SystemSceneCell *newSelectCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectSystemItem inSection:0]];
                    [self changeCellStyle:_selectSystemItem andCell:newSelectCell andIsNoYes:YES];
                    [self reloadDataForSceneList];
                }
                
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                [config setObject:[NSString stringWithFormat:@"%d",_selectSystemItem] forKey:selectSystemItem];
                
            }else{
                [MBProgressHUD showError:NSLocalizedString(@"删除失败", nil) ToView:GetWindow];
            }
            
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
        
    }else if (indexPath.section == 0 && indexPath.row <= 2){
        [MBProgressHUD showError:NSLocalizedString(@"系统情景无法删除", nil) ToView:GetWindow];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除", nil);
}



/**
 cell的编辑状态
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        if (indexPath.section == 0) {
        
            //如果点击掉是[系统]的编辑按钮，则进入删除状态
            return UITableViewCellEditingStyleDelete;
            
        }else{
            
            if (indexPath.row!=0) {
                //情景列表
                if (_clickSection == 0) {
                    //如果点击[系统]的编辑按钮，则无状态
                    return UITableViewCellEditingStyleNone;
                }else{
                    //如果点击[列表]的编辑按钮，则进入删除状态
                    return UITableViewCellEditingStyleDelete;
                }
            }else{
                return UITableViewCellEditingStyleNone;
            }
        }
}

/**
 添加按钮

 @param sender 按钮
 */
-(void)addAction:(UIButton *)sender{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"SceneStoryboard" bundle:nil];
    if (sender.tag == 0) {
        //系统情景的添加按钮
        
        //最多只能添加8条，不能再多了
        if (_systemSceneListArray.count >= 8) {
            [MBProgressHUD showError:NSLocalizedString(@"系统情景最多8条", nil) ToView:self.view];
            return;
        }
        //进入添加页面
        AddSceneVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddSceneVC"];
        vc.delegate = [RACSubject subject];
        //返回数据后，刷新
        @weakify(self)
        [vc.delegate subscribeNext:^(NSString *x) {
            if ([x isEqualToString:@"1"]) {
                @strongify(self)
                [self lodaSystemData];
            }
            
            
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //情景列表的添加按钮
        addSceneListVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"addSceneListVC"];
        vc.delegate = [RACSubject subject];
        //返回数据后，刷新
        [vc.delegate subscribeNext:^(id x) {
            
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


/**
 点击cell的点击事件
 
 @param sender button
 */
- (void)clickCellButton:(UIButton *)sender{
    ClickSceneApi *api = [[ClickSceneApi alloc] initWithSceneId:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
    } failure:^(id data, NSError *error) {
    }];
}


- (void)syncScene{
    NSString *SceneListContent = @"";
    
    NSArray *allSceneListArray = [[SceneDataBase sharedDataBase] selectScenewithoutDefault];
    if (allSceneListArray.count > 0) {
        int maxId = 0;
        for (SceneModel *model in allSceneListArray) {
            if ([[BatterHelp numberHexString:model.scene_id] intValue] > maxId) {
                maxId = [[BatterHelp numberHexString:model.scene_id] intValue];
            }
            NSLog(@"\n\n\n\n\n\n\n\n\nmodelId:%d\n\n\n\n\n\n",[[BatterHelp numberHexString:model.scene_id] intValue]);
        }
        SceneListContent = [BatterHelp gethexBybinary:(maxId * 2 + 2)];
    }else {
        SceneListContent = @"2";
    }
    long scene_count = SceneListContent.length;
    for (int i = 0; i < 4 - scene_count; i++) {
        SceneListContent = [@"0" stringByAppendingString:SceneListContent];
    }
    // 自定义情景CRC补位
    int arrayIndex = 0;
    if (allSceneListArray.count > 0) {
        
        int maxId = 0;
        
        for (SceneModel *model in allSceneListArray) {
            if ([[BatterHelp numberHexString:model.scene_id] intValue] > maxId) {
                maxId = [[BatterHelp numberHexString:model.scene_id] intValue];
            }
        }

        for (int i = 1; i <= maxId; i++) {
            SceneModel *model = allSceneListArray[arrayIndex];
            if (i == [[BatterHelp numberHexString:model.scene_id] intValue]) {
                SceneListContent = [SceneListContent stringByAppendingString:model.scene_CRC];
                arrayIndex ++;
            }else{
                SceneListContent = [SceneListContent stringByAppendingString:@"0000"];
            }
            NSLog(@"\n\n\n\n\n\n\n\n\nmodelId:%d\ni:%d\nindex:%d\nanswerContent：%@\n\n\n\n\n\n",[[BatterHelp numberHexString:model.scene_id] intValue],i,arrayIndex,SceneListContent);
        }
    }
    
    
    // 情景组CRC补位
    SystemSceneModel *lastSystemModel = [_systemSceneListArray lastObject];
    
    NSString *SystemSceneContent = [BatterHelp gethexBybinary:([[BatterHelp numberHexString:lastSystemModel.sence_group] intValue] * 2 + 4)];
    long system_count = SystemSceneContent.length;
    for (int i = 0; i < 4 - system_count; i++) {
        SystemSceneContent = [@"0" stringByAppendingString:SystemSceneContent];
    }
    
    arrayIndex = 0;
    for (int i = 0; i <= [[BatterHelp numberHexString:lastSystemModel.sence_group] intValue]; i++) {
        SystemSceneModel *model = _systemSceneListArray[arrayIndex];
        if (i == [[BatterHelp numberHexString:model.sence_group] intValue]) {
            if (model.scene_CRC) {
                SystemSceneContent = [SystemSceneContent stringByAppendingString:model.scene_CRC];
            }
            
            arrayIndex ++;
        }else{
            SystemSceneContent = [SystemSceneContent stringByAppendingString:@"0000"];
        }

    }

    NSLog(@"沈小鹏啊啊啊啊啊啊啊啊 answerContent：%@   SceneListContent：%@  lastSysId:%@\n\n\n\n",SystemSceneContent,SceneListContent,lastSystemModel.sence_group);
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    SycnSceneApi *api = [[SycnSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneGroup:[NSString stringWithFormat:@"%d",_selectSystemItem] answerContent:SystemSceneContent SceneContent:SceneListContent];
    
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
    } failure:^(id data, NSError *error) {
    }];
    

}

- (void)pushSystemData:(NSString *)scene_group{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];

    for (SystemSceneModel *models in _systemSceneListArray) {
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

#pragma mark 定时切换
- (void)timeSwitch{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if (model == nil || ![model.online isEqualToString:@"1"]) {
        [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"当前网关为:%@", nil),NSLocalizedString(@"离线", nil) ] ToView:self.view];
        return;
    }
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"SceneStoryboard" bundle:nil];
    TimeSwitchVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TimeSwitchVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 选择情景模式
- (void)selectSystemCell:(id)sender{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if (model == nil || ![model.online isEqualToString:@"1"]) {
        [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"当前网关为:%@", nil),NSLocalizedString(@"离线", nil) ] ToView:self.view];
        return;
    }
    
    UIButton *selectBtn = (UIButton*)sender;
    if ((int)(selectBtn.tag - 100) != _selectSystemItem){

        _selectSystemItem = (int)(selectBtn.tag - 100);
        
        //向服务器端发送数据，更新选中信息
        if (!_isSelecting) {
            
            _isSelecting = YES;
            
            SystemSceneModel *systemModel = _systemSceneListArray[_selectSystemItem];
            
            __block TestObject *obj = [[TestObject alloc] init];
            
            ChooseSystemSceneApi *api = [[ChooseSystemSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneGroup:systemModel.sence_group];
            @weakify(self)
            [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
                
                for(int i=0;i<_systemSceneListArray.count;i++){
                    SystemSceneCell *oldSelectCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    if(i!=_selectSystemItem){
                oldSelectCell.selectSceneBtn.selected = NO;
                        [self changeCellStyle:i andCell:oldSelectCell andIsNoYes:NO];
                    }
                }

                
                SystemSceneCell *newSelectCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectSystemItem inSection:0]];
                newSelectCell.selectSceneBtn.selected = YES;
                newSelectCell.titleLabel.textColor = RGB(40, 184, 215);
                
                [config setObject:[NSString stringWithFormat:@"%d",_selectSystemItem] forKey:selectSystemItem];
                
                [self changeCellStyle:_selectSystemItem andCell:newSelectCell andIsNoYes:YES];
                
                //缓存中切换系统情景
                @strongify(self)
                [config setObject:[NSString stringWithFormat:@"%d",_selectSystemItem] forKey:selectSystemItem];
//                [obj setValue:@"1" forKey:@"1"];
                _isSelecting = NO;
                obj = nil;
                SystemSceneModel *model = self.systemSceneListArray[_selectSystemItem];
                self.sceneListArray = [[SceneDataBase sharedDataBase] selectSceneWithArray:model.scene_list_array];
                [self.table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } failure:^(id data, NSError *error) {
                _isSelecting = NO;
//                [obj setValue:@"1" forKey:@"1"];
                obj = nil;
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (obj) {
                    _isSelecting = NO;
                    obj = nil;
                    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                    if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
                        [config setObject:NetworkAppStatus forKey:AppStatus];
                    }
                }
            });
        }
    }
    
}

#pragma mark 情景模式切换情景列表数据刷新
- (void)reloadDataForSceneList{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    //向服务器端发送数据，更新选中信息
    if (!_isSelecting) {
        
        _isSelecting = YES;
        
        SystemSceneModel *systemModel = _systemSceneListArray[_selectSystemItem];
        
        __block TestObject *obj = [[TestObject alloc] init];
        
        ChooseSystemSceneApi *api = [[ChooseSystemSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneGroup:systemModel.sence_group];
        @weakify(self)
        [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
            //缓存中切换系统情景
            @strongify(self)
            [config setObject:[NSString stringWithFormat:@"%d",_selectSystemItem] forKey:selectSystemItem];
//            [obj setValue:@"1" forKey:@"1"];
            _isSelecting = NO;
            obj = nil;
            SystemSceneModel *model = self.systemSceneListArray[_selectSystemItem];
            self.sceneListArray = [[SceneDataBase sharedDataBase] selectSceneWithArray:model.scene_list_array];
            [self.table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } failure:^(id data, NSError *error) {
            _isSelecting = NO;
//            [obj setValue:@"1" forKey:@"1"];
            obj = nil;
        }];
        
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (obj) {
                            _isSelecting = NO;
                            obj = nil;
                            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                            if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
                                [config setObject:NetworkAppStatus forKey:AppStatus];
                            }
                        }
                    });
    }
}


- (void)changeCellStyle:(int)isSelecting andCell:(SystemSceneCell*)cell andIsNoYes:(BOOL)isNoYes{
    
    switch (isSelecting) {
        case 0:
        
            if (isNoYes) {
                cell.headerImageView.image = [UIImage imageNamed:@"zjms_hover_icon"];
                cell.titleLabel.textColor = RGB(40, 184, 215);
            }else{
                cell.headerImageView.image = [UIImage imageNamed:@"zjms_icon"];
                cell.titleLabel.textColor = RGB(51, 51, 51);
            }
            break;
        case 1:
        
            if (isNoYes) {
                cell.headerImageView.image = [UIImage imageNamed:@"ljms_hover_icon"];
                cell.titleLabel.textColor = RGB(40, 184, 215);
            }else{
                cell.headerImageView.image = [UIImage imageNamed:@"ljms_icon"];
                cell.titleLabel.textColor = RGB(51, 51, 51);
            }
            break;
        case 2:
        
            if (isNoYes) {
                cell.headerImageView.image = [UIImage imageNamed:@"smms_hover_icon"];
                cell.titleLabel.textColor = RGB(40, 184, 215);
            }else{
                cell.headerImageView.image = [UIImage imageNamed:@"smms_icon"];
                cell.titleLabel.textColor = RGB(51, 51, 51);
            }
            break;
        default:{
     
            if (isNoYes) {
                cell.headerImageView.image = [UIImage imageNamed:@"other_hover_icon"];
                cell.titleLabel.textColor = RGB(40, 184, 215);
            }else{
                cell.headerImageView.image = [UIImage imageNamed:@"other_icon"];
                cell.titleLabel.textColor = RGB(51, 51, 51);
            }
            break;
        }
    }
}


@end
