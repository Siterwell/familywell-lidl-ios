//
//  TestView.m
//  CircleDemo
//
//  Created by apple on 2017/2/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "LZCircularSlider.h"
#define  ToRad(ang)  ((M_PI *(ang)) / 180)//度数转化为弧度
#define  ToAng(rad)  ( (180.0 * (rad)) / M_PI )//弧度转化为度数
#define SQR(x)			( (x) * (x) )g

@interface LZCircularSlider ()
{
    int  angle;
    NSInteger radius;
}

@end

@implementation LZCircularSlider


-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        
        angle =180;
        radius =self.frame.size.width/2-20;
     }

    return self;
}

- (void)setCurrentValue:(int)currentValue {
    angle = (currentValue+101)/(101/180.0);
//    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
 
    [self drawUpCircleAtX:self.frame.size.width/2 Y:self.frame.size.height/2];
}


- (void)drawUpCircleAtX:(float)x Y:(float)y {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, x, y, radius,ToRad(180), ToRad(360), 0);
    CGContextSetStrokeColorWithColor(ctx, _unfilledColor.CGColor);
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextAddArc(ctx, x, y, radius,ToRad(180), ToRad(angle), 0);
    CGContextSetStrokeColorWithColor(ctx, _filledColor.CGColor);
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //CGContextStrokePath(ctx);
    CGContextDrawPath(ctx, kCGPathStroke);
    [self drawUpHandle:ctx];
}

-(void) drawUpHandle:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGPoint handleCenter =  [self pointFromAngle:angle];
    [[UIColor clearColor]set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-_lineWidth/2, handleCenter.y-_lineWidth/2,10,10));//填充指定的矩形
    UIImage *image = [UIImage imageNamed:@"04-进度球"];
    [image drawAtPoint:CGPointMake(handleCenter.x-_lineWidth/2-5-2,handleCenter.y-_lineWidth/2-5- 2)];
    CGContextRestoreGState(ctx);
}

-(CGPoint)pointFromAngle:(int)angleInt{
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //Define The point position on the circumference
    CGPoint result;
    CGFloat y = centerPoint.y + (radius)*sin(ToRad(angleInt));
    CGFloat x = centerPoint.x + (radius)*cos(ToRad(angleInt));
    result =CGPointMake(x, y);
    return result;
}

#pragma mark---UIControl Method
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    return  YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint lastPoint =[touch locationInView:self];

       [self moveUpHandle:lastPoint];
     [self sendActionsForControlEvents:UIControlEventValueChanged];   
    return YES;
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
}
-(void)moveUpHandle:(CGPoint)point{

    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    int currentAngle = floor(AngleFromNorth(centerPoint, point, NO));

    if (currentAngle < 180 || currentAngle > 360) {
       
        return;
    }

    angle  =currentAngle;
    _currentValue = [self valueFromAngle];
    
    [self setNeedsDisplay];
  
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    
    float result = 0 ;
    double radians = atan2(v.y,v.x);
    result = ToAng(radians);
    return (result >= 0  ? result : result + 360.0);
}

- (CGFloat)valueFromAngle{
    return  (angle-180)*(_maximumValue-_minimumValue)/180;
}


@end
