//
//  XTableCell.m
//  XControl
//
//  Created by liuguifang on 5/5/16.
//  Copyright (c) 2016 liuguifang. All rights reserved.
//


#import "XTableCell.h"

@implementation XTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        
        self.Headerphoto = photoImgView;
        self.Headerphoto.userInteractionEnabled = YES;
        [self.contentView addSubview:self.Headerphoto];
        
        // 状态图标
        self.StateView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 50, 30, 30)];
        self.StateView.userInteractionEnabled = YES;
        
        // 标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, SCREEN_WIDTH - 80, 20)];
        self.titleLabel.font = [UIFont fontWithName:@"Tamil Sangam MN" size:15.0];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:self.titleLabel];
        
        // 附加信息
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 18, SCREEN_WIDTH - 80, 50)];
        self.infoLabel.font = [UIFont fontWithName:@"Sinhala Sangam MN" size:12.0];
        self.infoLabel.numberOfLines = 0;
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor grayColor];
        self.infoLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:self.infoLabel];
        
        
        self.btnEdit = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, 100)];
        [self.btnEdit setBackgroundImage:[UIImage imageNamed:@"btn_delete_normal.png"] forState:UIControlStateNormal];
        [self.btnEdit setBackgroundImage:[UIImage imageNamed:@"btn_delete_highlighted.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

@end
