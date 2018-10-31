//
//  DoubleSwitchStatusVC.m
//  sHome
//
//  Created by CY on 2018/2/9.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "DoubleSwitchStatusVC.h"
#import "BatterHelp.h"

@interface DoubleSwitchStatusVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) NSInteger channel; //0.通道1  1.通道2

@property (nonatomic) UIPickerView *picker;

@end

@implementation DoubleSwitchStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(239, 239, 239);
    [self setupDoubleSwitchUI];
}

- (void)setupDoubleSwitchUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveDoubleSwitchConfig)];
    
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
    
    if (!_selectCode) {
        self.channel = 0;
        [picker1 selectRow:0 inComponent:0 animated:NO];
        [picker1 selectRow:1 inComponent:1 animated:NO];
    } else {
        if ([_selectCode isEqualToString:@"01010000"]) { //1开
            self.channel = 0;
            [picker1 selectRow:0 inComponent:0 animated:NO];
            [picker1 selectRow:0 inComponent:1 animated:NO];
        } else if ([_selectCode isEqualToString:@"01000000"]) { //1关
            self.channel = 0;
            [picker1 selectRow:0 inComponent:0 animated:NO];
            [picker1 selectRow:1 inComponent:1 animated:NO];
        } else if ([_selectCode isEqualToString:@"0100FF00"]) { //1切换
            self.channel = 0;
            [picker1 selectRow:0 inComponent:0 animated:NO];
            [picker1 selectRow:2 inComponent:1 animated:NO];
        } else if ([_selectCode isEqualToString:@"02010000"]) { //2开
            self.channel = 1;
            [picker1 selectRow:1 inComponent:0 animated:NO];
            [picker1 selectRow:0 inComponent:1 animated:NO];
        } else if ([_selectCode isEqualToString:@"02000000"]) { //2关
            self.channel = 1;
            [picker1 selectRow:1 inComponent:0 animated:NO];
            [picker1 selectRow:1 inComponent:1 animated:NO];
        } else if ([_selectCode isEqualToString:@"0200FF00"]) { //2切换
            self.channel = 1;
            [picker1 selectRow:1 inComponent:0 animated:NO];
            [picker1 selectRow:2 inComponent:1 animated:NO];
        }
    }
    
    self.picker = picker1;
}

- (void)saveDoubleSwitchConfig {
    NSInteger idx = [self.picker selectedRowInComponent:1];
    NSString *action = nil;
    if (self.channel == 0) {  ///通道1
        if (idx == 0) {   //开
            action = @"01010000";
        } else if (idx == 1) {  //关
            action = @"01000000";
        } else if (idx == 2) {  //切换
            action = @"0100FF00";
        }
    }
    else if (self.channel == 1) {   ///通道2
        if (idx == 0) {   //开
            action = @"02010000";
        } else if (idx == 1) {  //关
            action = @"02000000";
        } else if (idx == 2) {  //切换
            action = @"0200FF00";
        }
    }
    [self.delegate sendNext:action];
}

#pragma mark - Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 2;
    } else {
        return 3;
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
        return @[NSLocalizedString(@"通道1", nil), NSLocalizedString(@"通道2", nil)][row];
    } else {
        return @[NSLocalizedString(@"开", nil), NSLocalizedString(@"关", nil), NSLocalizedString(@"切换", nil)][row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (self.channel == 0 && row == 1) {
            self.channel = 1;
        } else if (self.channel == 1 && row == 0) {
            self.channel = 0;
        }
    }
}

@end
