//
//  RecordConfigThrCell.h
//  sHome
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWSwitch.h"

@interface RecordConfigThrCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *recordTitle;
@property (weak, nonatomic) IBOutlet UILabel *recordDes;
@property (weak, nonatomic) IBOutlet UIView *recordSwitch;

@property (nonatomic) HWSwitch *ypHWswitch;

- (void)setHWSwithcTag:(NSInteger)tag;



@end
