//
//  RecordConfigCell.h
//  sHome
//
//  Created by Apple on 2017/9/4.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordConfigCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *recordTitle;
@property (weak, nonatomic) IBOutlet UILabel *recordTime;
@property (weak, nonatomic) IBOutlet UISlider *recordSlider;
@property (weak, nonatomic) IBOutlet UILabel *recordDes;

@end
