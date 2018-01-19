//
//  NSDate+Extension.h
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/// 获取日
+ (NSInteger)day:(NSString *)date;
/// 获取月
+ (NSInteger)month:(NSString *)date;
/// 获取年
+ (NSInteger)year:(NSString *)date;
/// 获取当月第一天周几
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
/// 获取当前月有多少天
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
/// 计算两个日期之间相差天数
+ (NSDateComponents *)calcDaysbetweenDate:(NSString *)startDateStr endDateStr:(NSString *)endDateStr;
/// 获取日期
+ (NSString *)timeStringWithInterval:(NSTimeInterval)timeInterval;
///根据具体日期获取时间戳
+ (NSTimeInterval)timeIntervalFromDateString:(NSString *)dateString;

+ (BOOL)isToday:(NSString *)date;
+ (BOOL)isEqualBetweenWithDate:(NSString *)date toDate:(NSString *)toDate;
///格式：2018-01
+ (BOOL)isCurrenMonth:(NSString *)date;
@end
