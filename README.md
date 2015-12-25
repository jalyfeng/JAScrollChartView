# JAScrollChartView



![](https://avatars1.githubusercontent.com/u/4318332?v=3&s=460)

![](https://img.shields.io/github/stars/jaly19870729/JAScrollChartView.svg) ![](https://img.shields.io/github/forks/jaly19870729/JAScrollChartView.svg) ![](https://img.shields.io/github/tag/jaly19870729/JAScrollChartView.svg) ![](https://img.shields.io/github/release/jaly19870729/JAScrollChartView.svg) ![](https://img.shields.io/github/issues/jaly19870729/JAScrollChartView.svg)
### 主要特性

- 使用如下


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