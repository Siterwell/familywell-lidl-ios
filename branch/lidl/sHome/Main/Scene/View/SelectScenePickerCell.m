//
//  SelectScenePickerCell.m
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SelectScenePickerCell.h"
#import "SystemSceneModel.h"

@implementation SelectScenePickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scenePicker.delegate = self;
    self.scenePicker.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [_systemScenes count] * 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    SystemSceneModel *smodel = [_systemScenes objectAtIndex:row%_systemScenes.count];
    if ([smodel.sence_group intValue] == 0) {
        return NSLocalizedString(@"在家", nil);
    }
    if ([smodel.sence_group intValue] == 1) {
        return NSLocalizedString(@"离家", nil);
    }
    if ([smodel.sence_group intValue] == 2) {
        return NSLocalizedString(@"睡眠", nil);
    }
    return smodel.scene_name;
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

- (void)setSystemScenes:(NSArray *)systemScenes{
    _systemScenes = systemScenes;
    [self.scenePicker reloadComponent:0];
}

- (void)setSceneId:(NSString *)sceneId{
    for (int i = 0; i< [_systemScenes count]; i++) {
        if ([((SystemSceneModel*)([_systemScenes objectAtIndex:i])).sence_group intValue] == [sceneId intValue]) {
            [self.scenePicker selectRow:i + 50 * _systemScenes.count inComponent:0 animated:NO];
            return;
        }
    }
}

@end
