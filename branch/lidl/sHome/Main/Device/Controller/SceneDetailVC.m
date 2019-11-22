//
//  SceneDetailVC.m
//  sHome
//
//  Created by CY on 2018/1/28.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "SceneDetailVC.h"
#import "LCActionSheet.h"
#import "DeviceListModel.h"
#import "deleteDeviceApi.h"
#import "replaceDeviceApi.h"
#import "BaseNC.h"
#import "AddDeviceVC.h"
#import "DeviceDataBase.h"
#import "UINavigationBar+Awesome.h"
#import "RenameVC.h"
#import "BatterHelp.h"
#import "SceneSwitchCell.h"
#import "SystemSceneDataBase.h"
#import "AddSystemSceneApi.h"
#import "SystemSceneHelp.h"

@interface SceneDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *table;

@property (nonatomic) UIImageView *bgImageView;
@property (nonatomic) UILabel *MainLabel;
@property (nonatomic) UIImageView *wifiImgV;
@property (nonatomic) UIImageView *batteryImgV;
@property (nonatomic) UILabel *batteryLabel;

@property (nonatomic) NSArray *sceneGroupArray;
@property (nonatomic) NSMutableArray *titles;
@end

@implementation SceneDetailVC {
    CGPoint _bottomPoint;
    CGPoint _beginPoint;
    
    BOOL _isReplcing;
    BOOL _isDeleting;
    BOOL _isSwitching;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    self.sceneGroupArray = [[SystemSceneDataBase sharedDataBase] selectScene];
//    self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"在家", nil), NSLocalizedString(@"离家", nil), NSLocalizedString(@"睡眠", nil), nil];
//    [self.sceneGroupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        SystemSceneModel *model = obj;
//        if (idx > 2) {
//            [self.titles addObject:model.scene_name];
//        }
//    }];
//    [self.titles addObject:NSLocalizedString(@"无", nil)];
//
//    [self setupSceneDetailUI];
//
//    self.navigationController.navigationBar.alpha = 1;
//    NSArray *b = [_data.customTitle componentsSeparatedByString:@" "];
//    if (b.count>1) {
//        self.title = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(b[0],nil),b[1]];
//    }else{
//        self.title = NSLocalizedString(_data.customTitle, nil);
//    }
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"管理",nil) withTintColor:[UIColor whiteColor]];
//
//    [self setPageBackground];
//    [self analysisStatus];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sceneGroupArray = [[SystemSceneDataBase sharedDataBase] selectScene];
    self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"在家", nil), NSLocalizedString(@"离家", nil), NSLocalizedString(@"睡眠", nil), nil];
    [self.sceneGroupArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SystemSceneModel *model = obj;
        if (idx > 2) {
            [self.titles addObject:model.scene_name];
        }
    }];
    
    [self setupSceneDetailUI];
    
    self.navigationController.navigationBar.alpha = 1;
    
    if([_data.customTitle isEqualToString:@""]){
        self.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(_data.title, nil),_data.devID];
    }else{
        self.title = _data.customTitle;
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"管理",nil) withTintColor:[UIColor whiteColor]];
    
    [self setPageBackground];
    [self analysisStatus];
}

- (void)setupSceneDetailUI {
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:_bgImageView];
    
    _MainLabel = [[UILabel alloc] init];
    _MainLabel.font = [UIFont systemFontOfSize:17];
    _MainLabel.textColor = [UIColor blackColor];
    _MainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_MainLabel];
    [_MainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(-15);
        make.top.equalTo(75);
        make.height.equalTo(30);
        make.width.equalTo(100);
    }];
    
    _wifiImgV = [[UIImageView alloc] init];
    [self.view addSubview:_wifiImgV];
    [_wifiImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_MainLabel.mas_left).offset(-45);
        make.centerY.equalTo(_MainLabel);
    }];
    
    _batteryImgV = [[UIImageView alloc] init];
    [self.view addSubview:_batteryImgV];
    [_batteryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_MainLabel);
        make.left.equalTo(_MainLabel.mas_right).offset(35);
    }];
    
    _batteryLabel = [[UILabel alloc] init];
    _batteryLabel.font = [UIFont systemFontOfSize:14.5];
    [self.view addSubview:_batteryLabel];
    [_batteryLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_batteryImgV.mas_right).offset(5);
        make.centerY.equalTo(_batteryImgV);
    }];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.estimatedSectionFooterHeight = 0;
    table.estimatedSectionHeaderHeight = 0;
    table.backgroundColor = [UIColor clearColor];
    table.dataSource = self;
    table.delegate = self;
    table.tableFooterView = [UIView new];
    [table registerClass:[SceneSwitchCell class] forCellReuseIdentifier:@"SceneSwitchCell"];
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerX.equalTo(0);
        make.top.equalTo(_MainLabel.mas_bottom).offset(20);
        make.bottom.equalTo(-30);
    }];
    self.table = table;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sceneGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SceneSwitchCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SystemSceneModel *model = self.sceneGroupArray[indexPath.section];
    if ([model.sence_group isEqualToString:@"0"]) {
        cell.scenelB.text = NSLocalizedString(@"在家", nil);
        [cell.sceneIcon setImage:[[UIImage imageNamed:@"zjms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    else if ([model.sence_group isEqualToString:@"1"]) {
        cell.scenelB.text = NSLocalizedString(@"离家", nil);
        [cell.sceneIcon setImage:[[UIImage imageNamed:@"ljms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    else if ([model.sence_group isEqualToString:@"2"]) {
        cell.scenelB.text = NSLocalizedString(@"睡眠", nil);
        [cell.sceneIcon setImage:[[UIImage imageNamed:@"smms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    else {
        cell.scenelB.text = model.scene_name;
        [cell.sceneIcon setImage:[[UIImage imageNamed:@"other_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }

    NSString *idstr = self.data.devID;
    idstr = [BatterHelp gethexBybinary:[idstr longLongValue]];
    while (idstr.length < 4) {
        idstr = [@"0" stringByAppendingString:idstr];
    }
    [model.dev584_ids_scs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:idstr]) {
            NSString *sid = [obj substringWithRange:NSMakeRange(4, 2)];
            NSInteger index = [BatterHelp numberHexString:sid].integerValue;
            [cell.selectLb setText:self.titles[index]];
            
            if ([self.titles[index] isEqualToString:NSLocalizedString(@"在家", nil)]) {
                [cell.selectIcon setBackgroundImage:[[UIImage imageNamed:@"zjms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            }
            else if ([self.titles[index] isEqualToString:NSLocalizedString(@"离家", nil)]) {
                [cell.selectIcon setBackgroundImage:[[UIImage imageNamed:@"ljms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            }
            else if ([self.titles[index] isEqualToString:NSLocalizedString(@"睡眠", nil)]) {
                [cell.selectIcon setBackgroundImage:[[UIImage imageNamed:@"smms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            }
            else {
                [cell.selectIcon setBackgroundImage:[[UIImage imageNamed:@"other_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            }
        }
    }];
    
    [cell.selectIcon setTag:indexPath.section + 50];
    [cell.selectIcon addTarget:self action:@selector(selectSceneToSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)selectSceneToSwitch:(UIButton *)sender {
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:NSLocalizedString(@"请选择切换的目标情景模式", nil) cancelButtonTitle:NSLocalizedString(@"取消",nil) clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        __block bool over = NO;
        /** 点击取消 */
        if (buttonIndex == 0) {
            return ;
        }
        /** 网关信息 */
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *dmodel = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        
        /** 获取某一行cell 为请求成功后修改UI */
        SceneSwitchCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag-50]];
        
        /** 获取点击的那行的主键情景模式model */
        SystemSceneModel *model = self.sceneGroupArray[sender.tag-50];
        
        /** 情景开关id号：0013 */
        NSString *devidStr = self.data.devID;
        devidStr = [BatterHelp gethexBybinary:[devidStr longLongValue]];
        while (devidStr.length < 4) {
            devidStr = [@"0" stringByAppendingString:devidStr];
        }
        
        /** 先获取原先情景开关数量，判断数据库中的content是否包含当前的情景开关id，不包含，则 +1 ，包含，则不变，转16进制，得到新dev584_count */
        NSString *dev584count = @"";
        if ([model.dev584_ids containsObject:devidStr]) {
            dev584count = model.dev584_count;
        } else {
            NSInteger count584 = [BatterHelp numberHexString:model.dev584_count].integerValue + 1;
            NSString *count584Str = [BatterHelp gethexBybinary:count584];
            dev584count = count584Str.length == 2 ? count584Str : [@"0" stringByAppendingString:count584Str];
        }
        
            /** 选择非取消 **/
            /** 区别与主键情景模式model，这是选择的模式的model，即sheet里点击的那行的模式的model，需要得到那行的情景模式id：02 */
            SystemSceneModel *model1 = self.sceneGroupArray[buttonIndex-1];
            NSString *sceneid = model1.sence_group;
            NSString *new584detail = @"";
            if (![model.dev584_ids containsObject:devidStr]) {
                if (model.dev584_ids.count > 0) {
                    new584detail = [NSString stringWithFormat:@"%@%@%@00000000",model.dev584_detail, devidStr, sceneid.length == 2 ? sceneid : [@"0" stringByAppendingString:sceneid]];
                } else {
                    new584detail = [NSString stringWithFormat:@"%@%@00000000", devidStr, sceneid.length == 2 ? sceneid : [@"0" stringByAppendingString:sceneid]];
                }
                
            } else {
                for (int i = 0; i < model.dev584_ids.count; i++) {
                    if ([model.dev584_ids[i] isEqualToString:devidStr]) {
                        new584detail = [[model.dev584_detail copy] stringByReplacingCharactersInRange:NSMakeRange(4+(i*14), 2) withString:sceneid.length == 2 ? sceneid : [@"0" stringByAppendingString:sceneid]];
                    }
                }
            }

            /** 拼接可得content */
            NSString *content = [SystemSceneHelp getSceneContent:self.titles[sender.tag - 50] SceneId:model.sence_group ButtonCotent:dev584count sceneArray:model.scene_list_array color:model.scene_color andButtonsDetail:new584detail];
        
            MJWeakSelf
            AddSystemSceneApi *api = [[AddSystemSceneApi alloc] initWithDevTid:dmodel.devTid CtrlKey:dmodel.ctrlKey SceneContent:[content substringWithRange:NSMakeRange(0, content.length - 4)]];
        
            [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                
                if (over == NO) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    cell.selectLb.text = strongSelf.titles[buttonIndex-1] ;
                    
                    if ([strongSelf.titles[buttonIndex-1] isEqualToString:NSLocalizedString(@"在家", nil)]) {
                        [cell.selectIcon setBackgroundImage:[[UIImage imageNamed:@"zjms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                    }
                    else if ([strongSelf.titles[buttonIndex-1] isEqualToString:NSLocalizedString(@"离家", nil)]) {
                        [cell.selectIcon setBackgroundImage:[[UIImage imageNamed:@"ljms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                    }
                    else if ([strongSelf.titles[buttonIndex-1] isEqualToString:NSLocalizedString(@"睡眠", nil)]) {
                        [cell.selectIcon setBackgroundImage:[[UIImage imageNamed:@"smms_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                    }
                    else {
                        [cell.selectIcon setBackgroundImage:[[UIImage imageNamed:@"other_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                    }
                    
                    model.answer_content = [content substringWithRange:NSMakeRange(0, content.length - 4)];
                    [[SystemSceneDataBase sharedDataBase] updateScene:model];
                }
                if (data) {
                    over = YES;
                }
                
            } failure:^(id data, NSError *error) {
                
            }];
        
    } otherButtonTitleArray:self.titles];
    
    sheet.buttonFont = [UIFont systemFontOfSize:14];
    sheet.buttonHeight = 44.0f;
    sheet.buttonColor = RGB(36, 155, 255);
    sheet.unBlur = YES;
    [sheet show];
}

/**
 
NSString *content = [SystemSceneHelp getSceneContent:_titleTextFiled.text SceneId:_systemSceneId ButtonCotent:_buttonContent sceneArray:_selectArray color:self.color];

 显示设备状态
 */

- (void)analysisStatus{
    
    if (![self.data.status isEqualToString:@"no"]) {
        NSString *signal = [_data.statuCode substringWithRange:NSMakeRange(0, 2)];
        if ([signal isEqualToString:@"04"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi04"]];
        }
        else if ([signal isEqualToString:@"03"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi03"]];
        }
        else if ([signal isEqualToString:@"02"]){
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi02"]];
        }
        else if ([signal isEqualToString:@"01"]) {
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        }
        else{
            [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        }
        
        NSString *battery = [_data.statuCode substringWithRange:NSMakeRange(2, 2)];
        if ([battery isEqualToString:@"FF"]) {
        }
        else if ([battery isEqualToString:@"80"]){
            self.batteryLabel.text = @"0%";
        }
        else if ([battery isEqualToString:@"64"]){
            self.batteryLabel.text = @"100%";
            [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg100_icon"]];
        }
        else{
            self.batteryLabel.text = [NSString stringWithFormat:@"%@%%",[BatterHelp getBatterFormDevice:battery]];
            if ([[BatterHelp getBatterFormDevice:battery] intValue]<100 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 80) {
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg80_icon"]];
            } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<80 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 60) {
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg60_icon"]];
            } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<60 && [[BatterHelp getBatterFormDevice:battery] intValue] >= 40) {
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg40_icon"]];
            } else if ([[BatterHelp getBatterFormDevice:battery] intValue]<40) {
                [self.batteryImgV setImage:[UIImage imageNamed:@"dcmg40_icon"]];
            }
        }
    }
    else {
        [self.wifiImgV setImage:[UIImage imageNamed:@"wifi01"]];
        _batteryLabel.text = NSLocalizedString(@"",nil);
    }
}
/**
 设备背景图片
 */
-(void)setPageBackground{
    if ([_data.status isEqualToString:@"aq"]) {
        [_bgImageView setImage:[UIImage imageNamed:@"sbgreen_bg"]];
        _MainLabel.text = NSLocalizedString(@"正常",nil);
//        _MainLabel.textColor = RGB(0, 191, 102);
    }
    else if ([_data.status isEqualToString:@"gz"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sborange_bg"]];
        _MainLabel.text = NSLocalizedString(@"故障",nil);
//        _MainLabel.textColor = RGB(255, 179, 0);
    }
    else if ([_data.status isEqualToString:@"bj"]) {
        [_bgImageView setImage:[UIImage imageNamed:@"sbred_bg"]];
        _MainLabel.text = NSLocalizedString(@"报警",nil);
//        _MainLabel.textColor = RGB(245, 52, 35);
    }
    else if ([_data.status isEqualToString:@"no"]){
        [_bgImageView setImage:[UIImage imageNamed:@"sbgray_bg"]];
        _MainLabel.text = NSLocalizedString(@"NO",nil);
//        _MainLabel.textColor = RGB(192, 203, 223);
    }
}

- (void)clickItem{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    deleteDeviceApi *deleteApi = [[deleteDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey mDeviceID:_data.devID];
    replaceDeviceApi *replaceApi = [[replaceDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey mDeviceID:_data.devID];
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        WS(ws)
        if (buttonIndex == 2) {
            if (!_isDeleting) {
                __block NSObject *obj = [[NSObject alloc] init];
                _isDeleting = YES;
                [deleteApi startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
                    _isDeleting = NO;
                    
                    NSDictionary *dic = data;
                    dic = [dic objectForKey:@"params"];
                    dic = [dic objectForKey:@"data"];
                    long isSuccess = [[dic objectForKey:@"answer_yes_or_no"] longValue];
                    if (isSuccess == 2) {
                        [ws deleteDevice];
                        [ws.navigationController popViewControllerAnimated:YES];
                    }else{
                        [MBProgressHUD showError:NSLocalizedString(@"删除失败",nil) ToView:ws.view];
                    }
//                    [obj setValue:@"1" forKey:@"1"];
                    obj = nil;
                } failure:^(id data, NSError *error) {
                    _isDeleting = NO;
//                    [obj setValue:@"1" forKey:@"1"];
                    obj = nil;
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_isDeleting) {
                        _isDeleting = NO;
                        [MBProgressHUD showError:NSLocalizedString(@"删除失败",nil) ToView:ws.view];
                        obj = nil;
                        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                        if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
                            [config setObject:NetworkAppStatus forKey:AppStatus];
                        }
                    }
                });
            }
            
        }else if (buttonIndex == 1){
            if (!_isReplcing) {
                __block NSObject *obj = [[NSObject alloc] init];
                _isReplcing = YES;
                [replaceApi startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
                    _isReplcing = NO;
                    NSDictionary *dic = data;
                    dic = [dic objectForKey:@"params"];
                    dic = [dic objectForKey:@"data"];
                    long isSuccess = [[dic objectForKey:@"answer_yes_or_no"] longValue];
                    if (isSuccess == 2) {
                        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"DeviceStoryboard" bundle:nil];
                        AddDeviceVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddDeviceVC"];
                        vc.type = ws.data.devID;
                        BaseNC *nav = [[BaseNC alloc] initWithRootViewController:vc];
                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
                        [ws.navigationController presentViewController:nav animated:YES completion:nil];
                        [ws.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        [MBProgressHUD showError:NSLocalizedString(@"替换失败",nil) ToView:ws.view];
                    }
//                    [obj setValue:@"1" forKey:@"1"];
                    obj = nil;
                } failure:^(id data, NSError *error) {
//                    [obj setValue:@"1" forKey:@"1"];
                    obj = nil;
                    _isReplcing = NO;
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_isReplcing) {
                        obj = nil;
                        _isReplcing = NO;
                        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                        if ([[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]){
                            [config setObject:NetworkAppStatus forKey:AppStatus];
                        }
                    }
                });
            }
            
        }else if(buttonIndex == 3){
            UIStoryboard *deviceStoryboard = [UIStoryboard storyboardWithName:@"DeviceStoryboard" bundle:nil];
            RenameVC *vc = [deviceStoryboard instantiateViewControllerWithIdentifier:@"RenameVC"];
            vc.deviceId = self.data.devID;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
        }
    } otherButtonTitles:NSLocalizedString(@"替换设备",nil),NSLocalizedString(@"删除设备",nil),NSLocalizedString(@"重命名",nil), nil];
    actionSheet.buttonFont = [UIFont systemFontOfSize:14];
    actionSheet.buttonHeight = 44.0f;
    actionSheet.buttonColor = RGB(36, 155, 255);
    actionSheet.unBlur = YES;
    [actionSheet show];
}

- (void)deleteDevice{
    [[DeviceDataBase sharedDataBase] deletDevice:[_data.devID intValue]];
    [MBProgressHUD showSuccess:NSLocalizedString(@"删除成功",nil) ToView:self.view];
}

- (void)dealloc {
    NSLog(@"情景开关详情页释放了情景开关详情页释放了情景开关详情页释放了情景开关详情页释放了");
}


@end
