//
//  VerifyCodeCell.m
//  sHome
//
//  Created by TracyHenry on 2018/7/16.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "VerifyCodeCell.h"

@implementation VerifyCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_hidenBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:0];
    _titleTextField.keyboardType = UIKeyboardTypeNumberPad;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)showAlertAction:(UIButton *)sender {
    if ([_clickCellDelegate respondsToSelector:@selector(clickTerm:)]) {
        sender.tag = self.tag;
        [_clickCellDelegate clickTerm:sender];
    } 
}

@end
