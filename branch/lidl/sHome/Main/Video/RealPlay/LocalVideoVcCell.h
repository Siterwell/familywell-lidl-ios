//
//  LocalVideoVcCell.h
//  sHome
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalVideoVcCell : UITableViewCell

@property (strong ,nonatomic) UIImageView *tmpImgView;
@property (strong ,nonatomic) UIImageView *playImgView;
@property (strong ,nonatomic) UILabel *imageName;
@property (strong ,nonatomic) UILabel *udataTime;

- (void)initView;

@end
