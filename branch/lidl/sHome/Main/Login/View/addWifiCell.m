//
//  addWifiCell.m
//  sHome
//
//  Created by shaop on 2016/12/23.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "addWifiCell.h"

@implementation addWifiCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)ActionHien:(id)sender {
    UIButton *btn = sender;
    _textField.secureTextEntry = !_textField.secureTextEntry;
    if (_textField.isSecureTextEntry) {
        [btn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateNormal];
    }
}

@end
