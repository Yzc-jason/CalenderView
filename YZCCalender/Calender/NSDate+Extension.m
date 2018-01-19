//
//  NSDate+Extension.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
#pragma mark -- 获取日
+ (NSInteger)day:(NSString *)date {
    NSDateFormatter  *dateFormatter = [[self class] setDataFormatter];
    NSDate           *startDate     = [dateFormatter dateFromString:date];
    NSDateComponents *components    = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    
    return components.day;
}

#pragma mark -- 获取月
+ (NSInteger)month:(NSString *)date {
    NSDateFormatter  *dateFormatter = [[self class] setDataFormatter];
    NSDate           *startDate     = [dateFormatter dateFromString:date];
    NSDateComponents *components    = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    
    return components.month;
}

#pragma mark -- 获取年
+ (NSInteger)year:(NSString *)date {
    NSDateFormatter  *dateFormatter = [[self class] setDataFormatter];
    NSDate           *startDate     = [dateFormatter dateFromString:date];
    NSDateComponents *components    = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    
    return components.year;
}

#pragma mark -- 获得当前月份第一天星期几
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //设置每周的第一天从周几开始,默认为1,从周日开始
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate     *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday         = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    //若设置从周日开始算起则需要减一,若从周一开始算起则不需要减
    return firstWeekday - 1;
}

#pragma mark -- 获取当前月共有多少天
+ (NSInteger)totaldaysInMonth:(NSDate *)date {
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return daysInLastMonth.length;
}

#pragma mark -- 获取日期
+ (NSString *)timeStringWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [[self class] setDataFormatter];
    NSDate          *date          = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString        *dateString    = [dateFormatter stringFromDate:date];
    
    return dateString;
}

#pragma mark -- 设置日期格式
+ (NSDateFormatter *)setDataFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    return dateFormatter;
}

#pragma mark -- 计算两个日期之间相差天数
+ (NSDateComponents *)calcDaysbetweenDate:(NSString *)startDateStr endDateStr:(NSString *)endDateStr {
    NSDateFormatter *dateFormatter = [[self class] setDataFormatter];
    NSDate          *startDate     = [dateFormatter dateFromString:startDateStr];
    NSDate          *endDate       = [dateFormatter dateFromString:endDateStr];
    
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth;
    
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    return delta;
}

+ (NSTimeInterval)timeIntervalFromDateString:(NSString *)dateString {
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
    }
    
    NSDate         *date    = [dateFormatter dateFromString:dateString];
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    return interval;
}


+ (BOOL)isToday:(NSString *)date {
    BOOL isToday = NO;
    NSString *today = [NSDate timeStringWithInterval:[NSDate date].timeIntervalSince1970];
    if ([date isEqualToString:today]) {
        isToday = YES;
    }
    return isToday;
}

+ (BOOL)isEqualBetweenWithDate:(NSString *)date toDate:(NSString *)toDate {
    BOOL isToday = NO;
    if ([toDate isEqualToString:date]) {
        isToday = YES;
    }
    return isToday;
}

+ (BOOL)isCurrenMonth:(NSString *)date {
    BOOL isCurrenMonth = NO;
    NSString *month = [[NSDate timeStringWithInterval:[NSDate date].timeIntervalSince1970] substringWithRange:NSMakeRange(0, 7)];
    
    if ([date isEqualToString:month]) {
        isCurrenMonth = YES;
    }
    return isCurrenMonth;
}

@end

