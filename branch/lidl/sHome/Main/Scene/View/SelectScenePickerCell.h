//
//  SelectScenePickerCell.h
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectScenePickerCell : UITableViewCell<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *scenePicker;
@property (nonatomic,strong) NSArray *systemScenes;
@property (strong,nonatomic) NSString *sceneId;

@end
