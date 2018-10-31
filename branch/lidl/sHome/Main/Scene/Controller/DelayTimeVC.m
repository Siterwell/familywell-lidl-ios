//
//  DelayTimeVC.m
//  sHome
//
//  Created by shaop on 2017/1/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "DelayTimeVC.h"

@interface DelayTimeVC ()
@property (weak, nonatomic) IBOutlet UIPickerView *timePickerView;
@property (strong, nonatomic) TimeModel *timeModel;

@end

@implementation DelayTimeVC
{
    NSMutableArray *_hourArray;
    NSMutableArray *_secondArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"延迟", nil);

    self.timeModel = [[TimeModel alloc] init];
    _hourArray = [[NSMutableArray alloc] init];
    _secondArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<60; i++) {
        [_hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    for (int i = 0; i<60; i++) {
        [_secondArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
    
    [_timePickerView selectRow: [_minute intValue] + 60 * 50 inComponent:0 animated:NO];
    [_timePickerView selectRow: [_second intValue] + 60 * 50 inComponent:2 animated:NO];
}

- (void)clickItem{
    NSInteger hourIndex = [_timePickerView selectedRowInComponent:0];
    NSInteger secondIndex = [_timePickerView selectedRowInComponent:2];
    
    self.timeModel.Minute = [_hourArray objectAtIndex:hourIndex%60];
    self.timeModel.Seconde = [_secondArray objectAtIndex:secondIndex%60];
    
    if ([self.timeModel.Minute isEqualToString:@"00"] && [self.timeModel.Seconde isEqualToString:@"00"]) {
        UIViewController *viewCtl = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:viewCtl animated:YES];
        return;
    }
    
    if (self.delegate) {
        [self.delegate sendNext:_timeModel];
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        return [_hourArray objectAtIndex:row%60];
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
