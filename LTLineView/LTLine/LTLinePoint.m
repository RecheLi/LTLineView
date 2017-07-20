//
//  LTLinePoint.m
//  LTLineView
//
//  Created by liht on 2017/7/19.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import "LTLinePoint.h"

@interface LTLinePoint ()

@property (assign, nonatomic, readwrite) CGFloat realline_x;

@property (assign, nonatomic, readwrite) CGFloat realline_y;

@property (assign, nonatomic, readwrite) CGFloat dashline_x;

@property (assign, nonatomic, readwrite) CGFloat dashline_y;

@property (assign, nonatomic, readwrite) CGFloat date_x;

@property (assign, nonatomic, readwrite) CGFloat date_y;

@end
@implementation LTLinePoint

@end

@implementation LTLineData

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"realWeights":@"LTLinePoint",
             @"dashWeights":@"LTLinePoint"};
}

- (void)setupReallinePoints {
    CGFloat initial_x = kScreenWidth/2.0;
    [self.realWeights enumerateObjectsUsingBlock:^(LTLinePoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.date_x = initial_x + idx * (kLTLineViewDateSpace + kLTLineViewDateWidth);
        obj.date_y = kLTLineScrollViewHeight() - kLTLineViewDateMarginBottom - kLTLineViewDateHeight;
        obj.realline_x = obj.date_x;
        if (self.maxWeight-self.minWeight==0) {
            obj.realline_y = 0;
        } else {
            obj.realline_y = ((self.maxWeight-obj.weight) * (kLTLineScrollViewHeight()- kLTLineViewDateMarginBottom - kLTLineViewDateHeight) / (self.maxWeight-self.minWeight));
        }
    }];
}

- (void)setupDashlinePoints {
    CGFloat initial_x = kScreenWidth/2.0;
    [self.dashWeights enumerateObjectsUsingBlock:^(LTLinePoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.dashline_x = initial_x + idx * (kLTLineViewDateSpace + kLTLineViewDateWidth);
        if (self.maxWeight-self.minWeight==0) {
            obj.dashline_y = 0;
        } else {
            obj.dashline_y = ((self.maxWeight-obj.weight) * (kLTLineScrollViewHeight()- kLTLineViewDateMarginBottom - kLTLineViewDateHeight) / (self.maxWeight-self.minWeight));
        }
    }];
}



@end
