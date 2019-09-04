//
//  LocalVideoVcCell.m
//  sHome
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "LocalVideoVcCell.h"

@implementation LocalVideoVcCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initView{
    // Initialization code
    if (_tmpImgView == nil) {
        _tmpImgView = [[UIImageView alloc] init];
        _tmpImgView.frame = CGRectMake(15, 10, 80, 60);
        [self.contentView addSubview:_tmpImgView];
    }
    
    if (_playImgView == nil) {
        _playImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_playImgView];
    }
    
    if (_imageName == nil) {
        _imageName = [[UILabel alloc] init];
        _imageName.frame = CGRectMake(15 + 80 + 10, 10, 200, 30);
        _imageName.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_imageName];
    }
    
    if (_udataTime == nil) {
        _udataTime = [[UILabel alloc] init];
        _udataTime.frame = CGRectMake(15 + 80 + 10, 40, 200, 30);
        _udataTime.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_udataTime];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
