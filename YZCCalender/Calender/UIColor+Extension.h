//
//  UIColor+Extension.h
//  YZCCalender
//
//  Created by Jason on 2018/1/19.
//  Copyright © 2018年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

// 默认alpha位1
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
