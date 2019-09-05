//
//  RFCustomButton.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/3.
//  Copyright © 2017年 riceFun. All rights reserved.
//

#import "RFCustomButton.h"

@implementation RFCustomButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSomePropertys];
    }
    return self;

}


- (instancetype)init{
    self = [super init];
    if (self) {
       [self setSomePropertys];
    }
    return self;
}

-(void)setSomePropertys
{
//    self.layer.borderColor = ThemeColor.CGColor;
//    self.layer.borderWidth = 1;
    [self setTitleColor:ThemeColor forState:UIControlStateNormal];
    [self setTitleColor:ThemeColor forState:UIControlStateHighlighted];
    
}
@end
