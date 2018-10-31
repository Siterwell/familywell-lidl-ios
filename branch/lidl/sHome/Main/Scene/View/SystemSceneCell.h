//
//  SystemSceneCell.h
//  sHome
//
//  Created by shaop on 2017/2/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemSceneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *color;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectSceneBtn;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;


@end
