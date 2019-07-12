//
//  GS361TimerCell.h
//
//
//  Created by TracyHenry on 2018/9/28.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef GS361TimerCell_h
#define GS361TimerCell_h
@interface GS361TimerCell:UITableViewCell
@property (strong, nonatomic) UIButton *clickBtn;
@property (strong, nonatomic) void (^click)(int tag);
-(void)setWeek:(NSString *)week;
-(void)setTime:(NSString *)hour withMin:(NSString *)min;
-(void)setSceneGroup:(NSString *)name;
-(void)setEnable:(NSNumber *)enable;
@end

#endif /* TimerSwitchCell_h */
