//
//  AddSceneVC.m
//  sHome
//
//  Created by shaop on 2016/12/18.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "AddSceneVC.h"
#import "AddSystemScenCell.h"
#import "SceneDataBase.h"
#import "ChooseSwitchVC.h"
#import "SystemSceneHelp.h"
#import "AddSystemSceneApi.h"
#import "DeviceListModel.h"
#import "SelectColorCell.h"
#import "SystemSceneDataBase.h"
#import "BatterHelp.h"

@interface AddSceneVC ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic, weak) UITextField *titleTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *addNumberBtn;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *mSelectIdArray;
@property (strong,nonatomic) NSMutableArray *morenArray;
@end

@implementation AddSceneVC
{
    NSString *_buttonContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];

  
    
    self.mSelectIdArray = [NSMutableArray array];
    for (SceneModel *selectModel in _selectArray) {
        [self.mSelectIdArray addObject:selectModel.scene_id];
    }
    
    _buttonContent = @"";
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    
    self.addNumberBtn.layer.cornerRadius = 22.0f;
    
    _array = [[NSMutableArray alloc] init];
    _array = [[SceneDataBase sharedDataBase] selectScenewithoutDefaultwithoutGs361];
    
    _morenArray = [[SceneDataBase sharedDataBase] selectScenewithDefault];
    
    [_table reloadData];

    UITextField * enterTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width-60, 30)];
    enterTextField.backgroundColor = RGB(242, 242, 245);
    enterTextField.layer.cornerRadius = 15.0f;
    enterTextField.textColor = [UIColor blackColor];
    enterTextField.placeholder = NSLocalizedString(@"请输入情景模式名称", nil);
    CGRect frame = enterTextField.frame;
    frame.size.width = 20;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    enterTextField.leftViewMode = UITextFieldViewModeAlways;
    enterTextField.leftView = leftview;
    _titleTextFiled = enterTextField;
    if ([_sceneTitle isEqualToString:@"在家"]||
        [_sceneTitle isEqualToString:@"离家"]||
        [_sceneTitle isEqualToString:@"睡眠"]) {
        _titleTextFiled.text = NSLocalizedString([_sceneTitle substringWithRange:NSMakeRange(0, 2)], nil);
        _titleTextFiled.enabled = NO;
    }else if (_sceneTitle){
        _titleTextFiled.text = _sceneTitle;
    }
    self.navigationItem.titleView = enterTextField;
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(popself) image:@"back_icon" highImage:@"back_icon" withTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:ThemeColor];
    
    if (self.color == nil) {

        if (_systemSceneId!=nil&&![_systemSceneId isEqual:[NSNull null]]) {
            self.color = [NSString stringWithFormat:@"F%@",[NSNumber numberWithInt:[_systemSceneId intValue]]];
        }else{
            NSMutableArray *array = [[SystemSceneDataBase sharedDataBase] selectScene];
            SystemSceneModel *model = [array objectAtIndex:array.count-1];
            NSString *scene_id = [NSString stringWithFormat:@"%d",[model.sence_group intValue] + 1];
            while (YES) {
                if (![SystemSceneHelp isAddSceneId:scene_id]) {
                    scene_id = [NSString stringWithFormat:@"%d",[scene_id intValue] + 1];
                }else{
                    break;
                }
            }
            self.color = [NSString stringWithFormat:@"F%@",[NSNumber numberWithInt:[scene_id intValue]]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)popself{
    _selectArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<_array.count; i++) {
        for (int j = 0; j < self.mSelectIdArray.count; j++) {
            SceneModel *model = _array[i];
            if ([model.scene_id isEqualToString:_mSelectIdArray[j]]) {
                [_selectArray addObject:model];
            }
        }
    }
    for (int i = 0; i<_morenArray.count; i++) {
        for (int j = 0; j < self.mSelectIdArray.count; j++) {
            SceneModel *model = _morenArray[i];
            if ([model.scene_id isEqualToString:_mSelectIdArray[j]]) {
                [_selectArray addObject:model];
            }
        }
    }
    NSString *content = [SystemSceneHelp getSceneContent:_titleTextFiled.text SceneId:_systemSceneId ButtonCotent:_buttonContent sceneArray:_selectArray color:self.color andButtonsDetail:@""];

    NSLog(@"self.content = %@ \n content = %@", self.answer_content, content);
    NSString *content1 = @"";
    NSString *content2 = @"";
    if (self.answer_content.length > 32) {
        content1 = [self.answer_content substringWithRange:NSMakeRange(6, 32)];
        content2 = [self.answer_content stringByReplacingOccurrencesOfString:content1 withString:@""];
    }
    NSString *content3 = [content substringWithRange:NSMakeRange(6, 32)];
    NSString *content4 = [content stringByReplacingOccurrencesOfString:content3 withString:@""];
    content4 = [content4 substringWithRange:NSMakeRange(0, content4.length - 4)];
    
    //000000 数据为空时的判断
    if ([[self.answer_content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"0000"]) {
        if ([_systemSceneId isEqualToString:@"0"]) {
            if ([content4 isEqualToString:@"0026000000F0"]) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
        } else if ([_systemSceneId isEqualToString:@"1"]) {
            if ([content4 isEqualToString:@"0026000000F1"]) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
        } else if ([_systemSceneId isEqualToString:@"2"]) {
            if ([content4 isEqualToString:@"0026000000F2"]) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
        }
    }
    
    //不为空时的012与其他分类讨论
    if ([_systemSceneId isEqualToString:@"0"] || [_systemSceneId isEqualToString:@"1"] || [_systemSceneId isEqualToString:@"2"]) {
        if ([content2 isEqualToString:content4] || (self.titleTextFiled.text.length == 0 && self.answer_content == nil)) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    } else {
        if ([self.answer_content isEqualToString:content] || (self.titleTextFiled.text.length == 0 && self.answer_content == nil)) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
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

-(void)clickItem{
    [self.view endEditing:YES];
    if (self.titleTextFiled.text.length <= 0) {
        [MBProgressHUD showError:NSLocalizedString(@"名称为空", nil) ToView:self.view];
        return;
    }
    
    if ([self.titleTextFiled.text containsString:@"@"] || [self.titleTextFiled.text containsString:@"$"]) {
        [MBProgressHUD showError:NSLocalizedString(@"名称含有非法字符", nil) ToView:self.view];
        return;
    }
    
    NSStringEncoding enc = NSUTF8StringEncoding;//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *namedata = [_titleTextFiled.text dataUsingEncoding:enc];
    if (namedata.length >= 15) {
        [MBProgressHUD showError:NSLocalizedString(@"情景名称过长", nil) ToView:self.view];
        return;
    }
    
    _selectArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<_array.count; i++) {
        for (int j = 0; j < self.mSelectIdArray.count; j++) {
            SceneModel *model = _array[i];
            if ([model.scene_id isEqualToString:_mSelectIdArray[j]]) {
                [_selectArray addObject:model];
            }
        }
    }
    for (int i = 0; i<_morenArray.count; i++) {
        for (int j = 0; j < self.mSelectIdArray.count; j++) {
            SceneModel *model = _morenArray[i];
            if ([model.scene_id isEqualToString:_mSelectIdArray[j]]) {
                [_selectArray addObject:model];
            }
        }
    }
    
    if ([_sceneTitle isEqualToString:@"在家"]||
        [_sceneTitle isEqualToString:@"离家"]||
        [_sceneTitle isEqualToString:@"睡眠"]) {
        
    }
//    else if (_selectArray.count == 0) {
//        [MBProgressHUD showError:NSLocalizedString(@"请添加相关情景", nil) ToView:self.view];
//        return;
//    }
    
    NSString *content = [SystemSceneHelp getSceneContent:_titleTextFiled.text SceneId:_systemSceneId ButtonCotent:_buttonContent sceneArray:_selectArray color:self.color andButtonsDetail:@""];
    
//    NSString *content;
//    if ([_systemSceneId isEqualToString:@"0"]) {
//        content = [SystemSceneHelp getSceneContent:@"Home" SceneId:_systemSceneId ButtonCotent:_buttonContent sceneArray:_selectArray color:self.color];
//    } else if ([_systemSceneId isEqualToString:@"1"]) {
//        content = [SystemSceneHelp getSceneContent:@"Away" SceneId:_systemSceneId ButtonCotent:_buttonContent sceneArray:_selectArray color:self.color];
//    } else if ([_systemSceneId isEqualToString:@"2"]) {
//        content = [SystemSceneHelp getSceneContent:@"Sleep" SceneId:_systemSceneId ButtonCotent:_buttonContent sceneArray:_selectArray color:self.color];
//    } else {
//        content = [SystemSceneHelp getSceneContent:_titleTextFiled.text SceneId:_systemSceneId ButtonCotent:_buttonContent sceneArray:_selectArray color:self.color];
//    }
    
//    SystemSceneModel *systemModel = [[SystemSceneModel alloc] init];
//    systemModel.sence_group = _systemSceneId;
//    systemModel.answer_content = [content substringWithRange:NSMakeRange(0, content.length - 4)];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    AddSystemSceneApi *api = [[AddSystemSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneContent:content];
    @weakify(self)
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
//        [[SystemSceneDataBase sharedDataBase] updateScene:systemModel];
        [self.delegate sendNext:nil];
    } failure:^(id data, NSError *error) {
        
    }];
    NSLog(@"\n\n\n\n\n\ncontent%@\n\n\n\n\n\n",content);
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return _morenArray.count+1;
    }else{
        return _array.count+1;
    }

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
        
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addScenTitleCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"请选择颜色", nil);
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = SYSTEMFONT(14);
            return cell;
        }else{
            SelectColorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectColorCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.currtetColor = self.color;
            cell.colorSelected = ^(NSString *color) {
                _color = color;
            };
            return cell;
        }
    }else if(indexPath.section==1){
        if(indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addScenTitleCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"默认情景", nil);
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = SYSTEMFONT(14);
            return cell;
        }else{
            AddSystemScenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addScenCell"];
            SceneModel *model = _morenArray[indexPath.row-1];
            cell.idLabel.text = [NSString stringWithFormat:@"%02ld",(long)(indexPath.row)];
            if([model.scene_id isEqualToString:@"129"]){
                cell.titleLabel.text = @" ";
                cell.titleLabel2.scrollTitle = NSLocalizedString(@"PIR默认情景", nil);
            }else if([model.scene_id isEqualToString:@"130"]){
                cell.titleLabel.text = @" ";
                cell.titleLabel2.scrollTitle = NSLocalizedString(@"门磁默认情景", nil);
            }else if([model.scene_id isEqualToString:@"131"]){
                cell.titleLabel.text = @" ";
                cell.titleLabel2.scrollTitle = NSLocalizedString(@"老人看护默认情景", nil);
            }else{
                cell.titleLabel.text = @" ";
                cell.titleLabel2.scrollTitle = model.scene_name;
            }
            //根据内容宽度动态决定是否走马灯显示
            if(cell.titleLabel2.upLabel.frame.size.width<=300){
                [cell.titleLabel2 endScrolling];
            }else{
                [cell.titleLabel2 beginScrolling];
            }
            [cell.selectButton setImage:[UIImage imageNamed:@"noselect_icon"] forState:UIControlStateNormal];
            [cell.selectButton setImage:[UIImage imageNamed:@"select_yellow_icon"] forState:UIControlStateSelected];
            cell.selectButton.selected = NO;
            for (NSString *selectId in self.mSelectIdArray) {
                if ([selectId isEqualToString:model.scene_id]) {
                    cell.selectButton.selected = YES;
                    break;
                }
            }
            return cell;
        }

    }
    else{
        
        if(indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addScenTitleCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"自定义情景", nil);
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = SYSTEMFONT(14);
            return cell;
        }else{
            AddSystemScenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addScenCell"];
            
            SceneModel *model = _array[indexPath.row-1];
            
            
            
            cell.idLabel.text = [NSString stringWithFormat:@"%02ld",(long)(indexPath.row)];
                cell.titleLabel.text = @" ";
                cell.titleLabel2.scrollTitle = model.scene_name;
            //根据内容宽度动态决定是否走马灯显示
            if(cell.titleLabel2.upLabel.frame.size.width<=300){
                [cell.titleLabel2 endScrolling];
            }else{
                [cell.titleLabel2 beginScrolling];
            }
            
            [cell.selectButton setImage:[UIImage imageNamed:@"noselect_icon"] forState:UIControlStateNormal];
            [cell.selectButton setImage:[UIImage imageNamed:@"select_yellow_icon"] forState:UIControlStateSelected];
            cell.selectButton.selected = NO;
            
            NSLog(@"%@",self.mSelectIdArray);
            
            for (NSString *selectId in self.mSelectIdArray) {
                if ([selectId isEqualToString:model.scene_id]) {
                    cell.selectButton.selected = YES;
                    break;
                }
            }
            
            return cell;
        }

    }
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section>0){
        return 44;
    }
    
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1){
        if(indexPath.row > 0){
            SceneModel *model = _morenArray[indexPath.row-1];
            
            AddSystemScenCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectButton.selected = !cell.selectButton.selected;
            if (cell.selectButton.selected) {
                [self.mSelectIdArray addObject:model.scene_id];
            }else {
                [self.mSelectIdArray removeObject:model.scene_id];
            }
        }
    }
    else if (indexPath.section == 2) {
        if(indexPath.row>0){
            SceneModel *model = _array[indexPath.row-1];
            
            AddSystemScenCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.selectButton.selected = !cell.selectButton.selected;
            if (cell.selectButton.selected) {
                [self.mSelectIdArray addObject:model.scene_id];
            }else {
                [self.mSelectIdArray removeObject:model.scene_id];
            }
        }

    }
}

- (IBAction)selectSwitchAction:(id)sender {
    [self performSegueWithIdentifier:@"toSelectSwitch" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ChooseSwitchVC *vc  = segue.destinationViewController;
    vc.delegate = [RACSubject subject];
    [vc.delegate subscribeNext:^(id x) {
        _buttonContent = x;
        
    }];
}



@end
