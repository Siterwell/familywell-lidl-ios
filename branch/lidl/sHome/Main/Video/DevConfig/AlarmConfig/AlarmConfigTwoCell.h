//
//  AlarmConfigTwoCell.h
//  sHome
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWSwitch.h"

@interface AlarmConfigTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *alermTitle;
@property (weak, nonatomic) IBOutlet UIView *swtchView;

@property (nonatomic) HWSwitch *ypHWswitch;

- (void)setHWSwithcTag:(NSInteger)tag;

@end
