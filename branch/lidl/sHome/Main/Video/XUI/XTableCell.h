//
//  XTableCell.h
//  XControl
//
//  Created by liuguifang on 5/5/16.
//  Copyright (c) 2016 liuguifang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTableCell : UITableViewCell

@property (strong,nonatomic) UILabel *titleLabel;         // 标题
@property (strong,nonatomic) UILabel *infoLabel;          // 附加信息
@property (strong,nonatomic) UIImageView *Headerphoto;    // 左侧图片
@property (strong,nonatomic) UIImageView *StateView;      // 状态图标
@property (strong,nonatomic) UIButton *btnEdit;           // 编辑按钮

@end
