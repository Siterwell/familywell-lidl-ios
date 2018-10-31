//
//  addSceneListItemCell.m
//  sHome
//
//  Created by shaop on 2017/1/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "addSceneListItemCell.h"

@implementation addSceneListItemCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initview];
}

-(void)initview{
    
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
    _titleLabel.numberOfLines = 0;//表示label可以多行显示
}
@end
