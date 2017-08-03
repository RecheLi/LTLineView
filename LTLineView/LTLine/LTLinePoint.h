//
//  LTLinePoint.h
//  LTLineView
//
//  Created by liht on 2017/7/19.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJExtension.h"
#import "CALayer+Extension.h"
#import "UIView+Extension.h"

#ifndef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef kScreenHeight
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height
#endif

static CGFloat const kLTLineViewHeight = 287.5;
static CGFloat const kLTLineViewWeightButtonHeight = 28.0;
static CGFloat const kLTLineViewDateViewHeight = 38.0;
static CGFloat const kLTLineViewDateSpace = 12.0;
static CGFloat const kLTLineViewDateHeight = 14.0;
static CGFloat const kLTLineViewDateMarginBottom = 16.0;
static CGFloat const kLTLineViewDateWidth = 40.0;
static CGFloat const kLTLineViewTopMargin = 34.0;
static CGFloat const kLTLineViewReallinePointWidth = 8.0;
static CGFloat const kLTLineViewDashlinePointWidth = 6.0;
static CGFloat const kLTLineViewMarkPointWidth = 16.0;
static inline CGFloat kLTLineScrollViewHeight() {
    return (kLTLineViewHeight*kScreenWidth/375.0) - kLTLineViewTopMargin;
}

static inline UIColor *kLTLineViewMainColor() {
    return [UIColor colorWithRed:24/255.0 green:196/255.0 blue:124/255.0 alpha:1];
}
static inline UIColor *kLTLineViewDashColor() {
    return [UIColor colorWithRed:66/255.0 green:127/255.0 blue:197/255.0 alpha:1];
}
static inline UIColor *kLTLineViewDateColor() {
    return [UIColor colorWithRed:99/255.0 green:210/255.0 blue:203/255.0 alpha:0.5];
}

@interface LTLinePoint : NSObject

@property (assign, nonatomic, readonly) CGFloat realline_x;

@property (assign, nonatomic, readonly) CGFloat realline_y;

@property (assign, nonatomic, readonly) CGFloat dashline_x;

@property (assign, nonatomic, readonly) CGFloat dashline_y;

@property (assign, nonatomic, readonly) CGFloat date_x;

@property (assign, nonatomic, readonly) CGFloat date_y;

@property (assign, nonatomic) CGFloat weight;

@property (copy, nonatomic) NSString *date;

@end

@interface LTLineData : NSObject

@property (strong, nonatomic) NSMutableArray <LTLinePoint *>*realWeights;

@property (strong, nonatomic) NSMutableArray <LTLinePoint *>*dashWeights;

@property (assign, nonatomic) CGFloat minWeight;

@property (assign, nonatomic) CGFloat maxWeight;

- (void)setupReallinePoints;

- (void)setupDashlinePoints;

@end
