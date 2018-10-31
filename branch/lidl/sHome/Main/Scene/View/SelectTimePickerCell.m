//
//  SelectTimePickerCell.m
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SelectTimePickerCell.h"

@implementation SelectTimePickerCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timePicker.dataSource = self;
    self.timePicker.delegate = self;
    
    _hourArray = [[NSMutableArray alloc] init];
    _secondArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<24; i++) {
        [_hourArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    for (int i = 0; i<60; i++) {
        [_secondArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
//        return _hourArray[row];
    }else if (component == 1){
        return @":";
    }else{
        return [_secondArray objectAtIndex:row%60];
//        return _secondArray[row];
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

- (void)setH:(NSString *)H{
    for (int i = 0; i< [_hourArray count]; i++) {
        if ([[_hourArray objectAtIndex:i] isEqualToString:H]) {
            
            [self.timePicker selectRow:i + 10 * 24 inComponent:0 animated:NO];
            return;
        }
    }
}

- (void)setM:(NSString *)M{
    for (int i = 0; i< [_secondArray count]; i++) {
        if ([[_secondArray objectAtIndex:i] isEqualToString:M]) {
            
            [self.timePicker selectRow:i + 50 * 60 inComponent:2 animated:NO];
            return;
        }
    }
}

@end
