//
//  CalenderView.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderCollectionCell.h"
#import "CalenderHeaderView.h"
#import "CalenderModel.h"
#import "CalenderView.h"
#import "CalenderWeekView.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"

@interface CalenderView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *dataSource;
@property (nonatomic, strong) CalenderWeekView *weekView;
@property (nonatomic, strong) NSIndexPath      *lastIndexPath;

@property (nonatomic, copy) NSString *startDay;
@property (nonatomic, copy) NSString *endDay;

@end

static NSString *const reuseIdentifier  = @"collectionViewCell";
static NSString *const headerIdentifier = @"headerIdentifier";

@implementation CalenderView

- (instancetype)initWithFrame:(CGRect)frame startDay:(NSString *)startDay endDay:(NSString *)endDay {
    self = [super initWithFrame:frame];
    if (self) {
        self.startDay = startDay;
        self.endDay   = endDay;
        [self buildSource];
        [self addSubview:self.weekView];
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - 设置数据源
- (void)buildSource {
    NSAssert(self.startDay.length && self.endDay.length, @"开始时间和结束时间不能为空");
    if (!self.startDay.length || !self.endDay.length) {
        self.startDay = [NSDate timeStringWithInterval:[NSDate date].timeIntervalSince1970];
        self.endDay   = [NSDate timeStringWithInterval:[NSDate date].timeIntervalSince1970];
    }
    
    NSArray   *startArray = [self.startDay componentsSeparatedByString:@"-"];
    NSArray   *endArray   = [self.endDay componentsSeparatedByString:@"-"];
    NSInteger month       = ([endArray[0] integerValue] - [startArray[0] integerValue])* 12 + ([endArray[1] integerValue] - [startArray[1] integerValue]) + 1;
    
    for (int i = 0; i < month; i++) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [self.dataSource addObject:array];
    }
    
    for (int i = 0; i < month; i++) {
        int              calcNumberMonth = (int)[NSDate month:self.startDay] + i;
        int              month           = (calcNumberMonth)%12;
        NSDateComponents *components     = [[NSDateComponents alloc]init];
        
        //获取下个月的年月日信息,并将其转为date
        components.month = month ? month : 12;
        components.year  = [startArray[0] integerValue] + (calcNumberMonth == 12 ? 0 : calcNumberMonth) / 12;
        components.day   = 1;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate     *nextDate = [calendar dateFromComponents:components];
        
        //获取该月第一天星期几
        NSInteger firstDayInThisMounth = [NSDate firstWeekdayInThisMonth:nextDate];
        
        //该月的有多少天daysInThisMounth
        NSInteger daysInThisMounth = [NSDate totaldaysInMonth:nextDate];
        NSString  *string          = [[NSString alloc]init];
        for (int j = 0; j < (daysInThisMounth > 29 && (firstDayInThisMounth == 6 || firstDayInThisMounth == 5) ? 42 : 35); j++) {
            CalenderModel *model = [[CalenderModel alloc] init];
            model.year  = components.year;
            model.month = components.month;
            if (j < firstDayInThisMounth || j > daysInThisMounth + firstDayInThisMounth - 1) {
                string    = @"";
                model.day = string;
            } else {
                string    = [NSString stringWithFormat:@"%02ld", j - firstDayInThisMounth + 1];
                model.day = string;
                
                NSString *dateStr = [NSString stringWithFormat:@"%zd-%02zd-%@", model.year, model.month, model.day];
                if ([self isActivity:dateStr]) {
                    model.activityColor = [UIColor blackColor];
                }
                if (self.selectedDate.length) {
                    if ([NSDate isEqualBetweenWithDate:self.selectedDate toDate:dateStr]) {
                        model.isSelected   = YES;
                        self.lastIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    }
                    if ([NSDate isToday:dateStr]) {
                        model.isToday = YES;
                    }
                } else {
                    if ([NSDate isToday:dateStr]) {
                        model.isToday      = YES;
                        model.isSelected   = YES;
                        self.lastIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                    }
                }
            }
            [[self.dataSource objectAtIndex:i]addObject:model];
        }
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataSource objectAtIndex:section] count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CalenderModel *model = self.dataSource[indexPath.section][indexPath.item];
    
    if (!model.day.length) {
        return;
    }
    
    NSString *selectDate = [NSString stringWithFormat:@"%zd-%zd-%@", model.year, model.month, model.day];
    if (![self isActivity:selectDate]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(calenderView:dateString:)]) {
        [self.delegate calenderView:indexPath dateString:selectDate];
    }
    
    if (indexPath == self.lastIndexPath) {
        return;
    }
    
    if (self.lastIndexPath) {
        CalenderModel *lastModel = self.dataSource[self.lastIndexPath.section][self.lastIndexPath.item];
        lastModel.isSelected                                                 = !lastModel.isSelected;
        self.dataSource[self.lastIndexPath.section][self.lastIndexPath.item] = lastModel;
    }
    
    model.isSelected                                   = !model.isSelected;
    self.dataSource[indexPath.section][indexPath.item] = model;
    self.lastIndexPath                                 = indexPath;
    [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalenderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    CalenderModel *model = self.dataSource[indexPath.section][indexPath.item];
    
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CalenderHeaderView *heardView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        CalenderModel      *model     = self.dataSource[indexPath.section][indexPath.item];
        heardView.yearAndMonthLabel.text = [NSString stringWithFormat:self.yearMonthFormat.length ? self.yearMonthFormat : @"%zd年%zd月", model.year, model.month];
        NSString *dateStr = [NSString stringWithFormat:@"%zd-%02zd", model.year, model.month];
        if ([NSDate isCurrenMonth:dateStr]) {
            heardView.yearAndMonthLabel.textColor = [UIColor colorWithHexString:@"#00BB00"];
        } else {
            heardView.yearAndMonthLabel.textColor = [UIColor blackColor];
        }
        return heardView;
    }
    
    return nil;
}

#pragma mark - set
- (void)setActvityColor:(BOOL)actvityColor {
    [self.dataSource removeAllObjects];
    [self buildSource];
    [self.collectionView reloadData];
}

- (void)setWeekBottomLineColor:(UIColor *)weekBottomLineColor {
    _weekBottomLineColor              = weekBottomLineColor;
    self.weekView.weekBottomLineColor = weekBottomLineColor;
}

- (void)setShowWeekBottomLine:(BOOL)showWeekBottomLine {
    _showWeekBottomLine    = showWeekBottomLine;
    self.weekView.showLine = showWeekBottomLine;
}

- (BOOL)isActivity:(NSString *)date {
    BOOL activity = NO;
    
    NSTimeInterval startInterval   = [NSDate timeIntervalFromDateString:[NSString stringWithFormat:@"%@ 00:00:00", self.startDay]];
    NSTimeInterval endInterval     = [NSDate timeIntervalFromDateString:[NSString stringWithFormat:@"%@ 00:00:00", self.endDay]];
    NSTimeInterval currentInterval = [NSDate timeIntervalFromDateString:[NSString stringWithFormat:@"%@ 00:00:00", date]];
    
    if (currentInterval >= startInterval && currentInterval <= endInterval) {
        activity = YES;
    }
    return activity;
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        float                      cellw       = self.bounds.size.width/7;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setHeaderReferenceSize:CGSizeMake(self.frame.size.width, 50)];
        flowLayout.sectionInset            = UIEdgeInsetsMake(0, -1, 0, 0);
        flowLayout.minimumInteritemSpacing = -1;
        flowLayout.minimumLineSpacing      = 0;
        flowLayout.itemSize                = CGSizeMake(cellw, 50);
        
        CGFloat collectionViewY = CGRectGetMaxY(self.weekView.frame);
        CGFloat collectionViewH = self.frame.size.height - collectionViewY;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionViewY, self.frame.size.width, collectionViewH)  collectionViewLayout:flowLayout];
        
        _collectionView.dataSource                     = self;
        _collectionView.delegate                       = self;
        _collectionView.showsVerticalScrollIndicator   = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[CalenderHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        [_collectionView registerClass:[CalenderCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (CalenderWeekView *)weekView {
    if (_weekView == nil) {
        _weekView            = [[CalenderWeekView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 32)];
        _weekView.dataSource = self.weekArray ? self.weekArray : @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    }
    return _weekView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

