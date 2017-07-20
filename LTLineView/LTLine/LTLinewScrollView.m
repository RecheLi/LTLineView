//
//  LTLinewScrollView.m
//  LTLineView
//
//  Created by liht on 2017/7/19.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import "LTLinewScrollView.h"

@interface LTLinewScrollView ()

@property (weak, nonatomic, readwrite) LTLineView *lineView;

@end

@implementation LTLinewScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    LTLineView *lineView = [[LTLineView alloc]initWithFrame:self.bounds];
    lineView.parentScrollView = self;
    [self addSubview:lineView];
    self.lineView = lineView;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
