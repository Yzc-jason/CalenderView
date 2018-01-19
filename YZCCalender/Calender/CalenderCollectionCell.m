//
//  CalenderCollectionCell.m
//  YZCCalender
//
//  Created by Jason on 2018/1/17.
//  Copyright © 2018年 jason. All rights reserved.
//

#import "CalenderCollectionCell.h"
#import "CalenderModel.h"
#import "UIColor+Extension.h"

@interface CalenderCollectionCell()
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation CalenderCollectionCell

#pragma mark - lazy

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 30 * 0.5, self.frame.size.height * 0.5 - 30 * 0.5, 30, 30)];
        _numberLabel.textAlignment   = NSTextAlignmentCenter;
        _numberLabel.font            = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_numberLabel];
    }
    return _numberLabel;
}

-(void)setModel:(CalenderModel *)model {
    _model = model;
    self.numberLabel.text = model.day;
    if (model.isSelected) {
        self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.width * 0.5;
        self.numberLabel.layer.masksToBounds = YES;
        self.numberLabel.backgroundColor =  [UIColor colorWithHexString:@"#000000"];
        self.numberLabel.textColor = [UIColor whiteColor];
        if (model.isToday) {
            self.numberLabel.backgroundColor =  [UIColor colorWithHexString:@"#00BB00"];
        }
        [self addAnimaiton];
    }else{
        self.numberLabel.layer.cornerRadius = 0;
        self.numberLabel.layer.masksToBounds = YES;
        self.numberLabel.backgroundColor = [UIColor clearColor];
        self.numberLabel.textColor = model.activityColor ? model.activityColor : [UIColor colorWithHexString:@"#000000" alpha:0.15];
        if (model.isToday) {
            self.numberLabel.textColor = [UIColor colorWithHexString:@"#00BB00"];
        }
    }
    
}


-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    
    anim.values = @[@0.6,@1.2,@1.0];
    anim.keyPath = @"transform.scale";  // transform.scale 表示长和宽都缩放
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;
    [self.numberLabel.layer addAnimation:anim forKey:nil];
}
@end

