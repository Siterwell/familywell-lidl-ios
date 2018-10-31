//
//  SetTimeVC.m
//  sHome
//
//  Created by shaop on 2017/1/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SetTimeVC.h"
#import "BatterHelp.h"

@interface SetTimeVC ()<UIPickerViewDelegate , UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIPickerView *timePickerView;
@property (strong, nonatomic) IBOutlet UIButton *MondayBtn;
@property (strong, nonatomic) IBOutlet UIButton *TuesdayBtn;
@property (strong, nonatomic) IBOutlet UIButton *WednesdayBtn;
@property (strong, nonatomic) IBOutlet UIButton *ThursdayBtn;
@property (strong, nonatomic) IBOutlet UIButton *FridayBtn;
@property (strong, nonatomic) IBOutlet UIButton *SaturdayBtn;
@property (strong, nonatomic) IBOutlet UIButton *SundayBtn;
@property (strong, nonatomic) TimeModel *timeModel;
@end

@implementation SetTimeVC
{
    NSMutableArray *_hourArray;
    NSMutableArray *_secondArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定时", nil);
    self.timeModel = [[TimeModel alloc] init];
    
    _hourArray = [[NSMutableArray alloc] init];
    _secondArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<24; i++) {
        [_hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    for (int i = 0; i<60; i++) {
        [_secondArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    [_MondayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_MondayBtn setTag:0];
    [_MondayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_TuesdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_TuesdayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_TuesdayBtn setTag:1];
    
    [_WednesdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_WednesdayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_WednesdayBtn setTag:2];
    
    [_ThursdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_ThursdayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_ThursdayBtn setTag:3];
    
    [_FridayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_FridayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_FridayBtn setTag:4];
    
    [_SaturdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_SaturdayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_SaturdayBtn setTag:5];
    
    [_SundayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_SundayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_SundayBtn setTag:6];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
    
    if (self.week) {
        self.week = [BatterHelp getBinaryByhex:self.week];

        int length = 8 - (int)self.week.length;
        for (int i = 0 ; i < length; i++) {
            self.week = [@"0" stringByAppendingString:self.week];
        }
        
        NSString *code = @"";
        for (int i = 0; i <= 7; i++) {
            code = [self.week substringWithRange:NSMakeRange(i, 1)];
            if ([code isEqualToString:@"1"]) {
                switch (i) {
                    case 0:
                        _SundayBtn.selected = YES;
                        break;
                    case 1:
                        _SaturdayBtn.selected = YES;
                        break;
                    case 2:
                        _FridayBtn.selected = YES;
                        break;
                    case 3:
                        _ThursdayBtn.selected = YES;
                        break;
                    case 4:
                        _WednesdayBtn.selected = YES;
                        break;
                    case 5:
                        _TuesdayBtn.selected = YES;
                        break;
                    case 6:
                        _MondayBtn.selected = YES;
                        break;
                    default:
                        break;
                }
            }
        }
        
    }
    
    
    [_timePickerView selectRow: [_hour intValue] + 24 * 50 inComponent:0 animated:NO];
    [_timePickerView selectRow: [_minute intValue] + 60 * 50 inComponent:2 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)selectBtn:(UIButton *)sender{
    [sender setSelected:!sender.isSelected];
}

- (void)clickItem{
    if (self.delegate) {
        

        NSString *mo = @"0";
        NSString *tu = @"0";
        NSString *we = @"0";
        NSString *th = @"0";
        NSString *fr = @"0";
        NSString *sa = @"0";
        NSString *su = @"0";

        if (_MondayBtn.isSelected) {
            mo = @"1";
        }else{
            mo = @"0";
        }
        
        if (_TuesdayBtn.isSelected) {
            tu = @"1";
        }else{
            tu = @"0";
        }
        
        if (_WednesdayBtn.isSelected) {
            we = @"1";
        }else{
            we = @"0";
        }
        
        if (_ThursdayBtn.isSelected) {
            th = @"1";
        }else{
            th = @"0";
        }
        
        if (_FridayBtn.isSelected) {
            fr = @"1";
        }else{
            fr = @"0";
        }
        
        if (_SaturdayBtn.isSelected) {
            sa = @"1";
        }else{
            sa = @"0";
        }
        
        if (_SundayBtn.isSelected) {
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
        NSLog(@"%@",week);
        
        NSInteger hourIndex = [_timePickerView selectedRowInComponent:0];
        NSInteger secondIndex = [_timePickerView selectedRowInComponent:2];

        self.timeModel.week = week;
        self.timeModel.Hour = [_hourArray objectAtIndex:hourIndex%24];
        self.timeModel.Minute = [_secondArray objectAtIndex:secondIndex%60];
        
        [self.delegate sendNext:_timeModel];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [_hourArray count] * 100;
    }else if (component == 1){
        return 1;
    }else{
        return [_secondArray count] * 100;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [_hourArray objectAtIndex:row%24];
    }else if (component == 1){
        return @":";
    }else{
        return [_secondArray objectAtIndex:row%60];
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


@end
