//
//  NSString+CYTime.m
//  CYKit
//
//  Created by CY on 2018/1/9.
//  Copyright © 2018年 陈勇. All rights reserved.
//

#import "NSString+CYTime.h"

#define CY_FormatString_YMD       @"yyyy-MM-dd"
#define CY_FormatString_YMDHM     @"yyyy-MM-dd HH:mm"
#define CY_FormatString_YMDHMS    @"yyyy-MM-dd HH:mm:ss"
#define CY_FormatString_YMDEHMS   @"yyyy-MM-dd, EEE, HH:mm:ss"
#define CY_FormatString_YM        @"yyyy-MM"
#define CY_FormatString_MDHM      @"MM-dd HH:mm"

#define CY_FormatString_YMD2      @"yyyy/MM/dd"
#define CY_FormatString_YMDHM2    @"yyyy/MM/dd HH:mm"
#define CY_FormatString_YMDHMS2   @"yyyy/MM/dd HH:mm:ss"
#define CY_FormatString_YMDEHMS2  @"yyyy/MM/dd, EEE, HH:mm:ss"
#define CY_FormatString_YM2       @"yyyy/MM"

#define CY_FormatString_YMD3      @"yyyy年MM月dd日"

#define CY_FormatString_Y         @"yyyy"
#define CY_FormatString_M         @"MM"
#define CY_FormatString_D         @"dd"
#define CY_FormatString_HM        @"HH:mm"
#define CY_FormatString_HMS       @"HH:mm:ss"

@implementation NSString (CYTime)

#pragma mark - 获取当前日期和时间
/**
 *  获取系统当前日期和时间【YYYY-MM-dd HH:mm:ss】
 */
+ (NSString *)cy_getCurrentDateAndTime {
    NSString *currentStr = [NSString cy_getCurrentDateWithFormatString:CY_FormatString_YMDHMS];
    return currentStr;
}

/**
 *  获取系统当前日期和时间【自定义 formatString】
 */
+ (NSString *)cy_getCurrentDateWithFormatString:(NSString *)formatString {
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatString];
    NSString *currentStr = [format stringFromDate:date];
    return currentStr;
}

#pragma mark - 时间戳 --> 时间
/**
 *  时间戳 --> 时间【YYYY-MM-dd HH:mm:ss】
 */
+ (NSString *)cy_getDateAndTimeWithTimeStamp:(NSString *)timeStamp {
    return [NSString cy_getDateWithTimeStamp:timeStamp formatString:CY_FormatString_YMDHMS];
}

/**
 *  时间戳 --> 时间【YYYY-MM-dd】
 */
+ (NSString *)cy_getDateWithTimeStamp:(NSString *)timeStamp {
    return [NSString cy_getDateWithTimeStamp:timeStamp formatString:CY_FormatString_YMD];
}

/**
 *  时间戳 --> 时间【HH:mm】
 */
+ (NSString *)cy_getTimeWithTimeStampHM:(NSString *)timeStamp {
    return [NSString cy_getDateWithTimeStamp:timeStamp formatString:CY_FormatString_HM];
}

/**
 *  时间戳 --> 时间【自定义 formatString】
 */
+ (NSString *)cy_getDateWithTimeStamp:(NSString *)timeStamp formatString:(NSString *)formatString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateFormat:formatString];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp intValue]];
    NSString *dateStr = [format stringFromDate:date];
    return dateStr;
}


#pragma mark - 时间 --> 时间戳
/**
 *  当前时间【YYYY-MM-dd HH:mm:ss】--> 时间戳【10位数，如：1492672164】
 */
+ (NSString *)cy_getCurrentDateTransformTimeStamp {
    NSDate *currentDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    return timeSp;
}

/**
 *  某个时间 --> 时间戳
 */
+ (NSString *)cy_getSomeDateTransformTimeStampFromDateString:(NSString *)dateStr andFormatter:(NSString *)formatter {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setTimeStyle:NSDateFormatterShortStyle];
    [format setDateFormat:formatter]; // 如(@"YYYY-MM-dd hh:mm:ss")
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [format setTimeZone:timeZone];
    NSDate *date = [format dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

#pragma mark - 日期 --> 星期几
/**
 *  日期 --> 星期几
 */
+ (NSString *)cy_getWeekdayWithDate:(NSDate *)date {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:calendarUnit fromDate:date];
    return [weekdays objectAtIndex:components.weekday];
}

#pragma mark - 指定日期 与 当前日期 的时间差
/**
 *  计算 指定日期 与 当前时间 的时间差
 */
+ (NSString *)cy_getIntervalSinceNowWithDate:(NSDate *)date {
    NSTimeInterval timeInterval = [date timeIntervalSince1970] * 1;
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentInterval = [currentDate timeIntervalSince1970] * 1;
    NSTimeInterval dif = currentInterval - timeInterval;
    NSString *difStr = [NSString stringWithFormat:@"%f", dif];
    return difStr;
}

/**
 *  未公开 生成当天的某个点 返回伦敦时间，可直接与当前时间[NSDate date]比较
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:[currentComps year]];
    [comps setMonth:[currentComps month]];
    [comps setDay:[currentComps day]];
    [comps setHour:hour];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateFromComponents:comps];
}

/**
 *  判断当前时间是否在 fromHour 和 toHour 之间。fromHour=8，toHour=23时，即为推断当前时间是否在8:00-23:00之间，比如夜间模式。在这个当前的时间是如何推断出期间。主要的困难在于如何使用NSDate生成8：00时间和23：00时间。
 */
- (BOOL)cy_isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour {
    NSDate *date8 = [self getCustomDateWithHour:fromHour];
    NSDate *date23 = [self getCustomDateWithHour:toHour];
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:date8] == NSOrderedDescending && [currentDate compare:date23] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

/**
 *  计算上报时间差: 几分钟前，几天前，刚刚，传入时间戳，自动解析
 */
+ (NSString *)cy_formatWithTimeStamp:(NSString *)timeStamp {
    return @"";
}

/**
 *  解析新浪微博中的日期【判断日期是今天，昨天还是明天】
 */
+ (NSString *)cy_formatWithDateString:(NSString *)dateString {
    return @"";
}

#pragma mark - 字符串 --> 时间
/**
 *  字符串 --> NSDate
 */
- (NSDate *)cy_dateWithFormatString:(NSString *)formatString {
    if (self == nil || [self isEqualToString:@""] || formatString == nil || [formatString isEqualToString:@""]) {
        return nil;
    }
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatString;
    return [fmt dateFromString:self];
}

@end
