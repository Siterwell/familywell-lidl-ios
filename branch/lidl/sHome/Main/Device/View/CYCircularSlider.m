//
//  CYCircularSlider.m
//  Familywell
//
//  Created by TracyHenry on 2018/11/8.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "CYCircularSlider.h"

#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )
@interface CYCircularSlider()


@end

@implementation CYCircularSlider{
    int _angle;
    CGFloat radius;
    int _fixedAngle;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _maximumValue = 30.0f;
        _minimumValue = 5.0f;
        _currentValue = 5.0f;
        _lineWidth = 15.0f;
        _unfilledColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
        _filledColor = [UIColor colorWithRed:175/255.0f green:195/255.0f blue:5/255.0f alpha:1.0f];
        radius = self.frame.size.height/2 - _lineWidth/2-10;
        _angle = 400;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return  self;
}

#pragma mark 画圆
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //获取图像上下文对象
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 250/255.0, 250/255.0, 250/255.0, 1);
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);

    
    //使用填充模式绘制文字
    CGContextSetTextDrawingMode(context,kCGTextFill);
    NSString *str = [NSString stringWithFormat:@"%1.0f℃",_minimumValue];
    [str drawAtPoint:CGPointMake(25, self.frame.size.height-45) withAttributes:@{NSFontAttributeName:[
                                                                               UIFont fontWithName:@"Arial" size:15],NSForegroundColorAttributeName:HEXCOLOR(0x9ca2a6)}];
    
    //使用填充模式绘制文字
    NSString *str2 = [NSString stringWithFormat:@"%1.0f℃",_maximumValue];
    [str2 drawAtPoint:CGPointMake(self.frame.size.width-50, self.frame.size.height-45) withAttributes:@{NSFontAttributeName:[
                                                                               UIFont fontWithName:@"Arial" size:15],NSForegroundColorAttributeName:HEXCOLOR(0x9ca2a6)}];
    
    
    //画固定的下层圆
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, M_PI/180*140, M_PI/180*40, 0);
    [_unfilledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, M_PI/180*140, M_PI/180*(_angle), 0);
   //画可滑动的上层圆
    [_filledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(ctx, kCGPathStroke);

    /**
     这里先画一次圆的作用是作为渐变区域的遮罩，使得thumb能正常显示，如果不加，thumb显示异常
     **/
    CGPoint handleCenter =  [self pointFromAngle: _angle];
    [_handleColor set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-5, handleCenter.y-5, _lineWidth+10, _lineWidth+10));
    [_handleColor2 set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-5+10, handleCenter.y-5+2, 8, 8));
    /**
     这里先画一次圆的作用是作为渐变区域的遮罩，使得thumb能正常显示，如果不加，thumb显示异常
     **/
    
    // 设置线条端点为圆角
    CGContextSetLineCap(ctx, kCGLineCapRound);
    // 设置画笔颜色
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    // 逆时针画一个圆弧
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, M_PI/180*140, M_PI/180*(_angle), 0);
    
    // 2. 创建一个渐变色
    // 创建RGB色彩空间，创建这个以后，context里面用的颜色都是用RGB表示
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 渐变色的颜色
    NSArray *colorArr = @[
                          (id)HEXCOLOR(0x06aee8).CGColor,
                          (id)HEXCOLOR(0x8acd6b).CGColor,
                          (id)HEXCOLOR(0xe4fc08).CGColor
                          ];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorArr, NULL);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpace);
    colorSpace = NULL;
    
    // ----------以下为重点----------
    // 3. "反选路径"
    // CGContextReplacePathWithStrokedPath
    // 将context中的路径替换成路径的描边版本，使用参数context去计算路径（即创建新的路径是原来路径的描边）。用恰当的颜色填充得到的路径将产生类似绘制原来路径的效果。你可以像使用一般的路径一样使用它。例如，你可以通过调用CGContextClip去剪裁这个路径的描边
    CGContextReplacePathWithStrokedPath(ctx);
    // 剪裁路径
    CGContextClip(ctx);
    
    // 4. 用渐变色填充
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, rect.size.height / 2), CGPointMake(rect.size.width, rect.size.height / 2), 0);
    // 释放渐变色
    CGGradientRelease(gradient);

    [self drawHandle:ctx];
}

#pragma mark 画按钮
-(void)drawHandle:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGPoint handleCenter =  [self pointFromAngle: _angle];
    [_handleColor set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-5, handleCenter.y-5, _lineWidth+10, _lineWidth+10));
    [_handleColor2 set];
     CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-5+10, handleCenter.y-5+2, 8, 8));
    
   CGContextRestoreGState(ctx);
}

-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2, self.frame.size.height/2 - _lineWidth/2);
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(angleInt)));
    
    return result;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    return YES;
}

-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
 
    //用于排除点在圆外面点与圆心半径80以内的点
    if ((lastPoint.x>=0&&lastPoint.x<=275)&&(lastPoint.y>=0 && lastPoint.y<=275)) {
        
        if ((lastPoint.x<=57.5 ||lastPoint.x>=217.5)||(lastPoint.y<=57.5 ||lastPoint.y>=217.5)) {
            [self moveHandle:lastPoint];
        }
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    int currentAngle = floor(AngleFromNorth(centerPoint, point, NO));
    if (currentAngle>40 && currentAngle <140) {
    }else{
        if (currentAngle<=40) {
            _angle = currentAngle+360;
        }else{
            _angle = currentAngle;
        }
        
    }
    _currentValue = floorf([self valueFromAngle]*2)/2+_minimumValue;
    [self.delegate senderMoveWithFloat:_currentValue];
    [self setNeedsDisplay];
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

//在这个地方调整进度条
-(float) valueFromAngle {
    float  currentValue;
    if(_angle <= 40) {
       currentValue = 220+_angle;
    } else{
        currentValue = _angle-100-40;
    }
    _fixedAngle = currentValue;

    return (currentValue*(_maximumValue - _minimumValue))/260.0f;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    ;
    [self.delegate senderVlueWithNum:floorf([self valueFromAngle]*2)/2+_minimumValue];
}

#pragma mark 设置进度条位置
-(void)setAngel:(int)num{
    _angle = num;
    [self setNeedsDisplay];
}

-(void)setAddAngel{
    _angle += (int)260/(_maximumValue - _minimumValue);
    if (_angle>400) {
        _angle = 400;
    }
    [self setNeedsDisplay];
}

-(void)setMovAngel{
    _angle -= (int)260/(_maximumValue - _minimumValue);
    if (_angle<140) {
        _angle = 140;
    }
    [self setNeedsDisplay];
}

-(void)setMinimumValue:(float)minimumValue{
    _minimumValue = minimumValue;
    _angle = (int)(260*(_currentValue-_minimumValue)/(_maximumValue-_minimumValue) + 140);
    if (_angle<140) {
        _angle = 140;
    }
    
    if(_angle>400){
        _angle = 400;
    }
    
    [self setNeedsDisplay];
}

-(void)setMaximumValue:(float)maximumValue{
    _maximumValue = maximumValue;
    _angle = (int)(260*(_currentValue-_minimumValue)/(_maximumValue-_minimumValue) + 140);
    if (_angle<140) {
        _angle = 140;
    }
    if(_angle>400){
        _angle = 400;
    }
    [self setNeedsDisplay];
}

-(void)setCurrentValue:(float)currentValue{
    _currentValue = currentValue;
    _angle = (int)(260*(_currentValue-_minimumValue)/(_maximumValue-_minimumValue) + 140);
    if (_angle<140) {
        _angle = 140;
    }
    if(_angle>400){
        _angle = 400;
    }
    [self setNeedsDisplay];
}

@end
