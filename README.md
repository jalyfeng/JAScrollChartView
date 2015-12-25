# JAScrollChartView



![](https://avatars1.githubusercontent.com/u/4318332?v=3&s=460)

![](https://img.shields.io/github/stars/jaly19870729/JAScrollChartView.svg) ![](https://img.shields.io/github/forks/jaly19870729/JAScrollChartView.svg) ![](https://img.shields.io/github/tag/jaly19870729/JAScrollChartView.svg) ![](https://img.shields.io/github/release/jaly19870729/JAScrollChartView.svg) ![](https://img.shields.io/github/issues/jaly19870729/JAScrollChartView.svg)
### 主要特性
####截图

![](https://raw.githubusercontent.com/jaly19870729/JAScrollChartView/master/Screenshot/screenshot.gif)

- 使用如下


[CocoaPods](http://cocoapods.org) is the recommended way to add JAScrollChartView to your project.

1. Add a pod entry for JAScrollChartView to your Podfile `pod "JAScrollChartView" , :git => 'https://github.com/jaly19870729/JAScrollChartView.git'`
2. Install the pod(s) by running `pod install`.
3. Include JAScrollChartView wherever you need it with `#import "JAScrollChartView.h"`.

```objc
/**
*  x轴边距,默认40
*/
@property(assign,nonatomic) CGFloat xAxisMargin;
/**
*  y轴边距,默认40
*/
@property(assign,nonatomic) CGFloat yAxisMargin;
/**
*  Y轴分割数,默认6
*/
@property(assign,nonatomic) NSInteger yAxisCount;
/**
*  y轴最大值,默认200
*/
@property(assign,nonatomic) CGFloat yAxisMaxValue;

/**
*  xy轴线的颜色,默认redColor
*/
@property(strong,nonatomic) UIColor *xyAxisLineColor;
/**
*  线的颜色,默认redColor
*/
@property(strong,nonatomic) UIColor *dataLineColor;
/**
*  拐点颜色,默认greenColor
*/
@property(strong,nonatomic) UIColor *dataPointColor;
/**
*  拐点选中颜色,默认yellowColor
*/
@property(strong,nonatomic) UIColor *dataSelectedColor;

```


```objc

self.chartView = [[JAScrollChartView alloc] initWithFrame:CGRectMake(0, 280, 320, 200)];
self.chartView.delegate = self;
self.chartView.backgroundColor = [UIColor lightGrayColor];
[self.view addSubview:self.chartView];


NSMutableArray* data = [NSMutableArray new];
for (int i = 0; i < 6; i++) {
JAChartData* unitData = [JAChartData new];
unitData.value = arc4random() % 200;
unitData.lableTitle = [NSString stringWithFormat:@"day %d", (int)i];
[data addObject:unitData];
}
[self.chartView addChartData:data];

```

