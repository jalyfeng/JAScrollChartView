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

@property (strong, nonatomic) id<JAScrollChartViewPointDelegate> delegate;

- (void)addChartData:(NSArray<JAChartData*>*)data;
@end

