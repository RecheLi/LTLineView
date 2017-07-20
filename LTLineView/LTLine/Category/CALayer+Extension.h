//
//  CALayer+Extension.h
//  LTLineView
//
//  Created by liht on 2017/7/19.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Extension)


@property (nonatomic) CGFloat left;        

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGPoint center;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic, getter=frameSize, setter=setFrameSize:) CGSize size;

@end
