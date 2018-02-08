//
//  ViewController.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "ViewController.h"
#import "CalenderView.h"

@interface ViewController ()<CalenderViewDelete>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CalenderView *view = [[CalenderView alloc] initWithFrame:self.view.frame startDay:@"2018-1-10" endDay:@"2019-2-8"];
    view.delegate = self;
    view.yearMonthFormat = @"%zd年%02zd月";
    view.actvityColor = YES;
    view.showWeekBottomLine = YES;
    [self.view addSubview:view];
}

-(void)calenderView:(NSIndexPath *)indexPath dateString:(NSString *)dateString {
    NSLog(@"%@",dateString);
}


@end
