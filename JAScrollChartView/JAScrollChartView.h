//
//  JAScrollChartView.h
//  可滚动图表
//
//  Created by jalyfeng@gmail.com on 15/12/23.
//  Copyright © 2015年 jalyfeng@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JAChartData.h"

@class JAScrollChartView;
@class JAChartData;

@protocol JAScrollChartViewPointDelegate <NSObject>

- (void)chartView:(JAScrollChartView*)chartView didSelectedWithValue:(JAChartData *)value;

@end

@interface JAScrollChartView : UIView
/**
 *  x轴边距,默认40
 */
@property(assign,nonatomic) CGFloat xAxisMargin;
/**
 *  y轴边距
 */
@property(assign,nonatomic) CGFloat yAxisMargin;
/**
 *  Y轴分割数
 */
@property(assign,nonatomic) NSInteger yAxisCount;
/**
 *  y轴最大值
 */
@property(assign,nonatomic) CGFloat yAxisMaxValue;

/**
 *  xy轴线的颜色
 */
@property(strong,nonatomic) UIColor *xyAxisLineColor;
/**
 *  线的颜色
 */
@property(strong,nonatomic) UIColor *dataLineColor;
/**
 *  拐点颜色
 */
@property(strong,nonatomic) UIColor *dataPointColor;
/**
 *  拐点选中颜色
 */
@property(strong,nonatomic) UIColor *dataSelectedColor;

@property (strong, nonatomic) id<JAScrollChartViewPointDelegate> delegate;

- (void)addChartData:(NSArray<JAChartData*>*)data;
@end

