//
//  TempControlSetVC.m
//  sHome
//
//  Created by TracyHenry on 2018/9/6.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "TempControlSetVC.h"
#import "BatterHelp.h"
@interface TempControlSetVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) UIPickerView *picker;

@property (nonatomic,strong) NSMutableDictionary *teams;
@property (nonatomic,strong) NSArray *areas;
@property (nonatomic,copy) NSString *selectedAreas;
@end

@implementation TempControlSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(255, 255, 255);
    [self setupLightUI];
}

- (void)setupLightUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveLightConfig)];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, Main_Screen_Width, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    
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
    _selectedAreas = [_areas objectAtIndex:0];
    
    
    UILabel *lb2 = [[UILabel alloc] init];
    lb2.textColor = [UIColor grayColor];
    lb2.text = NSLocalizedString(@"设定温度", nil);
    lb2.font = [UIFont systemFontOfSize:14.5];
    [topView addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(0);
    }];
    
    UIPickerView *picker1 = [[UIPickerView alloc] init];
    picker1.backgroundColor = [UIColor whiteColor];
    picker1.dataSource = self;
    picker1.delegate = self;
    [self.view addSubview:picker1];
    [picker1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(15);
        make.left.equalTo(120);
        make.right.equalTo(-120);
        make.height.equalTo(44*3);
    }];
    self.picker = picker1;
    
    
    UILabel *lb3 = [[UILabel alloc] init];
    lb3.textColor = [UIColor grayColor];
    lb3.text = @"℃";
    lb3.font = [UIFont systemFontOfSize:14.5];
    lb3.textColor = RGB(245, 103, 53);
    [topView addSubview:lb3];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerY.equalTo(_picker.mas_centerY);
        make.left.equalTo(_picker.mas_right).offset(10);
    }];
    
    if (self.selectCode) {
        NSString *status1 = [self.selectCode substringWithRange:NSMakeRange(0, 2)];
        int ds = [[BatterHelp numberHexString:status1] intValue];
        int xiaoshu = (0x20) & ds;
        int sta =  ((0x1F) & ds);
        if(sta >=5 && sta <=30){
            if(sta == 30){
                _selectedAreas = [_areas objectAtIndex:(_areas.count-1)];
            }else{
               _selectedAreas = [_areas objectAtIndex:(sta-5)];
            }
            [self.picker reloadAllComponents];
            [self.picker selectRow:(sta-5) inComponent:0 animated:NO];
            
            if(xiaoshu==0){
             [self.picker selectRow:0 inComponent:2 animated:NO];
            }else{
               [self.picker selectRow:1 inComponent:2 animated:NO];
            }
            
        }else{
            [self.picker selectRow:0 inComponent:0 animated:NO];
            [self.picker selectRow:0 inComponent:2 animated:NO];
        }
    }
    
}

#pragma mark - Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component==0){
        return _areas.count;
    }else if(component == 1){
        return 1;
    }else{
        return  [[_teams objectForKey:_selectedAreas] count];
    }

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = RGB(245, 103, 53);
        }
    }
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.textColor = RGB(245, 103, 53);
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_areas objectAtIndex:row];
    } else if(component == 1){
        return @".";
    } else {
        return [[_teams objectForKey:_selectedAreas] objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _selectedAreas = [_areas objectAtIndex:row];
        [_picker reloadComponent:2];
    }
}


- (void)saveLightConfig {
    int  ds= 0x00;
    ds= (([self.picker selectedRowInComponent:2]==0?0x00:0x20)|ds);
    ds= ((([self.picker selectedRowInComponent:0]+5)&0x1F)|ds);
    NSString *comd = [BatterHelp gethexBybinary: (long)ds];
    comd = (comd.length == 2 ? comd : [@"0" stringByAppendingString:comd]);
    [self.delegate sendNext:[comd stringByAppendingString:@"800000"]];
}



@end
