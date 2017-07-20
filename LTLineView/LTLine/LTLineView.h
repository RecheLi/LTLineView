//
//  LTLineView.h
//  LTLineView
//
//  Created by liht on 2017/7/19.
//  Copyright © 2017年 linitial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTLinePoint.h"

@class LTLinewScrollView;

@interface LTLineView : UIView

@property (weak, nonatomic) LTLinewScrollView *parentScrollView;

/**虚线点的颜色
 */
@property (strong, nonatomic) UIColor *dashPointColor;

/**虚线线条颜色
 */
@property (strong, nonatomic) UIColor *dashlineColor;

/**实线线条颜色
 */
@property (strong, nonatomic) UIColor *reallineColor;

/**实线点的颜色
 */
@property (strong, nonatomic) UIColor *realPointColor;

/**日期文字颜色
 */
@property (strong, nonatomic) UIColor *dateColor;

/**日期文字字体
 */
@property (strong, nonatomic) UIFont *dateFont;

/**预测减重值文字字体
 */
@property (strong, nonatomic) UIFont *predictedWeightFont;

/**预测减重值文字字体
 */
@property (strong, nonatomic) UIColor *predictedWeightColor;

/**虚线宽度
 */
@property (assign, nonatomic) CGFloat dashlineWidth;

/**实线线宽度
 */
@property (assign, nonatomic) CGFloat reallineWidth;

/**是否隐藏虚线
 */
@property (assign, nonatomic) BOOL hideDashLine;

/**实线数据源
 */
@property (strong, nonatomic) NSMutableArray <LTLinePoint *>*realPoints;

/**虚线数据源
 */
@property (strong, nonatomic) NSMutableArray <LTLinePoint *>*dashPoints;


@end
