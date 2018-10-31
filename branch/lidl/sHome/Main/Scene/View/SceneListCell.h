//
//  SceneListCell.h
//  sHome
//
//  Created by shaop on 2017/2/6.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXScrollLabelView.h"
@interface SceneListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) TXScrollLabelView *titleLabel2;
@property (strong, nonatomic) IBOutlet UIImageView *enterRightImageView;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@end
