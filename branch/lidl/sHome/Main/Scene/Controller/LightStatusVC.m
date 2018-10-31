//
//  LightStatusVC.m
//  sHome
//
//  Created by CY on 2018/4/4.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "LightStatusVC.h"
#import "BatterHelp.h"

@interface LightStatusVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) UIPickerView *picker;

@property (nonatomic) NSMutableArray *lightArray;

@end

@implementation LightStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(239, 239, 239);
    [self setupLightUI];
}

- (void)setupLightUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveLightConfig)];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, Main_Screen_Width, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *lb1 = [[UILabel alloc] init];
    lb1.text = @"打开/关闭";
    lb1.textColor = [UIColor grayColor];
    lb1.font = [UIFont systemFontOfSize:14.5];
    [topView addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.centerY.equalTo(0);
    }];
    
    UILabel *lb2 = [[UILabel alloc] init];
    lb2.textColor = [UIColor grayColor];
    lb2.text = @"亮度";
    lb2.font = [UIFont systemFontOfSize:14.5];
    [topView addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-50);
        make.centerY.equalTo(0);
    }];
    
    UIPickerView *picker1 = [[UIPickerView alloc] init];
    picker1.backgroundColor = [UIColor whiteColor];
    picker1.dataSource = self;
    picker1.delegate = self;
    [self.view addSubview:picker1];
    [picker1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(15);
        make.left.right.equalTo(0);
        make.height.equalTo(44*3);
    }];
    self.picker = picker1;
    
    if (self.selectCode) {
        if ([[self.selectCode substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]) {
            [self.picker selectRow:0 inComponent:0 animated:NO];
        } else {
            [self.picker selectRow:1 inComponent:0 animated:NO];
        }
        NSString *light = [self.selectCode substringWithRange:NSMakeRange(2, 2)];
        NSInteger lightIndex = [[BatterHelp numberHexString:light] integerValue];
        [self.picker selectRow:lightIndex inComponent:1 animated:NO];
    }
    
}

- (NSMutableArray *)lightArray {
    if (!_lightArray) {
        _lightArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 101; i++) {
            [_lightArray addObject:@(i)];
        }
    }
    return _lightArray;
}

#pragma mark - Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 2;
    } else {
        return 101;
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
        return @[NSLocalizedString(@"打开", nil), NSLocalizedString(@"关闭", nil)][row];
    } else {
        return [[self.lightArray[row] stringValue] stringByAppendingString:@"%"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        
    }
}


- (void)saveLightConfig {
    NSInteger onOffIdx = [self.picker selectedRowInComponent:0];
    NSInteger lightIdx = [self.picker selectedRowInComponent:1];
    NSString *action = nil;
    if (onOffIdx == 0) {
        action = @"01";
    } else {
        action = @"00";
    }
    NSString *lighting = [BatterHelp gethexBybinary: (long)lightIdx];
    lighting = lighting.length == 2 ? lighting : [@"0" stringByAppendingString:lighting];
    action = [action stringByAppendingString:lighting];
    [self.delegate sendNext:[action stringByAppendingString:@"0000"]];
}



@end
