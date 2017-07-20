//
//  LTLine.m
//  LTLineView
//
//  Created by liht on 2017/7/19.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import "LTLine.h"

@interface LTLine () <UIScrollViewDelegate>

@property (weak, nonatomic) UIButton *titleButton;

@property (weak, nonatomic) UIButton *weightButton;

@property (weak, nonatomic) UIImageView *baseLineImageView;

@property (strong, nonatomic) CAShapeLayer *markPoint;

@property (strong, nonatomic) UIImageView *backImageView;

@property (strong, nonatomic) LTLinewScrollView *lineScollView;

@end

@implementation LTLine

#pragma mark - Getter
- (LTLinewScrollView *)lineScollView {
    if (!_lineScollView) {
        _lineScollView = [[LTLinewScrollView alloc]initWithFrame:({
            CGRect rect = {0,self.height-kLTLineScrollViewHeight(),kScreenWidth,kLTLineScrollViewHeight()};
            rect;
        })];
        _lineScollView.delegate = self;
    }
    return _lineScollView;
}

- (CAShapeLayer *)markPoint {
    if (!_markPoint) {
        _markPoint = [CAShapeLayer layer];
        _markPoint.size = CGSizeMake(kLTLineViewMarkPointWidth, kLTLineViewMarkPointWidth);
        _markPoint.backgroundColor = kLTLineViewMainColor().CGColor;
        _markPoint.cornerRadius = kLTLineViewMarkPointWidth/2.0;
        _markPoint.masksToBounds = YES;
        _markPoint.contentsScale = [UIScreen mainScreen].scale;
        CAGradientLayer *whiteDot = [CAGradientLayer layer];
        whiteDot.size = CGSizeMake(8, 8);
        whiteDot.center = _markPoint.center;
        whiteDot.backgroundColor = [UIColor whiteColor].CGColor;
        whiteDot.cornerRadius = whiteDot.height/2.0;
        whiteDot.masksToBounds = YES;
        [_markPoint addSublayer:whiteDot];
    }
    return _markPoint;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
    }
    return _backImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
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
    [self setupSubview];
}

- (void)setupSubview {
    // 背景图
    [self addSubview:self.backImageView];
    
    // 曲线滚动图
    [self addSubview:self.lineScollView];
    
    // 体重值
    UIButton *weightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weightButton.origin = CGPointMake(0, kLTLineViewTopMargin);
    weightButton.size = CGSizeMake(70, kLTLineViewWeightButtonHeight);
    weightButton.userInteractionEnabled = NO;
    weightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    weightButton.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    [weightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weightButton setBackgroundImage:[UIImage imageNamed:@"数值背景"] forState:UIControlStateNormal];
    [self addSubview:weightButton];
    self.weightButton = weightButton;
    _weightButton.centerX = kScreenWidth/2.0;
    
    // 基准线背景
    UIImageView *baselineView = [UIImageView new];
    baselineView.origin = CGPointMake(0, _weightButton.bottom);
    baselineView.size = CGSizeMake(4, self.height-_weightButton.bottom-kLTLineViewDateViewHeight);
    baselineView.image = [UIImage imageNamed:@"选中-线"];
    [self addSubview:baselineView];
    self.baseLineImageView = baselineView;
    _baseLineImageView.centerX = _weightButton.centerX;
    
    // 预测减重线标题
    CGFloat paddingRight = 25.0, titleButtonWidth = 91.0, titleButtonHeight = 16.5;
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.size = CGSizeMake(titleButtonWidth, titleButtonHeight);
    titleButton.origin = CGPointMake(kScreenWidth-titleButton.width-paddingRight, 0);
    titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [titleButton setImage:[UIImage imageNamed:@"预测减重线"] forState:UIControlStateNormal];
    [titleButton setTitle:@"预测减重线" forState:UIControlStateNormal];
    [titleButton setTitleColor:_dashlineColor forState:UIControlStateNormal];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [self addSubview:titleButton];
    self.titleButton = titleButton;
    _titleButton.centerY = _weightButton.centerY;
    
    // 标记点
    [self.layer addSublayer:self.markPoint];
    _markPoint.centerX = _weightButton.centerX;
    _markPoint.centerY = _baseLineImageView.centerY;
}

- (void)layoutMarkPoint:(LTLinePoint *)point {
    _markPoint.hidden = point.weight == 0.0 ? YES : NO;
    NSLog(@"point y %f",point.realline_y);
    _markPoint.centerY = self.height-kLTLineScrollViewHeight() + point.realline_y;
}

#pragma mark - Setter
- (void)setRealPoints:(NSMutableArray<LTLinePoint *> *)realPoints {
    _realPoints = realPoints;
    NSAssert(self.realPoints.count>0, @"self.realPoints.count need > 0");
    LTLinePoint *point = [_realPoints firstObject];
    [self layoutMarkPoint:point];
    [_weightButton setTitle:[NSString stringWithFormat:@"%.1fkg",point.weight] forState:UIControlStateNormal];
    _lineScollView.contentSize = CGSizeMake((kLTLineViewDateSpace+kLTLineViewDateWidth)*(_realPoints.count-1)+kScreenWidth, 0);
    _lineScollView.lineView.width = _lineScollView.contentSize.width;
    _lineScollView.lineView.realPoints = _realPoints;
}

- (void)setDashPoints:(NSMutableArray<LTLinePoint *> *)dashPoints {
    _dashPoints = dashPoints;
    _lineScollView.contentSize = CGSizeMake((kLTLineViewDateSpace+kLTLineViewDateWidth)*(_dashPoints.count-1)+kScreenWidth, 0);
    _lineScollView.lineView.width = _lineScollView.contentSize.width;
    _lineScollView.lineView.dashPoints = _dashPoints;
}

- (void)setDateFont:(UIFont *)dateFont {
    _dateFont = dateFont;
    _lineScollView.lineView.dateFont = _dateFont;
}

- (void)setDateColor:(UIColor *)dateColor {
    _dateColor = dateColor;
    _lineScollView.lineView.dateColor = _dateColor;
}

- (void)setReallineColor:(UIColor *)reallineColor {
    _reallineColor = reallineColor;
    _lineScollView.lineView.reallineColor = _reallineColor;
}

- (void)setDashlineWidth:(CGFloat)dashlineWidth {
    _dashlineWidth = dashlineWidth;
    _lineScollView.lineView.dashlineWidth = _dashlineWidth;
}

- (void)setReallineWidth:(CGFloat)reallineWidth {
    _reallineWidth = reallineWidth;
    _lineScollView.lineView.reallineWidth = _reallineWidth;
}

- (void)setRealPointColor:(UIColor *)realPointColor {
    _realPointColor = realPointColor;
    _lineScollView.lineView.realPointColor = _realPointColor;
}

- (void)setDashlineColor:(UIColor *)dashlineColor {
    _dashlineColor = dashlineColor;
    _lineScollView.lineView.dashlineColor = _dashlineColor;
}

- (void)setDashPointColor:(UIColor *)dashPointColor {
    _dashPointColor = dashPointColor;
    _lineScollView.lineView.dashPointColor = _dashPointColor;
}

- (void)setHideDashLine:(BOOL)hideDashLine {
    _hideDashLine = hideDashLine;
    _titleButton.hidden = _hideDashLine;
    _lineScollView.lineView.hideDashLine = _hideDashLine;
}

- (void)setPredictedWeightFont:(UIFont *)predictedWeightFont {
    _predictedWeightFont = predictedWeightFont;
    _lineScollView.lineView.predictedWeightFont = _predictedWeightFont;
}

- (void)setPredictedWeightColor:(UIColor *)predictedWeightColor {
    _predictedWeightColor = predictedWeightColor;
    _lineScollView.lineView.predictedWeightColor = _predictedWeightColor;
}

- (void)setBackImageName:(NSString *)backImageName {
    _backImageName = backImageName;
    [_backImageView setImage:[UIImage imageNamed:_backImageName]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // scroll自定义page回弹size
    CGFloat kMaxIndex = (self.lineScollView.contentSize.width-kScreenWidth)/(kLTLineViewDateSpace+kLTLineViewDateWidth);
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * (kLTLineViewDateSpace+kLTLineViewDateWidth);
    CGFloat targetIndex = round(targetX / (kLTLineViewDateSpace+kLTLineViewDateWidth));
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    targetContentOffset->x = targetIndex * (kLTLineViewDateSpace+kLTLineViewDateWidth);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger targetIndex = round(scrollView.contentOffset.x / (kLTLineViewDateSpace+kLTLineViewDateWidth));
    NSAssert(self.realPoints.count>targetIndex, @"out of realpoints bounds");
    LTLinePoint *point = self.realPoints[targetIndex];
    NSString *weightButtonTitle = point.weight == 0.0 ? @"No Data" : [NSString stringWithFormat:@"%.1fkg",point.weight] ;
    [self layoutMarkPoint:point];
    [_weightButton setTitle:weightButtonTitle forState:UIControlStateNormal];
}



@end
