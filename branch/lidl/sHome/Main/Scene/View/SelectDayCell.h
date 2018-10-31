//
//  SelectDayCell.h
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *mondayBtn;
@property (weak, nonatomic) IBOutlet UIButton *tuesdayBtn;
@property (weak, nonatomic) IBOutlet UIButton *wednesdayBtn;
@property (weak, nonatomic) IBOutlet UIButton *thursdayBtn;
@property (weak, nonatomic) IBOutlet UIButton *fridayBtn;
@property (weak, nonatomic) IBOutlet UIButton *saturdayBtn;
@property (weak, nonatomic) IBOutlet UIButton *sundayBtn;

@property (strong, nonatomic) NSString *week;
@property (strong, nonatomic) void(^dayChanged)();

@end
