//
//  TempControlSettingVC.m
//  sHome
//
//  Created by TracyHenry on 2018/9/3.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "TempControlSettingVC.h"
#import "BatterHelp.h"
#import "PostControllerApi.h"
#import "DeviceListModel.h"

@interface TempControlSettingVC()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView *pickview_temp;
@property (nonatomic,strong) UIPickerView *pickview_workmode;
@property (nonatomic,strong) UIPickerView *pickview_tongsuo;
@property (nonatomic,strong) UIPickerView *pickview_window;
@property (nonatomic,strong) UIPickerView *pickview_valve;
@property (nonatomic,strong) NSMutableDictionary *teams;
@property (nonatomic,strong) NSMutableDictionary *teams_fang;
@property (nonatomic,strong) NSArray *areas;
@property (nonatomic,strong) NSArray *areas_fang;
@property (nonatomic,copy) NSString *selectedAreas;
@property (nonatomic,strong) NSArray *workmodelist;
@property (nonatomic,strong) NSArray *tongsuolist;
@property (nonatomic,strong) NSArray *windowchecklist;
@property (nonatomic,strong) NSArray *valvechecklist;
@property (nonatomic,strong) UILabel *setting_temp;
@property (nonatomic,strong) UILabel *workmode;
@property (nonatomic,strong) UILabel *tongsuo;
@property (nonatomic,strong) UILabel *window_check;
@property (nonatomic,strong) UILabel *valve_check;
@end

@implementation TempControlSettingVC{
      BOOL _isSetting;
}

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设置", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(save) Title:NSLocalizedString(@"保存", nil) withTintColor:ThemeColor];
    [self pickview_temp];
    [self setting_temp];
    [self workmode];
    [self tongsuo];
    [self pickview_workmode];
    [self pickview_tongsuo];
    [self window_check];
    [self valve_check];
    [self pickview_window];
    [self pickview_valve];
    [self initdata];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
}


#pragma -mark lazy
-(UIPickerView *) pickview_temp{
    if(_pickview_temp==nil){
        _pickview_temp = [[UIPickerView alloc] initWithFrame:CGRectZero];
        NSArray *xiaoshu1 = [NSArray arrayWithObjects:@"0",@"5", nil];
        NSArray *xiaoshu2 = [NSArray arrayWithObjects:@"0", nil];
        _teams = [[NSMutableDictionary alloc] init];
        for(int i=5;i<31;i++){
            if(i<30){
               [_teams setObject:xiaoshu1 forKey:[NSString stringWithFormat:@"%d",i]];
            }else{
                [_teams setObject:xiaoshu2 forKey:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
        _areas = [[_teams allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                 return [[NSNumber numberWithInt: [obj1 intValue]] compare:[NSNumber numberWithInt: [obj2 intValue]]]; //升序

            
        }];
        
        _teams_fang = [[NSMutableDictionary alloc] init];
        for(int i=5;i<16;i++){
            if(i<15){
                [_teams_fang setObject:xiaoshu1 forKey:[NSString stringWithFormat:@"%d",i]];
            }else{
                [_teams_fang setObject:xiaoshu2 forKey:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
        
        _areas_fang = [[_teams_fang allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[NSNumber numberWithInt: [obj1 intValue]] compare:[NSNumber numberWithInt: [obj2 intValue]]]; //升序
            
            
        }];
        
        if(_workmode_index==0)
        _selectedAreas = [_areas_fang objectAtIndex:0];
        else
        _selectedAreas = [_areas objectAtIndex:0];
        
        _pickview_temp.delegate = self;
        _pickview_temp.dataSource = self;
        [self.view addSubview:_pickview_temp];
        [_pickview_temp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.setting_temp.mas_bottom).offset(5);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(130);
            make.height.equalTo(80);
        }];
        
        UILabel *danwei = [[UILabel alloc] init];
        danwei.text = @"℃";
        danwei.textColor = RGB(245, 103, 53);
         [self.view addSubview:danwei];
        [danwei mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_pickview_temp.mas_centerY);
            make.left.equalTo(_pickview_temp.mas_right).offset(10);
        }];
    }
    return _pickview_temp;
}

-(UIPickerView *) pickview_workmode{
    if(_pickview_workmode==nil){
        _pickview_workmode = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _workmodelist = [NSArray arrayWithObjects:NSLocalizedString(@"防冻模式", nil) ,NSLocalizedString(@"自动模式", nil),NSLocalizedString(@"手动模式", nil), nil];
        _pickview_workmode.delegate = self;
        _pickview_workmode.dataSource = self;
        [self.view addSubview:_pickview_workmode];
        [_pickview_workmode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.workmode.mas_bottom).offset(5);
            make.centerX.equalTo(self.workmode.mas_centerX);
            make.width.equalTo(Main_Screen_Width*2/5);
            make.height.equalTo(80);
        }];
    }
    return _pickview_workmode;
}

-(UIPickerView *) pickview_tongsuo{
    if(_pickview_tongsuo==nil){
        _pickview_tongsuo = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _tongsuolist = [NSArray arrayWithObjects:NSLocalizedString(@"关", nil) ,NSLocalizedString(@"开", nil), nil];
        _pickview_tongsuo.delegate = self;
        _pickview_tongsuo.dataSource = self;
        [self.view addSubview:_pickview_tongsuo];
        [_pickview_tongsuo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tongsuo.mas_bottom).offset(5);
            make.centerX.equalTo(self.tongsuo.mas_centerX);
            make.width.equalTo(Main_Screen_Width*2/5);
            make.height.equalTo(80);
        }];
        
    }
    return _pickview_tongsuo;
}

-(UIPickerView *) pickview_window{
    if(_pickview_window==nil){
        _pickview_window = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _windowchecklist = [NSArray arrayWithObjects:NSLocalizedString(@"不使能", nil) ,NSLocalizedString(@"使能", nil), nil];
        _pickview_window.delegate = self;
        _pickview_window.dataSource = self;
        [self.view addSubview:_pickview_window];
        [_pickview_window mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.window_check.mas_bottom).offset(5);
            make.centerX.equalTo(self.window_check.mas_centerX);
            make.width.equalTo(Main_Screen_Width*2/5);
            make.height.equalTo(80);
        }];
    }
    return _pickview_window;
}

-(UIPickerView *) pickview_valve{
    if(_pickview_valve==nil){
        _pickview_valve = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _valvechecklist = [NSArray arrayWithObjects:NSLocalizedString(@"不使能", nil) ,NSLocalizedString(@"使能", nil), nil];
        _pickview_valve.delegate = self;
        _pickview_valve.dataSource = self;
        [self.view addSubview:_pickview_valve];
        [_pickview_valve mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.valve_check.mas_bottom).offset(5);
            make.centerX.equalTo(self.valve_check.mas_centerX);
            make.width.equalTo(Main_Screen_Width*2/5);
            make.height.equalTo(80);
        }];
        
    }
    return _pickview_valve;
}

-(UILabel *)setting_temp{
    if(_setting_temp==nil){
        _setting_temp = [[UILabel alloc] init];
        _setting_temp.text=NSLocalizedString(@"设定温度", nil);
        _setting_temp.font = SYSTEMFONT(14);
        _setting_temp.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:_setting_temp];
        [_setting_temp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(85);
            make.width.equalTo(Main_Screen_Width/2);
            make.left.equalTo(self.view.mas_left);
        }];
    }
    return _setting_temp;
}

-(UILabel *)workmode{
    if(_workmode==nil){
        _workmode = [[UILabel alloc] init];
        _workmode.text=NSLocalizedString(@"工作模式", nil);
        _workmode.font = SYSTEMFONT(14);
        _workmode.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:_workmode];
        [_workmode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pickview_temp.bottom).offset(50);
            make.width.equalTo(Main_Screen_Width/2);
            make.left.equalTo(self.view.mas_left);
        }];
    }
    return _workmode;
}

-(UILabel *)tongsuo{
    if(_tongsuo==nil){
        _tongsuo = [[UILabel alloc] init];
        _tongsuo.text=NSLocalizedString(@"童锁", nil);
        _tongsuo.font = SYSTEMFONT(14);
        _tongsuo.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:_tongsuo];
        [_tongsuo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pickview_temp.bottom).offset(50);
            make.width.equalTo(Main_Screen_Width/2);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _tongsuo;
}

-(UILabel *)window_check{
    if(_window_check==nil){
        _window_check = [[UILabel alloc] init];
        _window_check.text=NSLocalizedString(@"开窗检测", nil);
        _window_check.font = SYSTEMFONT(14);
        _window_check.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:_window_check];
        [_window_check mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pickview_workmode.bottom).offset(50);
            make.width.equalTo(Main_Screen_Width/2);
            make.left.equalTo(self.view.mas_left);
        }];
    }
    return _window_check;
}

-(UILabel *)valve_check{
    if(_valve_check==nil){
        _valve_check = [[UILabel alloc] init];
        _valve_check.text=NSLocalizedString(@"阀门检测", nil);
        _valve_check.font = SYSTEMFONT(14);
        _valve_check.textAlignment = UITextAlignmentCenter;
        [self.view addSubview:_valve_check];
        [_valve_check mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pickview_tongsuo.bottom).offset(50);
            make.width.equalTo(Main_Screen_Width/2);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _valve_check;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    if(pickerView == _pickview_temp)
    return 3;
    else return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(pickerView == _pickview_temp){
        if(component == 0){
            if(_workmode_index==0){
                            return _areas_fang.count;
            }else{
                           return _areas.count;
            }

        }else if(component == 1){
            return 1;
        }else{
            if(_workmode_index==0){
                return [[_teams_fang objectForKey:_selectedAreas] count];
            }else{
                return  [[_teams objectForKey:_selectedAreas] count];
            }
        }

    }else if(pickerView == _pickview_workmode){
        return _workmodelist.count;
    }else if(pickerView == _pickview_tongsuo){
        return _tongsuolist.count;
    }else if(pickerView == _pickview_window){
        return _windowchecklist.count;
    }else {
        return _valvechecklist.count;
    }

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _pickview_temp){
        if(component == 0){
            if(_workmode_index==0){
                _selectedAreas = [_areas_fang objectAtIndex:row];
                [_pickview_temp reloadComponent:2];
            }else{
                _selectedAreas = [_areas objectAtIndex:row];
                [_pickview_temp reloadComponent:2];
            }

        }
    }else if(pickerView == _pickview_workmode){
        _workmode_index = row;
        if(row == 0){
            if([_selectedAreas intValue] > [[_areas_fang objectAtIndex:(_areas_fang.count-1)] intValue]){
                _selectedAreas = [_areas_fang objectAtIndex:(_areas_fang.count-1)];
            }
        }

        [_pickview_temp reloadAllComponents];
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(pickerView == _pickview_temp){
        if(component == 0){
            return 60;
        }else if(component == 1){
            return 5;
        }
        return 60;
    }else{
        return 80;
    }

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView == _pickview_temp){
        if(component == 0){
            return [_areas objectAtIndex:row];
        }else if(component == 1){
            return @".";
        }else{
            if(_workmode_index==0){
                            return [[_teams_fang objectForKey:_selectedAreas] objectAtIndex:row];
            }else{
                           return [[_teams objectForKey:_selectedAreas] objectAtIndex:row];
            }

        }
    }else if(pickerView==_pickview_workmode){
        return [_workmodelist objectAtIndex:row];
    }else if(pickerView==_pickview_tongsuo){
        return [_tongsuolist objectAtIndex:row];
    }else if(pickerView==_pickview_window){
        return [_windowchecklist objectAtIndex:row];
    }else {
        return [_valvechecklist objectAtIndex:row];
    }

    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = RGB(245, 103, 53);
        }
    }
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.textColor = RGB(245, 103, 53);
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

#pragma -mark method
-(void)save{
    NSString *command = [self getCode:(int)[[self pickview_temp] selectedRowInComponent:0] withPoint:(int)[[self pickview_temp] selectedRowInComponent:2] withmode:(int)[[self pickview_workmode] selectedRowInComponent:0] withtong:(int)[[self pickview_tongsuo] selectedRowInComponent:0] withwindow:(int)[[self pickview_window] selectedRowInComponent:0] withvalve:(int)[[self pickview_valve] selectedRowInComponent:0]];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    PostControllerApi *post = [[PostControllerApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[self.data.devID intValue] DeviceStatus:command];
    WS(ws)
    if (!_isSetting) {
        __block NSObject *obj = [[NSObject alloc] init];
        _isSetting = YES;
        [post startWithObject:obj CompletionBlockWithSuccess:^(id data, NSError *error) {
            _isSetting = NO;
            
            NSDictionary *dic = data;
            dic = [dic objectForKey:@"params"];
            dic = [dic objectForKey:@"data"];
            long isSuccess = [[dic objectForKey:@"answer_yes_or_no"] longValue];
            if (isSuccess == 2) {
                [MBProgressHUD showError:NSLocalizedString(@"设置完成",nil) ToView:GetWindow];
                [ws.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:NSLocalizedString(@"设置失败",nil) ToView:GetWindow];
            }
            obj = nil;
        } failure:^(id data, NSError *error) {
            _isSetting = NO;
            obj = nil;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_isSetting) {
                _isSetting = NO;
                [MBProgressHUD showError:NSLocalizedString(@"设置失败",nil) ToView:GetWindow];
                obj = nil;
            }
        });
        
    }

}

-(NSString *)getCode:(int)temp withPoint:(int)xiaoshu withmode:(int)modeindex withtong:(int) tongindex withwindow:(int)windowindex withvalve:(int)valveindex{
    
    int temp_total = temp+5;
    int  ds= 0x00,ds2 = 0x00;
    
    ds= ((windowindex==0?0x00:0x80)|ds);
    ds= ((valveindex==0?0x00:0x40)|ds);
    ds= ((xiaoshu==0?0x00:0x20)|ds);
    ds= ((temp_total&0x1F)|ds);
    
    ds2= ((tongindex==0?0x00:0x04)|ds2);
    ds2= ((modeindex&0x03)|ds2);
    
    NSString *str1 = [BatterHelp gethexBybinary:ds];
    NSString *str2 = [BatterHelp gethexBybinary:ds2];
    if (str1.length < 2) {
        str1 = [@"0" stringByAppendingString:str1];
    }
    if (str2.length < 2) {
        str2 = [@"0" stringByAppendingString:str2];
    }
    return [NSString stringWithFormat:@"%@%@%@",str1,str2,@"0000" ];
}

-(void)initdata{
    
    NSString *status1 = [_data.statuCode substringWithRange:NSMakeRange(4, 2)];
    NSString * status2 = [_data.statuCode substringWithRange:NSMakeRange(6, 2)];
    NSString * status3 = [_data.statuCode substringWithRange:NSMakeRange(0, 2)];
    int ds = [[BatterHelp numberHexString:status1] intValue];
    int ds2 = [[BatterHelp numberHexString:status2] intValue];
    int ds3 = [[BatterHelp numberHexString:status3] intValue];
    int status_window2 = (0x80) & ds3;
    int status_valve2 = (0x40) & ds3;
    int status_tongsuo = (0x20) & ds3;
    int mode2 = (0x03) & (ds2);
    int xiaoshu = (0x20) & ds;
    int sta =  ((0x1F) & ds);
    
    if(mode2<=2){
        _workmode_index = mode2;
        [[self pickview_workmode] selectRow:mode2 inComponent:0 animated:NO];
        if(mode2==0){
           __block NSInteger index=0;
            [_areas_fang enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([_areas_fang[idx] isEqualToString:[NSString stringWithFormat:@"%d",sta]]){
                    index = idx;
                    *stop = YES;
                }
                
            }];
            _selectedAreas = [_areas_fang objectAtIndex:index];
         
        }else{
             __block NSInteger index=0;
            [_areas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([_areas[idx] isEqualToString:[NSString stringWithFormat:@"%d",sta]]){
                     index = idx;
                    *stop = YES;
                }
            }];
           _selectedAreas = [_areas objectAtIndex:index];
        }
        [[self pickview_temp] reloadAllComponents];
        [_pickview_temp selectRow:([_selectedAreas intValue] - 5) inComponent:0 animated:NO];
        if(xiaoshu==0){
            [[self pickview_temp] selectRow:0 inComponent:2 animated:NO];
        }else{
            [[self pickview_temp] selectRow:1 inComponent:2 animated:NO];
        }
    }else{
        _workmode_index = 0;
        [[self pickview_workmode] selectRow:0 inComponent:0 animated:NO];
    }
    
    if(status_window2==0){
        [[self pickview_window] selectRow:0 inComponent:0 animated:NO];
    }else{
        [[self pickview_window] selectRow:1 inComponent:0 animated:NO];
    }
    
    if(status_valve2==0){
        [[self pickview_valve] selectRow:0 inComponent:0 animated:NO];
    }else{
        [[self pickview_valve] selectRow:1 inComponent:0 animated:NO];
    }
    
    if(status_tongsuo==0){
        [[self pickview_tongsuo] selectRow:0 inComponent:0 animated:NO];
    }else{
        [[self pickview_tongsuo] selectRow:1 inComponent:0 animated:NO];
    }
}
@end
