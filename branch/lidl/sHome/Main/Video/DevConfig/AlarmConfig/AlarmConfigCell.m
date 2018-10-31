//
//  AlarmConfigCell.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/27.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "AlarmConfigCell.h"

@implementation AlarmConfigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.alarmSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        self.alarmSwitch.center = CGPointMake(self.frame.size.width + 50, self.frame.size.height/2);
        [self addSubview: self.alarmSwitch];
        
        self.coverView = [[UIView alloc]initWithFrame:self.frame];
        self.coverView.backgroundColor = [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.5];
        self.coverView.hidden = YES;
        self.coverView.userInteractionEnabled = NO;
        [self addSubview:self.coverView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
@end
