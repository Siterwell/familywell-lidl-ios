//
//  SceneSwitchCell.m
//  sHome
//
//  Created by CY on 2018/1/28.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "SceneSwitchCell.h"

@implementation SceneSwitchCell 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSceneSwitchCell];
    }
    return self;
}

- (void)setupSceneSwitchCell {
    _sceneIcon = [[UIImageView alloc] init];
    [_sceneIcon setTintColor:[UIColor whiteColor]];
    [_sceneIcon setImage:[[UIImage imageNamed:@"en_index_lj_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.contentView addSubview:_sceneIcon];
    [_sceneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.top.equalTo(10);
        make.width.height.equalTo(50);
    }];
    
    _scenelB = [[UILabel alloc] init];
    _scenelB.textColor = [UIColor whiteColor];
//    _scenelB.text = NSLocalizedString(@"离线", nil);
    _scenelB.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_scenelB];
    [_scenelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sceneIcon.mas_bottom).offset(10);
        make.bottom.equalTo(-10);
        make.centerX.equalTo(_sceneIcon);
    }];
    
    _selectIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectIcon setTintColor:[UIColor whiteColor]];
    [_selectIcon setBackgroundImage:[[UIImage imageNamed:@"blue_btn_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.contentView addSubview:_selectIcon];
    [_selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-50);
        make.top.width.height.equalTo(_sceneIcon);
    }];
    
    _selectLb = [[UILabel alloc] init];
    _selectLb.text = NSLocalizedString(@"请选择", nil);
    _selectLb.textColor = [UIColor whiteColor];
    _selectLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_selectLb];
    [_selectLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_selectIcon);
        make.centerX.equalTo(_selectIcon);
        make.top.bottom.equalTo(_scenelB);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
