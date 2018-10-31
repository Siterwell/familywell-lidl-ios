//
//  SelectDayCell.m
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SelectDayCell.h"

@interface SelectDayCell ()


@end

@implementation SelectDayCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_mondayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_mondayBtn setTag:0];
    [_mondayBtn addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tuesdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_tuesdayBtn addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_tuesdayBtn setTag:1];
    
    [_wednesdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_wednesdayBtn addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_wednesdayBtn setTag:2];
    
    [_thursdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_thursdayBtn addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_thursdayBtn setTag:3];
    
    [_fridayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_fridayBtn addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_fridayBtn setTag:4];
    
    [_saturdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_saturdayBtn addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_saturdayBtn setTag:5];
    
    [_sundayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_sundayBtn addTarget:self action:@selector(selectBtn1:) forControlEvents:UIControlEventTouchUpInside];
    [_sundayBtn setTag:6];

}

- (void)setWeek:(NSString *)week{
    
    for (int i = 1; i < [week length]; i++) {
        
        NSString *indexValue = [week  substringWithRange:NSMakeRange([week length] - i - 1, 1)];
        
        switch (i) {
                
            case 1:
                if ([indexValue intValue] == 1){
                    _mondayBtn.selected = YES;
                }else{
                    _mondayBtn.selected = NO;
                }
                break;
            case 2:
                if ([indexValue intValue] == 1){
                    _tuesdayBtn.selected = YES;
                }else{
                    _tuesdayBtn.selected = NO;
                }
                break;
            case 3:
                if ([indexValue intValue] == 1){
                    _wednesdayBtn.selected = YES;
                }else{
                    _wednesdayBtn.selected = NO;
                }
                break;
            case 4:
                if ([indexValue intValue] == 1){
                    _thursdayBtn.selected = YES;
                }else{
                    _thursdayBtn.selected = NO;
                }
                break;
            case 5:
                if ([indexValue intValue] == 1){
                    _fridayBtn.selected = YES;
                }else{
                    _fridayBtn.selected = NO;
                }
                break;
            case 6:
                if ([indexValue intValue] == 1){
                    _saturdayBtn.selected = YES;
                }else{
                    _saturdayBtn.selected = NO;
                }
                break;
            case 7:
                if ([indexValue intValue] == 1){
                    _sundayBtn.selected = YES;
                }else{
                    _sundayBtn.selected = NO;
                }
                break;
            default:
                break;
        }
    }
}

- (void)selectBtn1:(UIButton *)sender{
    [sender setSelected:!sender.isSelected];
    self.dayChanged();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
