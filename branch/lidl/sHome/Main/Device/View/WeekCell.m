//
//  WeekCell.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/9/10.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "WeekCell.h"

@interface WeekCell()

@property(nonatomic,strong) UIButton *MondayBtn;
@property(nonatomic,strong) UIButton *TuesdayBtn;
@property(nonatomic,strong) UIButton *WeddayBtn;
@property(nonatomic,strong) UIButton *ThurthBtn;
@property(nonatomic,strong) UIButton *FriBtn;
@property(nonatomic,strong) UIButton *SatBtn;
@property(nonatomic,strong) UIButton *SunBtn;
@end

@implementation WeekCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
    
        [self initview];
    }
    return self;
}

-(void)initview{
    _MondayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_MondayBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_MondayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_MondayBtn setTitle:NSLocalizedString(@"周一", nil) forState:UIControlStateNormal];
    _MondayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_MondayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_MondayBtn setTag:0];
    [self.contentView addSubview:_MondayBtn];
    [_MondayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.width.equalTo(Main_Screen_Width/7);
        make.height.equalTo(50);
    }];
     _TuesdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [_TuesdayBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_TuesdayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_TuesdayBtn setTitle:NSLocalizedString(@"周二", nil) forState:UIControlStateNormal];
    _TuesdayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_TuesdayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_TuesdayBtn setTag:1];
    [self.contentView addSubview:_TuesdayBtn];
    [_TuesdayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_MondayBtn.mas_right);
        make.width.equalTo(Main_Screen_Width/7);
        make.height.equalTo(50);
    }];
     _WeddayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_WeddayBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_WeddayBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_WeddayBtn setTitle:NSLocalizedString(@"周三", nil) forState:UIControlStateNormal];
    _WeddayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_WeddayBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_WeddayBtn setTag:2];
    [self.contentView addSubview:_WeddayBtn];
    [_WeddayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_TuesdayBtn.mas_right);
        make.width.equalTo(Main_Screen_Width/7);
        make.height.equalTo(50);
    }];
     _ThurthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ThurthBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_ThurthBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_ThurthBtn setTitle:NSLocalizedString(@"周四", nil) forState:UIControlStateNormal];
    _ThurthBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_ThurthBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_ThurthBtn setTag:3];
    [self.contentView addSubview:_ThurthBtn];
    [_ThurthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_WeddayBtn.mas_right);
        make.width.equalTo(Main_Screen_Width/7);
        make.height.equalTo(50);
    }];
     _FriBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_FriBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_FriBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_FriBtn setTitle:NSLocalizedString(@"周五", nil) forState:UIControlStateNormal];
    _FriBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_FriBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_FriBtn setTag:4];
    [self.contentView addSubview:_FriBtn];
    [_FriBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ThurthBtn.mas_right);
        make.width.equalTo(Main_Screen_Width/7);
        make.height.equalTo(50);
    }];
    _SatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_SatBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_SatBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_SatBtn setTitle:NSLocalizedString(@"周六", nil) forState:UIControlStateNormal];
    _SatBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_SatBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_SatBtn setTag:5];
    [self.contentView addSubview:_SatBtn];
    [_SatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_FriBtn.mas_right);
        make.width.equalTo(Main_Screen_Width/7);
        make.height.equalTo(50);
    }];
    
    _SunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_SunBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_SunBtn setTitleColor:RGB(245, 103, 53) forState:UIControlStateSelected];
    [_SunBtn setTitle:NSLocalizedString(@"周日", nil) forState:UIControlStateNormal];
    _SunBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_SunBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_SunBtn setTag:6];
    [self.contentView addSubview:_SunBtn];
    [_SunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_SatBtn.mas_right);
        make.width.equalTo(Main_Screen_Width/7);
        make.height.equalTo(50);
    }];
}

- (void)setWeek:(NSString *)week{
    
    for (int i = 1; i < [week length]; i++) {
        
        NSString *indexValue = [week  substringWithRange:NSMakeRange([week length] - i - 1, 1)];
        
        switch (i) {
                
            case 1:
                if ([indexValue intValue] == 1){
                    _MondayBtn.selected = YES;
                }else{
                    _MondayBtn.selected = NO;
                }
                break;
            case 2:
                if ([indexValue intValue] == 1){
                    _TuesdayBtn.selected = YES;
                }else{
                    _TuesdayBtn.selected = NO;
                }
                break;
            case 3:
                if ([indexValue intValue] == 1){
                    _WeddayBtn.selected = YES;
                }else{
                    _WeddayBtn.selected = NO;
                }
                break;
            case 4:
                if ([indexValue intValue] == 1){
                    _ThurthBtn.selected = YES;
                }else{
                    _ThurthBtn.selected = NO;
                }
                break;
            case 5:
                if ([indexValue intValue] == 1){
                    _FriBtn.selected = YES;
                }else{
                    _FriBtn.selected = NO;
                }
                break;
            case 6:
                if ([indexValue intValue] == 1){
                    _SatBtn.selected = YES;
                }else{
                    _SatBtn.selected = NO;
                }
                break;
            case 7:
                if ([indexValue intValue] == 1){
                    _SunBtn.selected = YES;
                }else{
                    _SunBtn.selected = NO;
                }
                break;
            default:
                break;
        }
    }
}


-(void)selectBtn:(UIButton *)sender{
    [sender setSelected:!sender.isSelected];
    if(self.dayCellSelected!=nil){
            self.dayCellSelected(sender.tag);
    }
}

-(NSString *)getWeek{
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
    
    if (_WeddayBtn.isSelected) {
        we = @"1";
    }else{
        we = @"0";
    }
    
    if (_ThurthBtn.isSelected) {
        th = @"1";
    }else{
        th = @"0";
    }
    
    if (_FriBtn.isSelected) {
        fr = @"1";
    }else{
        fr = @"0";
    }
    
    if (_SatBtn.isSelected) {
        sa = @"1";
    }else{
        sa = @"0";
    }
    
    if (_SunBtn.isSelected) {
        su = @"1";
    }else{
        su = @"0";
    }
    
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@0",su,sa,fr,th,we,tu,mo];
}

@end
