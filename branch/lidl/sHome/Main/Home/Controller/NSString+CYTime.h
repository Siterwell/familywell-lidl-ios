//
//  NSString+CYTime.h
//  CYKit
//
//  Created by CY on 2018/1/9.
//  Copyright © 2018年 陈勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CYTime)

#pragma mark - 获取当前日期和时间
/**
 *  获取系统当前日期和时间【YYYY-MM-dd HH:mm:ss】
 */
+ (NSString *)cy_getCurrentDateAndTime;

/**
 *  获取系统当前日期和时间【自定义 formatString】
 */
+ (NSString *)cy_getCurrentDateWithFormatString:(NSString *)formatString;

#pragma mark - 时间戳 --> 时间
/**
 *  时间戳 --> 时间【YYYY-MM-dd HH:mm:ss】
 */
+ (NSString *)cy_getDateAndTimeWithTimeStamp:(NSString *)timeStamp;

/**
 *  时间戳 --> 时间【YYYY-MM-dd】
 */
+ (NSString *)cy_getDateWithTimeStamp:(NSString *)timeStamp;

/**
 *  时间戳 --> 时间【HH:mm】
 */
+ (NSString *)cy_getTimeWithTimeStampHM:(NSString *)timeStamp;

/**
 *  时间戳 --> 时间【自定义 formatString】
 */
+ (NSString *)cy_getDateWithTimeStamp:(NSString *)timeStamp formatString:(NSString *)formatString;

#pragma mark - 当前时间 --> 时间戳
/**
 *  当前时间【YYYY-MM-dd HH:mm:ss】--> 时间戳【10位数，如：1492672164】
 */
+ (NSString *)cy_getCurrentDateTransformTimeStamp;

/**
 *  某个时间 --> 时间戳
 */
+ (NSString *)cy_getSomeDateTransformTimeStampFromDateString:(NSString *)dateStr andFormatter:(NSString *)formatter;

#pragma mark - 日期 --> 星期几
/**
 *  日期 --> 星期几
 */
+ (NSString *)cy_getWeekdayWithDate:(NSDate *)date;

#pragma mark - 指定日期 与 当前日期 的时间差
/**
 *  计算 指定日期 与 当前时间 的时间差
 */
+ (NSString *)cy_getIntervalSinceNowWithDate:(NSDate *)date;

/**
 *  判断当前时间是否在 fromHour 和 toHour 之间。fromHour=8，toHour=23时，即为推断当前时间是否在8:00-23:00之间，比如夜间模式。在这个当前的时间是如何推断出期间。主要的困难在于如何使用NSDate生成8：00时间和23：00时间。
 */
- (BOOL)cy_isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;

/**
 *  计算上报时间差: 几分钟前，几天前，刚刚，传入时间戳，自动解析
 */
+ (NSString *)cy_formatWithTimeStamp:(NSString *)timeStamp;

/**
 *  解析新浪微博中的日期【判断日期是今天，昨天还是明天】
 */
+ (NSString *)cy_formatWithDateString:(NSString *)dateString;

#pragma mark - 字符串 --> 时间
/**
 *  字符串 --> NSDate
 */
- (NSDate *)cy_dateWithFormatString:(NSString *)formatString;


@end
