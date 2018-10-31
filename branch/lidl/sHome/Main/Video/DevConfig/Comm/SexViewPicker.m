//
//  SexViewPicker.m
//  btc
//
//  Created by ysamg on 16/3/30.
//  Copyright © 2016年 Kingants. All rights reserved.
//

#import "SexViewPicker.h"

#define screenHeight    [UIScreen mainScreen].bounds.size.height
#define screenWidth    [UIScreen mainScreen].bounds.size.width
@implementation SexViewPicker

- (IBAction)confirm:(id)sender {
    if (self.confirmClicked) {
        self.confirmClicked(self.optType,[self.pickers objectAtIndex:self.selectedRow],self.selectedRow);
    }
    [self hiddenMyself];
}
- (IBAction)cancel:(id)sender {
    [self hiddenMyself];
}

- (void)showInView{
    [self initSelf];
    self.frame = CGRectMake(0, screenHeight, screenWidth, 210);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, screenHeight - 210, screenWidth, 210);
    }];
    
}

- (void)initSelf{
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
}

- (void)setPickers:(NSMutableArray *)pickers{
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    _pickers = pickers;
    NSLog(@"koyang===_pickers=====%@",_pickers);
    [self.sexPicker reloadComponent:0];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedRow = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(_pickers == nil){
        return 0;
    }
    return [_pickers count];
}

//- (NSInteger)pickerView:(UIPickerView *)pickerView{
//    if(_pickers == nil){
//        return 0;
//    }
//    return [_pickers count];
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSDictionary *dic = [_pickers objectAtIndex:row];
    return dic[@"ENV"];
}

- (void)hiddenMyself{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, screenHeight, screenWidth, 210);
        self.sexPicker.delegate = nil;
        self.sexPicker.dataSource = nil;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
