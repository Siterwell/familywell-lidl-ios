//
//  RecordConfigThrCell.m
//  sHome
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "RecordConfigThrCell.h"

@implementation RecordConfigThrCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initHWSwitch];
}

- (void)initHWSwitch{
    
    if (_ypHWswitch == nil) {
        _ypHWswitch = [[HWSwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 24) onColor:ThemeColor onPointColor:[UIColor whiteColor] offColor:NetiveColor offPointColor:ThemeColor ballColor:[UIColor whiteColor] ballSize:15];
        [self.recordSwitch addSubview:_ypHWswitch];
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
