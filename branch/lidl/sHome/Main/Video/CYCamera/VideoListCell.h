//
//  VideoListCell.h
//  sHome
//
//  Created by CY on 2018/3/28.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListCell : UICollectionViewCell

@property (nonatomic) UIImageView *cover;

@property (nonatomic) UILabel *timeLb;

@property (nonatomic, copy) NSString *timeString;

@end
