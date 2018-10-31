//
//  AddSystemScenCell.m
//  sHome
//
//  Created by shaop on 2017/2/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AddSystemScenCell.h"

@implementation AddSystemScenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self titleLabel2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(TXScrollLabelView *)titleLabel2{
    if(_titleLabel2 == nil){
        _titleLabel2 = [TXScrollLabelView scrollWithTitle:@"" type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
        /** Step4: 布局(Required) */
        _titleLabel2.frame = CGRectMake(40, 7, 280, 30);
        
        
        
        //偏好(Optional), Preference,if you want.
        _titleLabel2.tx_centerY = 22;
        _titleLabel2.userInteractionEnabled = NO;
        _titleLabel2.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
        _titleLabel2.scrollSpace = 10;
        _titleLabel2.font = [UIFont systemFontOfSize:15];
        _titleLabel2.textAlignment = NSTextAlignmentLeft;
        _titleLabel2.scrollTitleColor = [UIColor blackColor];
        _titleLabel2.backgroundColor = [UIColor clearColor];
        _titleLabel2.layer.cornerRadius = 5;
        [self.contentView addSubview:_titleLabel2];
    }
    return _titleLabel2;
}

@end
