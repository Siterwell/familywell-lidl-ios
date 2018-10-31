//
//  CustomView.m
//  ScirCleView
//
//  Created by shaop on 16/9/7.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "CustomView.h"
#import <POP/POP.h>
#import "Masonry.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface CustomView()
@property(nonatomic) CAShapeLayer *circleLayer;
@property(nonatomic) CAShapeLayer *backLayer;
@property(nonatomic) UIView *tranView;

@end

@implementation CustomView
{
    int nowSocre;
    int endTrok;
}
-(id)init{
    self = [super init];
    if (self) {
        [self addCircleLayer];
        self.circleLayer.strokeEnd = 0;
        endTrok = 0 ;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addCircleLayer];
        self.circleLayer.strokeEnd = 0;
        endTrok = 0 ;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addCircleLayer];
        self.circleLayer.strokeEnd = 0;
        endTrok = 0 ;
    }
    return self;
}



- (void)addCircleLayer
{
    
    nowSocre = 0;
    self.tranView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.tranView];
    
    CGFloat lineWidth = 10.f;
    CGFloat radius = CGRectGetWidth(self.bounds)/2 - lineWidth/2;
    self.circleLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius * 2, radius * 2);
    self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                       cornerRadius:radius].CGPath;
    
    self.circleLayer.strokeColor = RGB(51, 167, 255).CGColor;
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineWidth = lineWidth;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.lineJoin = kCALineJoinRound;
    
    self.backLayer = [CAShapeLayer layer];
    self.backLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                     cornerRadius:radius].CGPath;
    self.backLayer.strokeColor = [RGB(206, 212, 226) CGColor];
    self.backLayer.fillColor = nil;
    self.backLayer.lineWidth = lineWidth;
    [self.tranView.layer addSublayer:self.backLayer];
    
    WS(ws)
    
    [self.tranView.layer addSublayer:self.circleLayer];

    self.souceLabel = [[UILabel alloc] init];
    self.souceLabel.font = [UIFont fontWithName:@"Courier" size:50];
    self.souceLabel.textColor = RGB(51, 167, 255);
    [self addSubview:self.souceLabel];
    

    
    [self.souceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
    }];
    
}


-(void)startAnimotionWithSouce:(NSInteger)Souce WithDuration:(int)time{
    
    CGFloat strokeEnd = Souce * 1.0 / 100;
    
    POPBasicAnimation *strokeAnimation3 = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    strokeAnimation3.toValue = @(strokeEnd);
    strokeAnimation3.duration = time;
    strokeAnimation3.removedOnCompletion = YES;
    [self.circleLayer pop_addAnimation:strokeAnimation3 forKey:@"layerStrokeAnimation"];
    
    //数字变化
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
        
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            UILabel *lable = (UILabel*)obj;
            lable.text = [NSString stringWithFormat:@"%02d%%",((int)values[0])];
            nowSocre = (int)values[0];
        };
    }];
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];
    anBasic.property = prop;
    anBasic.fromValue = @(nowSocre);
    anBasic.toValue = @(Souce);
    anBasic.duration = time;
    anBasic.removedOnCompletion = YES;
    [self.souceLabel pop_addAnimation:anBasic forKey:@"countdown"];
    
}


@end
