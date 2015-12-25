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

