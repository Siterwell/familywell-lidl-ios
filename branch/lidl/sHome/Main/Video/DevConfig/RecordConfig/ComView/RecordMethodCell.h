//
//  RecordMethodCell.h
//  sHome
//
//  Created by Apple on 2017/9/4.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordMethodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rmothedTitle;
@property (weak, nonatomic) IBOutlet UILabel *rmethodDes;
@property (weak, nonatomic) IBOutlet UIView *selectBgView;
@property (weak, nonatomic) IBOutlet UILabel *selectValue;

@end
