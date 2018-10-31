//
//  TimeSwitchCell.m
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "TimeSwitchCell.h"
#import "BatterHelp.h"


@interface TimeSwitchCell()
@property (weak, nonatomic) IBOutlet UILabel *day1;
@property (weak, nonatomic) IBOutlet UILabel *day2;
@property (weak, nonatomic) IBOutlet UILabel *day3;
@property (weak, nonatomic) IBOutlet UILabel *day4;
@property (weak, nonatomic) IBOutlet UILabel *day5;
@property (weak, nonatomic) IBOutlet UILabel *day6;
@property (weak, nonatomic) IBOutlet UILabel *day7;
@property (weak, nonatomic) IBOutlet UIView *hwSwithBaseView;

@property (weak, nonatomic) IBOutlet UILabel *HM;
@property (weak, nonatomic) IBOutlet UILabel *sceneName;

@end


@implementation TimeSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _hwSwitch = [[HWSwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 24) onColor:RGB(40, 184, 215) onPointColor:[UIColor whiteColor] offColor:RGB(211, 211, 211) offPointColor:RGB(40, 184, 215) ballColor:[UIColor whiteColor] ballSize:15];
    [self.hwSwithBaseView addSubview:_hwSwitch];
}

- (void)layoutSubviews{
    
}

- (void)setTimeModel:(TimeSceneModel *)timeModel{
    
    self.day1.text = @"";
    self.day2.text = @"";
    self.day3.text = @"";
    self.day4.text = @"";
    self.day5.text = @"";
    self.day6.text = @"";
    self.day7.text = @"";
    
    self.HM.text = [NSString stringWithFormat:@"%@:%@",timeModel.timeWHMS.Hour,timeModel.timeWHMS.Minute];
    
    if ([timeModel.sence_group intValue] == 0) {
        self.sceneName.text = NSLocalizedString(@"在家", nil);
    }else if([timeModel.sence_group intValue] == 1){
        self.sceneName.text = NSLocalizedString(@"离家", nil);
    }else if([timeModel.sence_group intValue] == 2){
        self.sceneName.text = NSLocalizedString(@"睡眠", nil);
    }else{
        self.sceneName.text = timeModel.sence_name;
    }
    
    self.hwSwitch.on = [timeModel.timer_on intValue];
    
    NSInteger indexW = 0;
        
    for (int i = 1; i < [timeModel.timeWHMS.week length]; i++) {
        
        NSString *wStr = @"";
        
        NSString *indexValue = [timeModel.timeWHMS.week  substringWithRange:NSMakeRange([timeModel.timeWHMS.week length] - i - 1, 1)];
        
        switch (i) {
            case 1:
                if ([indexValue intValue] == 1) {
                    wStr = NSLocalizedString(@"周一", nil);
                    indexW +=1;
                }
                break;
            case 2:
                if ([indexValue intValue] == 1) {
                    wStr = NSLocalizedString(@"周二", nil);
                    indexW +=1;
                }
                break;
            case 3:
                if ([indexValue intValue] == 1) {
                    wStr = NSLocalizedString(@"周三", nil);
                    indexW +=1;
                }
                break;
            case 4:
                if ([indexValue intValue] == 1) {
                    wStr = NSLocalizedString(@"周四", nil);
                    indexW +=1;
                }
                break;
            case 5:
                if ([indexValue intValue] == 1) {
                    wStr = NSLocalizedString(@"周五", nil);
                    indexW +=1;
                }
                break;
            case 6:
                if ([indexValue intValue] == 1) {
                    wStr = NSLocalizedString(@"周六", nil);
                    indexW +=1;
                }
                break;
            case 7:
                if ([indexValue intValue] == 1) {
                    wStr = NSLocalizedString(@"周日", nil);
                    indexW +=1;
                }
                break;
                
            default:
                break;
        }
        
        switch (indexW) {
                
            case 1:
                if ([indexValue intValue] == 1) {
                    self.day1.text = wStr;
                }
                break;
            case 2:
                if ([indexValue intValue] == 1) {
                    self.day2.text = wStr;
                }
                break;
            case 3:
                if ([indexValue intValue] == 1) {
                    self.day3.text = wStr;
                }
                break;
            case 4:
                if ([indexValue intValue] == 1) {
                    self.day4.text = wStr;
                }
                break;
            case 5:
                if ([indexValue intValue] == 1) {
                    self.day5.text = wStr;
                }
                break;
            case 6:
                if ([indexValue intValue] == 1) {
                    self.day6.text = wStr;
                }
                break;
            case 7:
                if ([indexValue intValue] == 1) {
                    self.day7.text = wStr;
                }
                break;
            default:
                break;
        }
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
