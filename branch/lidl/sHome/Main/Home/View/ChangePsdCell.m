//
//  ChangePsdCell.m
//  sHome
//
//  Created by shaop on 2016/12/27.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "ChangePsdCell.h"

@implementation ChangePsdCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _textFile.secureTextEntry = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ActionHiden:(id)sender {
    UIButton *btn = sender;
    _textFile.secureTextEntry = !_textFile.secureTextEntry;
    if (_textFile.isSecureTextEntry) {
        [btn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateNormal];
    }
}

@end
