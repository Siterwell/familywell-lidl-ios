//
//  RegistCell.m
//  sHome
//
//  Created by shaop on 2016/12/25.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "RegistCell.h"

@implementation RegistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)hidenAction:(id)sender {
    UIButton *btn = sender;
    _titleTextField.secureTextEntry = !_titleTextField.secureTextEntry;
    if (_titleTextField.isSecureTextEntry) {
        [btn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateNormal];
    }
}

@end
