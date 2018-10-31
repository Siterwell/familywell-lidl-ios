//
//  AddSystemScenCell.h
//  sHome
//
//  Created by shaop on 2017/2/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXScrollLabelView.h"

@interface AddSystemScenCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) TXScrollLabelView *titleLabel2;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;

@end
