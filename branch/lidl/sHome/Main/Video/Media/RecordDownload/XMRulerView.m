//
//  XMRulerView.m
//  XWorld
//
//  Created by DingLin on 17/2/17.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import "XMRulerView.h"


@implementation XMTimeItem

-(instancetype)init {
    self = [super init];
    if (self) {
        _time = 0;
        _type = 0;
        
    }
    
    return self;
}

+(UIColor *)colorForType:(XMRecordType)type {
    switch (type) {
        case XMRecordTypeNone:{
            return [UIColor colorWithRed:177/255. green:174/255. blue:177/255. alpha:.8];
        }
            break;
        case XMRecordTypeNormal:{
            return [UIColor colorWithRed:127/255. green:168/255. blue:208/255. alpha:.8];
        }
            break;
        case XMRecordTypeAlarm:{
            return [UIColor colorWithRed:254/255. green:83/255. blue:83/255. alpha:.8];
        }
            break;
        case XMRecordTypeDetection:{
            return [UIColor colorWithRed:254/255. green:83/255. blue:83/255. alpha:.8];
        }
            break;
        case XMRecordTypeHand:{
            return [UIColor colorWithRed:0/255. green:255/255. blue:0/255. alpha:.8];
        }
            break;
        default:{
            return [UIColor colorWithRed:177/255. green:174/255. blue:177/255. alpha:.8];
        }
            break;
    }
}

@end


@interface XMRulerView ()
@property (nonatomic, assign) NSUInteger precision;//刻度尺的精度，以分钟为单位(小时的时候：20;分钟的时候：5)
@property (nonatomic, assign) NSUInteger precisionDistance;//刻度尺的刻度间距（以点为单位，默认为10）
@end

@implementation XMRulerView


-(instancetype)init {
    self = [super init];

    if (self) {
        _precision = 20.0f;
        _precisionDistance = 20;
  
    }
    
    return self;

}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    //刻度尺的长度
    CGFloat rulerWidth = rect.size.width;
    CGFloat rulerCenterY = rect.size.height/2;

    //画坐标尺的底线
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, 0, rulerCenterY);
    CGContextAddLineToPoint(context, rulerWidth, rulerCenterY);
    CGContextStrokePath(context);

    //坐标尺的刻度数目
    NSUInteger pointNum = 1440/_precision;//坐标尺上点的个数
    
    //画坐标尺的刻度线
    for (int i = 0; i < pointNum; i ++) {
        
        CGFloat precisionPoint = i*_precisionDistance;//精度线
        
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetLineWidth(context, 1);
        
        if (i%3 == 0) {
            CGContextMoveToPoint(context, precisionPoint, rulerCenterY-10);
            CGContextAddLineToPoint(context, precisionPoint, rulerCenterY+10);
        } else {
            CGContextMoveToPoint(context, precisionPoint, rulerCenterY-5);
            CGContextAddLineToPoint(context, precisionPoint, rulerCenterY+5);
        }

        CGContextStrokePath(context);
 
    }

    //画坐标尺的刻度值
    for (int i = 0; i < pointNum; i ++) {
        CGFloat precisionPoint = i*_precisionDistance;//精度线
        if (i%3 == 0) {
            
            //小时：精度为20
            if (_precision == 20) {
                int hour = i*20/60;
                int min = 0;
                NSString *precisionText = [NSString stringWithFormat:@"%02d:%02d", hour, min];
                [precisionText drawInRect:CGRectMake(precisionPoint, 40, 40, 20) withAttributes:nil];
            } else {
            //分钟：精度为5
                int hour = i*5/60;
                int min = i*5%60;
                NSString *precisionText = [NSString stringWithFormat:@"%02d:%02d", hour, min];
                [precisionText drawInRect:CGRectMake(precisionPoint, 40, 40, 20) withAttributes:nil];
            }
            
        }
    }
    
    //画录像类型
    if (_timeList && _timeList.count > 0) {
        for (int i = 0; i < _timeList.count; i++) {
            XMTimeItem *timeInfo = _timeList[i];
            
            //1分钟的距离:_precisionDistance/_precision
            CGFloat distancePerMin = _precisionDistance/_precision;
            CGFloat startPosition = timeInfo.time*distancePerMin;
            CGContextSetBlendMode(context, kCGBlendModeOverlay);
            [[XMTimeItem colorForType:timeInfo.type] setFill];
            CGContextFillRect(context, CGRectMake(startPosition, 0, distancePerMin, rulerWidth));
        }
    }

}




-(void)changePrecision:(NSUInteger) precision {

    _precision = precision;//修改精度值
    
    //重新绘制刻度尺
    [self setNeedsDisplay];
    
    
    

}


@end
