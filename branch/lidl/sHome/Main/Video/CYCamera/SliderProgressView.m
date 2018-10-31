//
//  SliderProgressView.m
//  sHome
//
//  Created by CY on 2018/3/28.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "SliderProgressView.h"

@implementation SliderProgressView {
    CGFloat _kScrollWidth;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        _kScrollWidth = Main_Screen_Width;
        self.bounces = NO;
//        self.showsHorizontalScrollIndicator = NO;
        [self setupScrollView];
    }
    return self;
}

- (void)setupScrollView {
    
    for (int i = 0; i < 24*3; i++) {
        _kScrollWidth += 20;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2 + i*20, 20, 1, 20)];
        line.backgroundColor = [UIColor blackColor];
        [self addSubview:line];
        if (i % 3 == 0) {
            [line setFrame:CGRectMake(Main_Screen_Width/2 + i*20, 10, 1, 40)];
            
            UILabel * numberLable = [[UILabel alloc] initWithFrame:CGRectMake(line.frame.origin.x - 20, CGRectGetMaxY(line.frame), 50, 20)];
            numberLable.font = [UIFont systemFontOfSize:12];
            numberLable.textAlignment = NSTextAlignmentCenter;
            NSString *hour = [NSString stringWithFormat:@"%d",i/3];
            numberLable.text = hour.length == 2 ? [hour stringByAppendingString:@":00"] : [NSString stringWithFormat:@"0%@:00",hour];
            [self addSubview:numberLable];

        }
    }

    // 刻度尺底部线条
    UILabel *lineBottom = [[UILabel alloc] initWithFrame:CGRectMake(Main_Screen_Width/2, 30, _kScrollWidth-Main_Screen_Width-5, 1)];
    lineBottom.backgroundColor = [UIColor blackColor];
    [self addSubview:lineBottom];
    
    self.contentSize = CGSizeMake(_kScrollWidth-5, 70);
    
}

- (void)setTypeArray:(NSMutableArray *)typeArray {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    for (int i = 0; i < typeArray.count; i++) {
        NSDictionary *dict = typeArray[i];
        NSString *type = [dict valueForKey:@"type"];
        int startHour = [[dict valueForKey:@"startHour"] intValue];
        int startMin = [[dict valueForKey:@"startMin"] intValue];
        int startSec = [[dict valueForKey:@"startSec"] intValue];
        int endHour = [[dict valueForKey:@"endHour"] intValue];
        int endMin = [[dict valueForKey:@"endMin"] intValue];
        int endSec = [[dict valueForKey:@"endSec"] intValue];
        if ([type isEqualToString:@"R"]) {
            CGRect rect = CGRectMake(startHour * 60 + startMin + startSec/1200.0 + Main_Screen_Width/2, 0, (endHour * 60  + endMin + endSec/1200.0) - (startHour * 60 + startMin +startSec/1200.0), 70);
            UIImageView *alarmLb = [[UIImageView alloc] initWithFrame:rect];
            alarmLb.backgroundColor = RGB(5, 128, 255);
            [self addSubview:alarmLb];
            [self sendSubviewToBack:alarmLb];
            
        } else if ([type isEqualToString:@"A"] || [type isEqualToString:@"M"]) {
            CGFloat w = (endHour * 60.0  + endMin + endSec/1200.0) - (startHour * 60.0 + startMin + startSec/1200.0);
            w = ((w > 0) && (w < 1)) ? 1 : w;
            CGRect rect = CGRectMake(startHour * 60 + startMin + startSec/1200.0 + Main_Screen_Width/2, 0, w, 70);
            UIImageView *alarmLb = [[UIImageView alloc] initWithFrame:rect];
            alarmLb.backgroundColor = RGB(215, 50, 143);
            [self addSubview:alarmLb];
            [self sendSubviewToBack:alarmLb];
        }
    }
}

@end
