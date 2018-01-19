//
//  CalenderView.h
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalenderViewDelete <NSObject>

@optional
- (void)calenderView:(NSIndexPath *)indexPath dateString:(NSString *)dateString;

@end

@interface CalenderView : UIView


/**
 初始化

 @param frame frame
 @param startDay 开始月份日期 格式：2018-1-17
 @param endDay 结束月份日期 格式：2019-1-17
 @return nil
 */
- (instancetype)initWithFrame:(CGRect)frame startDay:(NSString *)startDay endDay:(NSString *)endDay;

///星期数组，默认：[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]
@property (nonatomic, copy) NSArray *weekArray;
@property(nonatomic, weak) id<CalenderViewDelete> delegate;
///激活开始和结束时间内的颜色
@property (nonatomic, assign) BOOL actvityColor;

@property (nonatomic, assign) BOOL showWeekBottomLine;

@property (nonatomic, strong) UIColor *weekBottomLineColor;

///默认："%zd年%zd月" 
@property (nonatomic, copy) NSString *yearMonthFormat;

///格式：2018-1-17
@property (nonatomic, copy) NSString *selectedDate;

@end
