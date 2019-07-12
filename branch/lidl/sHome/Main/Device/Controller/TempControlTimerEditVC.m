//
//  TempControlTimerEditVC.m
//  sHome
//
//  Created by tracyhenry on 2018/11/6.
//  Copyright © 2018 shaop. All rights reserved.
//

#import "TempControlTimerEditVC.h"
#import "BatterHelp.h"
#import "PickViewCell.h"
#import "TempViewCell.h"
#import "WeekCell.h"
#import "SceneDataBase.h"
#import "SceneModel.h"
#import "SceneListItemData.h"
#import "ItemDataHelp.h"
#import "addSceneApi.h"
#import "DeviceListModel.h"
#import "SystemSceneModel.h"
#import "SystemSceneDataBase.h"
#import "PushSystemSceneApi.h"

@interface TempControlTimerEditVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UIPickerView *pickview_time;
@property (nonatomic , strong) UIPickerView *pickview_temp;
@property (nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) NSMutableArray *tomodelist;
@property(nonatomic,strong) SceneModel *thismodel;
@end
@implementation TempControlTimerEditVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title =NSLocalizedString(@"编辑定时", nil);
    
    if(_mid!=nil){
   
        _thismodel = [[SceneDataBase sharedDataBase] selectScene:_mid];
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(confirmAction) image:@"yes_icon" highImage:@"topadd_blue_icon" withTintColor:ThemeColor];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(backfinish) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
    [self tableview];
}


-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}


#pragma -mark lazy
-(UITableView *)tableview{
    if(_tableview==nil){
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.rowHeight = 60;
        _tableview.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _tableview.backgroundColor = RGB(239, 239, 243);
        _tableview.tableFooterView = [UIView new];
        [self.view addSubview:_tableview];
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _tableview;
}


#pragma -mark tableview

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"选择切换时间", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            PickViewCell *cell = [[PickViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pickViewCell"];
            _pickview_time = cell.pickview;
            if(self.thismodel!=nil){
                SceneListItemData *data = [_thismodel.scene_outdevice_array objectAtIndex:0];
                if(data!=nil && data.hour!=nil && data.minute!=nil){
                    [cell.pickview selectRow:[data.hour intValue] inComponent:0 animated:NO];
                    [cell.pickview selectRow:[data.minute intValue] inComponent:2 animated:NO];
                }
            }
            return cell;
        }
        
    }
    else if(indexPath.section ==1){
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"设定温度", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            TempViewCell *cell = [[TempViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell3"];
            _pickview_temp = cell.pickview;
            if(self.thismodel!=nil){
                SceneListItemData *data = [_thismodel.scene_indevice_array objectAtIndex:0];
                if(data!=nil){
                    NSString *status1 = [data.action substringWithRange:NSMakeRange(0, 2)];
                    int ds = [[BatterHelp numberHexString:status1] intValue];
                    int xiaoshu = (0x20) & ds;
                    int sta =  ((0x1F) & ds);
                    if(sta>=5&&sta<=30){
                         [cell.pickview selectRow:(sta-5) inComponent:0 animated:NO];
                        [cell.pickview selectRow:(xiaoshu==0?0:1) inComponent:2 animated:NO];
                    }

                    
                }
            }
            
            return cell;
        }
    }
    else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleViewCell4"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"星期", nil);
            cell.textLabel.font = SYSTEMFONT(13);
            return cell;
        }else{
            WeekCell *cell = [[WeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"weekViewCell"];
            if(self.thismodel!=nil){
                SceneListItemData *data = [_thismodel.scene_outdevice_array objectAtIndex:0];
                if(data!=nil && data.week!=nil){
                    NSString *binweek = [BatterHelp getBinaryByhex:data.week];
                    cell.week = binweek;
                }
            }
            return cell;
        }
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.row != 0) {
            return 160;
        }
    }else if(indexPath.section == 2){
        if (indexPath.row != 0) {
            return 80;
        }
    }
    
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
    return nilView;
}


#pragma  -mark  method

-(void)confirmAction{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    WeekCell *vd =(WeekCell *)[[self tableview] cellForRowAtIndexPath:indexPath];
    NSString *shi = [BatterHelp getDecimalBybinary:[vd getWeek]];
    if([shi isEqualToString:@"0"]){
        [MBProgressHUD showError:NSLocalizedString(@"请选择星期", nil) ToView:self.view];
        return;
    }
    
    NSString *ss = [BatterHelp gethexBybinary:[shi intValue]];
    for(int i = 0;i<2-ss.length;i++){
        ss = [@"0" stringByAppendingString:ss];
    }
    
    int  ds= 0x00;
    ds= (([_pickview_temp selectedRowInComponent:2]==0?0x00:0x20)|ds);
    ds= ((([_pickview_temp selectedRowInComponent:0]+5)&0x1F)|ds);
    NSString *comd = [BatterHelp gethexBybinary: (long)ds];
    comd = (comd.length == 2 ? comd : [@"0" stringByAppendingString:comd]);
    comd = [comd stringByAppendingString:@"800000"];
    SceneListItemData *data = [[SceneListItemData alloc] init];
    [data setDeviceId:_devID];
    [data setTitle:@"温控器"];
    [data setAction:comd];
    
    SceneListItemData *data2 = [[SceneListItemData alloc] init];
    [data2 setWeek:ss];
    [data2 setHour:[NSString stringWithFormat:@"%02ld",[_pickview_time selectedRowInComponent:0]]];
    [data2 setMinute:[NSString stringWithFormat:@"%02ld",[_pickview_time selectedRowInComponent:2]]];
    
    NSMutableArray *outarray = [NSMutableArray new];
    NSMutableArray *inarray = [NSMutableArray new];
    [outarray addObject:data2];
    [inarray addObject:data];
    
    NSString *content = [ItemDataHelp SceneContentWithOutputArray:outarray inputAraary:inarray type:0 name:(_mid==nil?@"":_thismodel.scene_name) sceneid:_mid];
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    [MBProgressHUD showLoadToView:GetWindow];
    @weakify(self);
    addSceneApi *api = [[addSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneTpye:@"0" SceneContent:content];
    __block NSObject *obj = [[NSObject alloc] init];
    [api startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        SceneModel *sce = [[SceneModel alloc] init];
        [sce setScene_name:(_mid==nil?@"":_thismodel.scene_name)];
        [sce setScene_content:content];
        NSString * sceneId = [content substringWithRange:NSMakeRange(4, 2)];
        [sce setScene_id:[NSString stringWithFormat:@"%d",[sceneId intValue]]];
        [[SceneDataBase sharedDataBase] updateScene:sce];
        [self pushSystemData:content];
        [self.navigationController popViewControllerAnimated:YES];

        obj = nil;
    } failure:^(id data, NSError *error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        obj = nil;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (obj) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            [MBProgressHUD showError:NSLocalizedString(@"添加失败", nil) ToView:GetWindow];
            obj = nil;
        }
    });
}

-(void)backfinish{
    if(self.mid==nil){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        WeekCell *vd =(WeekCell *)[[self tableview] cellForRowAtIndexPath:indexPath];
        NSString *shi = [BatterHelp getDecimalBybinary:[vd getWeek]];
        if(![shi isEqualToString:@"0"]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否保存此次修改", nil) preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self.navigationController popViewControllerAnimated:YES];


            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"保存", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self confirmAction];
            }]];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        WeekCell *vd =(WeekCell *)[[self tableview] cellForRowAtIndexPath:indexPath];
        NSString *shi = [BatterHelp getDecimalBybinary:[vd getWeek]];
        NSString *ss = [BatterHelp gethexBybinary:[shi intValue]];
        for(int i = 0;i<2-ss.length;i++){
            ss = [@"0" stringByAppendingString:ss];
        }
        
        int  ds= 0x00;
        ds= (([_pickview_temp selectedRowInComponent:2]==0?0x00:0x20)|ds);
        ds= ((([_pickview_temp selectedRowInComponent:0]+5)&0x1F)|ds);
        NSString *comd = [BatterHelp gethexBybinary: (long)ds];
        comd = (comd.length == 2 ? comd : [@"0" stringByAppendingString:comd]);
        comd = [comd stringByAppendingString:@"800000"];
        SceneListItemData *data = [[SceneListItemData alloc] init];
        [data setDeviceId:_devID];
        [data setTitle:@"温控器"];
        [data setAction:comd];
        
        SceneListItemData *data2 = [[SceneListItemData alloc] init];
        [data2 setWeek:ss];
        [data2 setHour:[NSString stringWithFormat:@"%02ld",[_pickview_time selectedRowInComponent:0]]];
        [data2 setMinute:[NSString stringWithFormat:@"%02ld",[_pickview_time selectedRowInComponent:2]]];
        
        NSMutableArray *outarray = [NSMutableArray new];
        NSMutableArray *inarray = [NSMutableArray new];
        [outarray addObject:data2];
        [inarray addObject:data];
        
        NSString *content = [ItemDataHelp SceneContentWithOutputArray:outarray inputAraary:inarray type:0 name:_thismodel.scene_name sceneid:_mid];
        NSString *initcontent = _thismodel.scene_content;


        if(![[initcontent uppercaseString] isEqualToString:[content uppercaseString]]){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否保存此次修改", nil) preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self.navigationController popViewControllerAnimated:YES];


            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"保存", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self confirmAction];
            }]];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)pushSystemData:(NSString *)content{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    NSString * sceneId = [content substringWithRange:NSMakeRange(4, 2)];
    
    NSMutableArray *systemlist = [[SystemSceneDataBase sharedDataBase] selectScene];
    
    for (SystemSceneModel *s_model in systemlist) {
        
        if(s_model.answer_content.length<=38){
            if([s_model.answer_content containsString:@"0000"]){
                NSString *sid = [s_model.answer_content substringWithRange:NSMakeRange(0, 2)];
                int sids = [sid intValue];
                NSString *color = [@"F" stringByAppendingString:[NSString stringWithFormat:@"%d",sids]];
                NSString *command = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"0028",sid,@"404040404040404040404040404040240001",sceneId,color,@"80" ];
                s_model.answer_content = command;
                NSString *crc = [s_model getCRCFromContent];
                
                [[SystemSceneDataBase sharedDataBase] updateScene:s_model];
                NSString *content2 = [s_model.answer_content stringByAppendingString:crc];
                PushSystemSceneApi *api = [[PushSystemSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneContent:content2];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
                } failure:^(id data, NSError *error) {
                }];
            }
        }else{
            
            int gs584count = (int)strtoul([[s_model.answer_content substringWithRange:NSMakeRange(38, 2)] UTF8String],0,16);
            
            int number = (int)strtoul([[s_model.answer_content substringWithRange:NSMakeRange(40, 2)] UTF8String],0,16);
            
            NSString *sub = [s_model.answer_content substringWithRange:NSMakeRange(42+gs584count*14, 2*number)];
            
            if(![sub containsString:sceneId]){
                int bty = (int)strtoul([[s_model.answer_content substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16);
                int numbernew = number + 1;
                NSString *cnmber = [BatterHelp gethexBybinary:numbernew];
                int length = (int)cnmber.length ;
                for (int i = length; i<2; i++) {
                    cnmber = [@"0" stringByAppendingString:cnmber];
                }
                s_model.answer_content = [s_model.answer_content stringByReplacingCharactersInRange:NSMakeRange(40, 2) withString:cnmber];
                
                
                NSString *btynew = [BatterHelp gethexBybinary:bty+1];
                int length2 = (int)btynew.length ;
                for (int i = length2; i<4; i++) {
                    btynew = [@"0" stringByAppendingString:btynew];
                }
                s_model.answer_content = [s_model.answer_content stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:btynew];
                
                NSMutableString *tempContent = [[NSMutableString alloc] initWithString:s_model.answer_content];
                
                [tempContent insertString:sceneId atIndex:(gs584count*14+42+number*2)];
                s_model.answer_content = tempContent;
                
                
                NSString *crc = [s_model getCRCFromContent];
                
                [[SystemSceneDataBase sharedDataBase] updateScene:s_model];
                NSString *content2 = [s_model.answer_content stringByAppendingString:crc];
                PushSystemSceneApi *api = [[PushSystemSceneApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey SceneContent:content2];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
                } failure:^(id data, NSError *error) {
                }];
        }

        }
        

    }
}

@end
