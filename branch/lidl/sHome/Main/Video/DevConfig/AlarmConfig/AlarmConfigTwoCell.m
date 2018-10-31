//
//  AlarmConfigTwoCell.m
//  sHome
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AlarmConfigTwoCell.h"

@implementation AlarmConfigTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initHWSwitch];
}

- (void)initHWSwitch{
    
    if (_ypHWswitch == nil) {
        _ypHWswitch = [[HWSwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 24) onColor:RGB(40, 184, 215) onPointColor:[UIColor whiteColor] offColor:RGB(211, 211, 211) offPointColor:RGB(40, 184, 215) ballColor:[UIColor whiteColor] ballSize:15];
        [self.swtchView addSubview:_ypHWswitch];
    }
}

- (void)setHWSwithcTag:(NSInteger)tag{
    _ypHWswitch.tag = tag;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
