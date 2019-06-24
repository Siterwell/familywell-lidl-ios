//
//  TempViewCell.m
//  familywell
//
//  Created by TracyHenry on 2018/9/10.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "TempViewCell.h"

@interface TempViewCell()

@property (nonatomic,strong) NSMutableDictionary *teams;
@property (nonatomic,strong) NSArray *areas;
@property (nonatomic,copy) NSString *selectedAreas;

@end

@implementation TempViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initdata];
        [self initview];
    }
    return self;
}

-(void)initdata{
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
}

-(void)initview{
    _pickview = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _pickview.delegate = self;
    _pickview.dataSource = self;
    [self.contentView addSubview:_pickview];
    [_pickview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.equalTo(240);
        make.height.equalTo(160);
    }];
}

#pragma -mark delegate
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    
    return 4;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0){
      return  _areas.count;
    }else if(component == 2){
        return [[_teams objectForKey:_selectedAreas] count];
    }else{
      return 1;
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _selectedAreas = [_areas objectAtIndex:row];
        [pickerView reloadComponent:2];
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if(component == 1){
        return 5;
    }else if(component == 3){
        return 30;
    }
    return 80;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        return [_areas objectAtIndex:row];
    }else if(component == 1){
        return @".";
    }else if(component == 3){
        return @"℃";
    }else{
        return [[_teams objectForKey:_selectedAreas] objectAtIndex:row];
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
