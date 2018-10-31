//
//  HumitureStatusVC.m
//  sHome
//
//  Created by CY on 2018/2/3.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "HumitureStatusVC.h"
#import "BatterHelp.h"

@interface HumitureStatusVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSMutableArray *tempArray;
@property (nonatomic) NSMutableArray *humArray;
@property (nonatomic) NSInteger tempOrHum; //0.temp  1.hum
@property (nonatomic) NSInteger smallerOrBigger;
@property (nonatomic) UIPickerView *picker;

@end

@implementation HumitureStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = RGB(239, 239, 239);
    
    [self setUpHumitureUI];
}

- (NSMutableArray *)tempArray {
    if (!_tempArray) {
        _tempArray = [[NSMutableArray alloc] init];
        for (int i = -40; i < 91; i++) {
            [_tempArray addObject:@(i)];
        }
    }
    return _tempArray;
}

- (NSMutableArray *)humArray {
    if (!_humArray) {
        _humArray = [[NSMutableArray alloc] init];
        for (int i = 1; i < 101; i++) {
            [_humArray addObject:@(i)];
        }
    }
    return _humArray;
}

- (void)setUpHumitureUI {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil)  style:UIBarButtonItemStylePlain target:self action:@selector(saveHumitureConfig)];
    
    UIPickerView *picker1 = [[UIPickerView alloc] init];
    picker1.backgroundColor = [UIColor whiteColor];
    picker1.dataSource = self;
    picker1.delegate = self;
    [self.view addSubview:picker1];
    [picker1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(64+20);
        make.left.right.equalTo(0);
        make.height.equalTo(44*3);
    }];
    if (!self.selectCode) {
        self.tempOrHum = 0;
        self.smallerOrBigger = 0;
        [picker1 selectRow:0 inComponent:0 animated:NO];
        [picker1 selectRow:0 inComponent:1 animated:NO];
        [picker1 selectRow:self.tempArray.count * 50 inComponent:2 animated:NO];
    } else {
        NSLog(@"@@@@@@@%@", self.selectCode);
        if ([self.selectCode containsString:@"7F00FF"]) {   /// 温度 <
            self.tempOrHum = 0;
            self.smallerOrBigger = 0;
            [picker1 selectRow:0 inComponent:0 animated:NO];
            [picker1 selectRow:0 inComponent:1 animated:NO];
            NSString *temp = [self.selectCode substringWithRange:NSMakeRange(0, 2)];
            int tem = [[BatterHelp numberHexString:temp] intValue];
            if (tem >= 216) {
                tem = tem - 256;
            }
            [picker1 selectRow:(tem+40)+50*self.tempArray.count inComponent:2 animated:NO];
        }
        else if ([self.selectCode containsString:@"D8"] && [self.selectCode containsString:@"00FF"]) {  /// 温度 >
            self.tempOrHum = 0;
            self.smallerOrBigger = 1;
            [picker1 selectRow:0 inComponent:0 animated:NO];
            [picker1 selectRow:1 inComponent:1 animated:NO];
            NSString *temp = [self.selectCode substringWithRange:NSMakeRange(2, 2)];
            int tem = [[BatterHelp numberHexString:temp] intValue];
            if (tem >= 216) {
                tem = tem - 256;
            }
            [picker1 selectRow:(tem+40)+50*self.tempArray.count inComponent:2 animated:NO];
        }
        else if ([self.selectCode containsString:@"D87F"] && [self.selectCode containsString:@"FF"]) {  /// 湿度 <
            self.tempOrHum = 1;
            self.smallerOrBigger = 0;
            [picker1 selectRow:1 inComponent:0 animated:NO];
            [picker1 selectRow:0 inComponent:1 animated:NO];
            NSString *humi = [self.selectCode substringWithRange:NSMakeRange(4, 2)];
            humi = [NSString stringWithFormat:@"%ld", strtoul([humi UTF8String], 0, 16)];
            int hum = [humi intValue];
            [picker1 selectRow:(hum-1)+50*self.humArray.count inComponent:2 animated:NO];
        }
        else if ([self.selectCode containsString:@"D87F00"]) {  /// 湿度 >
            self.tempOrHum = 1;
            self.smallerOrBigger = 1;
            [picker1 selectRow:1 inComponent:0 animated:NO];
            [picker1 selectRow:1 inComponent:1 animated:NO];
            NSString *humi = [self.selectCode substringWithRange:NSMakeRange(6, 2)];
            int hum = [[BatterHelp numberHexString:humi] intValue];
            [picker1 selectRow:(hum-1)+50*self.humArray.count inComponent:2 animated:NO];
        }
    }
    
    self.picker = picker1;

}

- (void)saveHumitureConfig {
    NSInteger idx = [self.picker selectedRowInComponent:2];
    NSLog(@"idx = %ld", (long)idx);
    NSString *action = nil;
    if (self.tempOrHum == 0) {  /// 温度
        NSString *temp = [self.tempArray[idx % self.tempArray.count] stringValue];
        if (self.smallerOrBigger == 0) {    /// <
            if (temp.longLongValue < 0) { /// <0
                action = [NSString stringWithFormat:@"%@7F00FF", [BatterHelp gethexBybinary:(256+temp.longLongValue)]];
            } else {    /// >=0
                NSString *t = [BatterHelp gethexBybinary:[temp longLongValue]];
                action = [NSString stringWithFormat:@"%@7F00FF", t.length < 2 ? [@"0" stringByAppendingString:t] : t];
            }
        }
        else if (self.smallerOrBigger == 1) {   /// > D8%@00FF
            if (temp < 0) {    /// < 0
                action = [NSString stringWithFormat:@"D8%@00FF", [BatterHelp gethexBybinary:(256+temp.longLongValue)]];
            } else {    /// > 0
                action = [NSString stringWithFormat:@"D8%@00FF", [BatterHelp gethexBybinary:[temp longLongValue]]];
            }
        }
    }
    else if (self.tempOrHum == 1) { /// 湿度
        NSString *hum = [self.humArray[idx % self.humArray.count] stringValue];
        if (self.smallerOrBigger == 0) {    /// <
            action = [NSString stringWithFormat:@"D87F%@FF", [BatterHelp gethexBybinary:[hum longLongValue]]];
        }
        else if (self.smallerOrBigger == 1) {   /// >
            action = [NSString stringWithFormat:@"D87F00%@", [BatterHelp gethexBybinary:[hum longLongValue]]];
        }
    }
    if (self.delegate) {
        [self.delegate sendNext:action];
    }
}

#pragma mark - Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0 || component == 1) {
        return 2;
    } else {
        if (self.tempOrHum == 0) {
            return self.tempArray.count * 100;
        } else if (self.tempOrHum == 1) {
            return self.humArray.count * 100;
        }
    }
    return 0;
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
    NSString *title = nil;
    switch (component) {
        case 0:
            title = @[NSLocalizedString(@"温度", nil),NSLocalizedString(@"湿度", nil) ][row];
            break;
        case 1:
            title = @[@"<=", @">="][row];
            break;
        case 2: {
            NSString *titleStr = nil;
            if (self.tempOrHum == 0) {
                NSMutableString *str = [[NSMutableString alloc] initWithString:[self.tempArray[row%self.tempArray.count] stringValue]];
                if ([str intValue] < 0) {
                    if (str.length >= 3) {
                        titleStr = [NSString stringWithFormat:@"%@℃", str];
                    } else {
                        [str insertString:@"0" atIndex:1];
                        titleStr = [NSString stringWithFormat:@"%@℃", str];
                    }
                } else {
                    titleStr = [NSString stringWithFormat:@"%@℃", str.length >= 2 ? str : [@"0" stringByAppendingString:str]];
                }
            }
            else if (self.tempOrHum == 1) {
                NSString *str = [self.humArray[row%self.humArray.count] stringValue];
                titleStr = [NSString stringWithFormat:@"%@%%", str.length >= 2 ? str : [@"0" stringByAppendingString:str]];
            }
            
            title = titleStr;
            break;
        }
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (self.tempOrHum == 0 && row == 1) {
            self.tempOrHum = 1;
            [self.picker reloadComponent:2];
        } else if (self.tempOrHum == 1 && row == 0) {
            self.tempOrHum = 0;
            [self.picker reloadComponent:2];
        }
    }
    else if (component == 1) {
        if (self.smallerOrBigger == 0 && row == 1) {
            self.smallerOrBigger = 1;
        } else if (self.smallerOrBigger == 1 && row == 0) {
            self.smallerOrBigger = 0;
        }
    }
}

@end
