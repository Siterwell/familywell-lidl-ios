//
//  SceneListCell.m
//  sHome
//
//  Created by shaop on 2017/2/6.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SceneListCell.h"

@implementation SceneListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _clickButton.layer.cornerRadius = 14.0f;
    [_clickButton setTitle:NSLocalizedString(@"点击", nil) forState:UIControlStateNormal];
    [self titleLabel2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(TXScrollLabelView *)titleLabel2{
    if(_titleLabel2 == nil){
        _titleLabel2 = [TXScrollLabelView scrollWithTitle:@"" type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
        /** Step4: 布局(Required) */
        _titleLabel2.frame = CGRectMake(30, 7, 300, 30);
        
        
        
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
