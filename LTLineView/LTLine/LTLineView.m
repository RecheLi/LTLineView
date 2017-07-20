//
//  LTLineView.m
//  LTLineView
//
//  Created by liht on 2017/7/19.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import "LTLineView.h"

@implementation LTLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    _hideDashLine = NO;
    _dashlineWidth = 2.0;
    _reallineWidth = 4.0;
    
    _dashlineColor = kLTLineViewDashColor();
    _predictedWeightColor = _dashlineColor;
    _predictedWeightFont = [UIFont systemFontOfSize:12];
    _dashPointColor = _dashlineColor;
    _reallineColor = kLTLineViewMainColor();
    _realPointColor = kLTLineViewMainColor();
    _dateFont = [UIFont systemFontOfSize:12];
    _dateColor = [kLTLineViewDateColor() colorWithAlphaComponent:0.5];
}

- (void)drawRect:(CGRect)rect {
    self.layer.sublayers = nil;
    if (!_hideDashLine) {
        [self drawDashPoints:rect];
    }
    [self drawRealPoints:rect];
}

- (void)drawDashPoints:(CGRect)rect {
    if (self.dashPoints.count<=0 || !self.dashPoints) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, _dashlineWidth);
    [_dashlineColor set];
    CGFloat lengths[] = {4,4};
    CGContextSetLineDash(context, 0, lengths, 2);
    LTLinePoint *firstPoint = [self.dashPoints firstObject];
    CGPoint initialPoint = CGPointMake(firstPoint.dashline_x, firstPoint.dashline_y);
    CGContextMoveToPoint(context, initialPoint.x, initialPoint.y);
    for (int i=0; i<self.dashPoints.count; i++) {
        LTLinePoint *obj = self.dashPoints[i];
        if (obj.weight == 0.0) {
            continue;
        }
        CGContextAddLineToPoint(context, obj.dashline_x, obj.dashline_y);
        CAShapeLayer *linePoint = [CAShapeLayer layer];
        linePoint.center = CGPointMake(obj.dashline_x-kLTLineViewDashlinePointWidth/2.0, obj.dashline_y-kLTLineViewDashlinePointWidth/2.0);
        linePoint.size = CGSizeMake(kLTLineViewDashlinePointWidth, kLTLineViewDashlinePointWidth);
        linePoint.backgroundColor = _dashlineColor.CGColor;
        linePoint.cornerRadius = kLTLineViewDashlinePointWidth/2.0;
        linePoint.masksToBounds = YES;
        linePoint.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:linePoint];
        
        // 预测减重值
        NSString *predictedWeight = [NSString stringWithFormat:@"%.1f",obj.weight];
        CGSize weightSize = [predictedWeight sizeWithAttributes:@{NSFontAttributeName: _predictedWeightFont}];
        CATextLayer *weightLayer = [CATextLayer layer];
        weightLayer.size = CGSizeMake(weightSize.width, weightSize.height);
        weightLayer.center = CGPointMake(obj.dashline_x, obj.dashline_y-(weightSize.height+kLTLineViewDashlinePointWidth)/2.0);
        weightLayer.alignmentMode = kCAAlignmentCenter;
        weightLayer.font = (__bridge CFTypeRef)(_predictedWeightFont);
        weightLayer.fontSize = _predictedWeightFont.pointSize;
        weightLayer.foregroundColor = _predictedWeightColor.CGColor;
        weightLayer.contentsScale = [UIScreen mainScreen].scale;
        weightLayer.string = predictedWeight;
        [self.layer addSublayer:weightLayer];
    }
    CGContextStrokePath(context);
}

- (void)drawRealPoints:(CGRect)rect {
    if (self.realPoints.count<=0 || !self.realPoints) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!_hideDashLine) {CGContextRestoreGState(context);}
    CGContextSetLineWidth(context, _reallineWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    [_reallineColor set];
    LTLinePoint *firstPoint = [self.realPoints firstObject];
    CGPoint initialPoint = CGPointMake(firstPoint.realline_x, firstPoint.realline_y);
    CGContextMoveToPoint(context, initialPoint.x, initialPoint.y);
    for (int i=0; i<self.realPoints.count; i++) {
        LTLinePoint *obj = self.realPoints[i];
        CATextLayer *dateLayer = [CATextLayer layer];
        dateLayer.size = CGSizeMake(kLTLineViewDateWidth, kLTLineViewDateHeight);
        dateLayer.center = CGPointMake(obj.date_x, obj.date_y);
        dateLayer.alignmentMode = kCAAlignmentCenter;
        dateLayer.font = (__bridge CFTypeRef)(_dateFont);
        dateLayer.fontSize = -_dateFont.pointSize;
        dateLayer.string = obj.date;
        dateLayer.foregroundColor = _dateColor.CGColor;
        dateLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:dateLayer];
        if (obj.weight == 0.0) {
            continue;
        }
        CGContextAddLineToPoint(context, obj.realline_x, obj.realline_y);
        CAShapeLayer *linePoint = [CAShapeLayer layer];
        linePoint.center = CGPointMake(obj.realline_x-kLTLineViewReallinePointWidth/2.0, obj.realline_y-kLTLineViewReallinePointWidth/2.0);
        linePoint.size = CGSizeMake(kLTLineViewReallinePointWidth, kLTLineViewReallinePointWidth);
        linePoint.backgroundColor = _realPointColor.CGColor;
        linePoint.cornerRadius = kLTLineViewReallinePointWidth/2.0;
        linePoint.masksToBounds = YES;
        linePoint.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:linePoint];
        
    }
    CGContextStrokePath(context);
}


- (void)setDateFont:(UIFont *)dateFont {
    _dateFont = dateFont;
    [self setNeedsDisplay];
}

- (void)setDateColor:(UIColor *)dateColor {
    _dateColor = dateColor;
    [self setNeedsDisplay];
}

- (void)setReallineColor:(UIColor *)reallineColor {
    _reallineColor = reallineColor;
    [self setNeedsDisplay];
}

- (void)setRealPointColor:(UIColor *)realPointColor {
    _realPointColor = realPointColor;
    [self setNeedsDisplay];
}

- (void)setDashlineColor:(UIColor *)dashlineColor {
    _dashlineColor = dashlineColor;
    [self setNeedsDisplay];
}

- (void)setDashPointColor:(UIColor *)dashPointColor {
    _dashPointColor = dashPointColor;
    [self setNeedsDisplay];
}

- (void)setPredictedWeightFont:(UIFont *)predictedWeightFont {
    _predictedWeightFont = predictedWeightFont;
    [self setNeedsDisplay];
}

- (void)setPredictedWeightColor:(UIColor *)predictedWeightColor {
    _predictedWeightColor = predictedWeightColor;
    [self setNeedsDisplay];
}

- (void)setRealPoints:(NSMutableArray<LTLinePoint *> *)realPoints {
    _realPoints = realPoints;
    [self setNeedsDisplay];
}

- (void)setDashPoints:(NSMutableArray<LTLinePoint *> *)dashPoints {
    _dashPoints = dashPoints;
    [self setNeedsDisplay];
}

- (void)setDashlineWidth:(CGFloat)dashlineWidth {
    _dashlineWidth = dashlineWidth;
    [self setNeedsDisplay];
}

- (void)setReallineWidth:(CGFloat)reallineWidth {
    _reallineWidth = reallineWidth;
    [self setNeedsDisplay];
}

- (void)setHideDashLine:(BOOL)hideDashLine {
    _hideDashLine = hideDashLine;
    [self setNeedsDisplay];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
