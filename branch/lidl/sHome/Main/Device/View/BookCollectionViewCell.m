//
//  BookCollectionViewCell.m
//  ShelfCollectionView
//
//  Created by king.wu on 8/12/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import "BookCollectionViewCell.h"

@interface BookCollectionViewCell ()



@end

@implementation BookCollectionViewCell


+ (instancetype)loadFromNib{

    return [[[NSBundle mainBundle]loadNibNamed:@"BookCollectionViewCell" owner:nil options:nil]objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initCellWithItemData:(ItemData *)itemData{
    self.numberIndexLabel.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
    self.numberIndexLabel.numberOfLines = 0;//表示label可以多行显示
    if([itemData.customTitle isEqualToString:@""]){
          self.numberIndexLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(itemData.title, nil) ,itemData.devID];
    }else{
        self.numberIndexLabel.text = itemData.customTitle;
    }
    self.mainImageView.image = [UIImage imageNamed:itemData.image];
    self.numberIndexLabel.textColor = RGB(255, 255, 255);
}

- (void)prepareForReuse{
    [self.numberIndexLabel setText:@""];
}

@end
