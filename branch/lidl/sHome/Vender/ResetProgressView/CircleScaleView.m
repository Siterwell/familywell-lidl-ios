//
//  CircleScaleView.m
//  sHome
//
//  Created by Henry on 2019/5/31.
//  Copyright © 2019 SiterWell. All rights reserved.
//

#import "CircleScaleView.h"
#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )

@interface CircleScaleView()

@property (nonatomic,weak) UIColor *color;

@end


@implementation CircleScaleView{
    CGFloat radius_width;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        radius_width = (fmin(CGRectGetWidth(frame),CGRectGetHeight(frame))/2-10);
        //透明背景
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.00f];
    }
    
    return  self;
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.02] set];
//    CGContextFillRect(context, rect);
   CGPoint pointcenter = CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect));
    /*画直线
     */
    

    CGContextSetLineWidth(context, 2);
    for(int i=0;i<72;i++){
        [RGBA(43, 148, 255,1.0f * (i+1)/72) set];
        CGPoint points[2];
        points[0] = [self calcCircleCoordinateWithCenter:pointcenter andWithAngle:5*i andWithRadius:radius_width-10];
        points[1] = [self calcCircleCoordinateWithCenter:pointcenter andWithAngle:5*i andWithRadius:radius_width];
        
        CGContextAddLines(context, points, 2);
        CGContextDrawPath(context, kCGPathStroke);
    }


    
}


-(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(ToRad(angle));
    CGFloat y2 = radius*sinf(ToRad(angle));
    return CGPointMake(center.x+x2, center.y-y2);
}
@end
