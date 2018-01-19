//
//  CalenderWeekView.h
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalenderWeekView : UIView

//星期
@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, assign) BOOL showLine;

@property (nonatomic, strong) UIColor *weekBottomLineColor;

@end
