//
//  CalenderWeekView.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderWeekView.h"
#import "UIColor+Extension.h"

@interface CalenderWeekView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation CalenderWeekView

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    for (UIView *view in self.subviews) {
        if ([view.class isKindOfClass:UILabel.class]) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat count  = dataSource.count;
    CGFloat labelW = self.frame.size.width / count;
    CGFloat labelY = 0;
    CGFloat labelH = self.frame.size.height;
    for (int i = 0; i < count; i++) {
        CGFloat labelX = i * labelW;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor     = [UIColor blackColor];
        label.font          = [UIFont systemFontOfSize:12];
        label.text          = dataSource[i];
        [self addSubview:label];
    }
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView                 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        _lineView.backgroundColor = self.weekBottomLineColor ? self.weekBottomLineColor : [UIColor lightGrayColor];
    }
    return _lineView;
}

-(void)setWeekBottomLineColor:(UIColor *)weekBottomLineColor {
    _weekBottomLineColor = weekBottomLineColor;
    self.lineView.backgroundColor = self.weekBottomLineColor ? self.weekBottomLineColor : [UIColor colorWithHexString:@"#000000" alpha:0.1];
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    
    if (showLine) {
        [self addSubview:self.lineView];
    } else {
        [self.lineView removeFromSuperview];
    }
}

@end

