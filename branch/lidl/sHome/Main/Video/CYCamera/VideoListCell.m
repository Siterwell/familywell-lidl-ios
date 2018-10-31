//
//  VideoListCell.m
//  sHome
//
//  Created by CY on 2018/3/28.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "VideoListCell.h"

@implementation VideoListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCell];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    _cover = [[UIImageView alloc] initWithFrame:self.bounds];
    [_cover setImage:[UIImage imageNamed:@"lbt_02"]];
    [self.contentView addSubview:_cover];
    
    _timeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-25, self.bounds.size.width, 25)];
    _timeLb.textAlignment = NSTextAlignmentCenter;
    _timeLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_timeLb];
}

- (void)setTimeString:(NSString *)timeString {
    [_timeLb setText:timeString];
}

@end
