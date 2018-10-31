//
//  XMRulerView.h
//  XWorld
//
//  Created by DingLin on 17/2/17.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XMRecordType) {
    XMRecordTypeNone,
    XMRecordTypeNormal,      // 普通录像
    XMRecordTypeAlarm,       // 报警录像
    XMRecordTypeDetection,   // 检测录像
    XMRecordTypeHand,        // 手动录像
};


@interface XMTimeItem : NSObject
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, assign) XMRecordType type;

+(UIColor *)colorForType:(XMRecordType)type;
@end


@interface XMRulerView : UIView

@property (nonatomic, copy) NSArray <XMTimeItem *>* timeList;//时间列表

-(void)changePrecision:(NSUInteger) precision;//修改精度，目前只支持精度20和5


@end
