//
//  JAScrollChartView.h
//  可滚动图表
//
//  Created by jalyfeng@gmail.com on 15/12/23.
//  Copyright © 2015年 jalyfeng@gmail.com All rights reserved.
//

#import "JAScrollChartView.h"

#define YAxisTopMargin 10

static NSString * const chartCollectionIdentifier=@"chartCollectionIdentifier";

@class ChartCollectionViewCell;

@protocol ChartCollectionViewCellPointDelegate <NSObject>

-(void)chartCollectionViewCell:(ChartCollectionViewCell *)cell didSelectedPoint:(CGPoint )point value:(JAChartData *)value;

@end

@interface ChartCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic) id<ChartCollectionViewCellPointDelegate> pointDelegate;

@property(strong,nonatomic) CAShapeLayer *shapeLayer;
@property(strong,nonatomic) CAShapeLayer *pointShapeLayer;
@property(strong,nonatomic) CAShapeLayer *selectedShapeLayer;

@property(strong,nonatomic) NSArray<JAChartData *> *chartData;

@property(assign,nonatomic) CGFloat yAxisDetal;

@property(assign,nonatomic) CGFloat yAxisRate;

@property(strong,nonatomic) NSMutableArray *pathPoints;


-(void)setChartData:(NSArray *)data yAxisDetal:(CGFloat )yAxisDetal yAxisRate:(CGFloat)yAxisRate;
-(void)setSelectedPonint:(CGPoint)point;

@end


@interface JAScrollChartView()<UICollectionViewDataSource,ChartCollectionViewCellPointDelegate>
/**
 *  x轴边距
 */
@property(assign,nonatomic) CGFloat xAxisMargin;
/**
 *  y轴边距
 */
@property(assign,nonatomic) CGFloat yAxisMargin;

@property(assign,nonatomic) CGFloat xAxisLineLength;
@property(assign,nonatomic) CGFloat yAxisLineLength;

@property(assign,nonatomic) NSInteger yAxisCount;
@property(assign,nonatomic) CGFloat yAxisMaxValue;



@property(strong,nonatomic) UICollectionView *chartCollectionView;
@property(strong,nonatomic) UICollectionViewFlowLayout *chartCollectionViewLayout;

@property(strong,nonatomic) NSMutableArray *chartDataArray;

@property(strong,nonatomic) NSIndexPath *selectedIndexPath;
@property(assign,nonatomic) CGPoint selectedPoint;


@end

@implementation JAScrollChartView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setViews];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        [self setViews];
    }
    return self;
}

-(void)awakeFromNib{
    [self setViews];
}

-(void)setViews{
    
    if(!self.yAxisCount){
        self.yAxisCount=6;
    }
    if(!self.yAxisMaxValue){
        self.yAxisMaxValue=200;
    }
    if(!self.yAxisMargin){
        self.yAxisMargin=40;
    }
    if(!self.xAxisMargin){
        self.xAxisMargin=40;
    }
    if(!self.xAxisLineLength){
        self.xAxisLineLength =CGRectGetWidth(self.bounds)-self.yAxisMargin;
    }
    if(!self.yAxisLineLength){
        self.yAxisLineLength=CGRectGetHeight(self.bounds)-self.xAxisMargin;
    }
    if(!self.chartDataArray){
        self.chartDataArray=[NSMutableArray new];
    }
    self.chartCollectionViewLayout=[[UICollectionViewFlowLayout alloc]init];
    self.chartCollectionView.backgroundColor=self.backgroundColor;
    self.chartCollectionViewLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.chartCollectionView=[[UICollectionView alloc]initWithFrame:[self getCollectionViewRect] collectionViewLayout:self.chartCollectionViewLayout];
    self.chartCollectionViewLayout.itemSize=[self getCollectionViewItemSize];
    self.chartCollectionViewLayout.minimumLineSpacing=0.0f;
    //self.chartCollectionViewLayout.minimumLineSpacing=0.1;
    [self.chartCollectionView registerClass:[ChartCollectionViewCell class] forCellWithReuseIdentifier:chartCollectionIdentifier];
    
    //代理
    self.chartCollectionView.dataSource=self;
    
    [self insertSubview:self.chartCollectionView atIndex:0];
    

}

-(void)addChartData:(NSArray<JAChartData *> *)data{
    if(!data || data.count<1){
        return;
    }
    JAChartData *preFirstData=[JAChartData new];
    JAChartData *preLastData=[JAChartData new];
    NSMutableArray *newInsertData=[data mutableCopy];
    if(newInsertData.count==1){
        //补充前后数据
        preFirstData.value=0;
        preFirstData.lableTitle=@"以前";
        [newInsertData insertObject:preFirstData atIndex:0];
        
        preLastData.value=0;
        preLastData.lableTitle=@"现在";
        [newInsertData addObject:preLastData];
        
    }
    if(self.chartDataArray.count>0){
        //int arrayCount=self.chartDataArray.count;
        //上次第一条作为本次最后一条
        preFirstData=self.chartDataArray[0][1];
        //本次最后一条作为上次第一条
        preLastData=[newInsertData lastObject];
        
        
        //上个第一条作为本次最后一条
        [newInsertData addObject:preFirstData];
        JAChartData *tmppreFirstData=[JAChartData new];
        tmppreFirstData.value=0;
        tmppreFirstData.lableTitle=@"以前";
        [newInsertData insertObject:tmppreFirstData atIndex:0];
        
        //本次最后一条作为上次第一条
        self.chartDataArray[0][0]=preLastData;
        
    }else{
        //补充前后数据
        
        preFirstData.value=0;
        preFirstData.lableTitle=@"以前";
        [newInsertData insertObject:preFirstData atIndex:0];
        
        preLastData.value=0;
        preLastData.lableTitle=@"现在";
        [newInsertData addObject:preLastData];
    }
    if(self.selectedIndexPath){
        self.selectedIndexPath=[NSIndexPath indexPathForRow:self.selectedIndexPath.row+1 inSection:0];
    }
    [self.chartDataArray insertObject:newInsertData atIndex:0];
    if(self.chartDataArray.count==1){
        [self.chartCollectionView reloadData];
    }else{
        [self.chartCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    }
    
    
}


-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    if(self.chartCollectionView){
        self.chartCollectionView.backgroundColor=[UIColor clearColor];
    }
}

-(CGSize)getCollectionViewItemSize{
    CGRect frame=self.bounds;
    //去掉 ymargin
    return  CGSizeMake(CGRectGetWidth(frame)-self.yAxisMargin, CGRectGetHeight(frame));
}

-(CGRect)getCollectionViewRect{
    CGRect frame=self.bounds;
    //去掉 ymargin
    return  CGRectMake(self.yAxisMargin, 0, CGRectGetWidth(frame)-self.yAxisMargin, CGRectGetHeight(frame));
}


-(void)drawRect:(CGRect)rect{
    //画y轴
    UIBezierPath *xyPath=[UIBezierPath bezierPath];
    [xyPath moveToPoint:CGPointMake(self.yAxisMargin, 0)];
    [xyPath addLineToPoint:CGPointMake(self.yAxisMargin, self.yAxisLineLength)];
    [xyPath addLineToPoint:CGPointMake(self.xAxisLineLength + self.yAxisMargin, self.yAxisLineLength)];
    CAShapeLayer *xyLayer=[CAShapeLayer new];
    
    
    [self.layer addSublayer:xyLayer];
    
    xyLayer.path=xyPath.CGPath;
    xyLayer.fillColor=[UIColor clearColor].CGColor;
    xyLayer.strokeColor=[UIColor redColor].CGColor;
    xyPath.lineWidth=2;
    
    [self setupYAxisLabel];
    
    
}

-(CGFloat)getYOffset{
    return (self.yAxisLineLength-YAxisTopMargin)/self.yAxisCount;
}

-(CGFloat)getYUnit{
    return self.yAxisMaxValue/(self.yAxisCount-1);
}


-(void)setupYAxisLabel{
    CAShapeLayer *xyLayer=[CAShapeLayer new];
    
    //画标尺
    UIBezierPath *xyPath=[UIBezierPath bezierPath];
    if(self.yAxisCount){
        CGFloat yOffset=[self getYOffset];
        CGFloat yAxisDetail=[self getYUnit];
        [xyPath moveToPoint:CGPointMake(self.yAxisMargin, self.yAxisLineLength-yOffset)];
        for(int i=0 ;i<self.yAxisCount;i++){
            CGFloat xPoint=self.yAxisMargin;
            CGFloat yPoint=self.yAxisLineLength- (i+1) * yOffset;
            [xyPath moveToPoint:CGPointMake(xPoint, yPoint)];
            [xyPath addLineToPoint:CGPointMake(xPoint+self.xAxisLineLength, yPoint)];
            UILabel *yLabel=[UILabel new];
            yLabel.font=[UIFont systemFontOfSize:12];
            yLabel.textAlignment=NSTextAlignmentRight;
            yLabel.text=[NSString stringWithFormat:@"%.0f",yAxisDetail * i];
            yLabel.frame=CGRectMake(xPoint-32, yPoint - (yOffset-10)/2, 30, yOffset-10);
            
            [self addSubview:yLabel];
        }
    }
    xyLayer.path=xyPath.CGPath;
    xyLayer.fillColor=[UIColor clearColor].CGColor;
    xyLayer.strokeColor=[UIColor colorWithWhite:0.800 alpha:1.000].CGColor;

    xyPath.lineWidth=2;
    [self.layer addSublayer:xyLayer];
    
}


#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.chartDataArray){
        return self.chartDataArray.count;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChartCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:chartCollectionIdentifier forIndexPath:indexPath];
    cell.pointDelegate=self;
    cell.backgroundColor=[UIColor clearColor];
    [cell setChartData:self.chartDataArray[indexPath.row] yAxisDetal:[self getYOffset]+self.xAxisMargin yAxisRate:[self getYOffset]/[self getYUnit]];
    if(self.selectedIndexPath && self.selectedIndexPath.row==indexPath.row){
        [cell setSelectedPonint:self.selectedPoint];
    }
    return cell;
}

#pragma mark -
#pragma mark ChartCollectionViewCellPointDelegate
-(void)chartCollectionViewCell:(ChartCollectionViewCell *)cell didSelectedPoint:(CGPoint )point value:(id)value{
    if(self.selectedIndexPath){
        //清除
        ChartCollectionViewCell *oldCell=(ChartCollectionViewCell *)[self.chartCollectionView cellForItemAtIndexPath:self.selectedIndexPath];
        [oldCell setChartData:self.chartDataArray[self.selectedIndexPath.row] yAxisDetal:[self getYOffset]+self.xAxisMargin yAxisRate:[self getYOffset]/[self getYUnit]];
    }
    self.selectedIndexPath=[self.chartCollectionView indexPathForCell:cell];
    self.selectedPoint=point;
    
    //回调外部
    if(self.delegate && [self.delegate respondsToSelector:@selector(chartView:didSelectedWithValue:)]){
        [self.delegate chartView:self didSelectedWithValue:value];
    }
}


@end

@implementation ChartCollectionViewCell{
    BOOL addNotificationed;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        
    }
    return self;
}

-(void)setChartData:(NSArray<JAChartData*> *)data yAxisDetal:(CGFloat )yAxisDetal yAxisRate:(CGFloat)yAxisRate{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if(!self.pathPoints){
        self.pathPoints=[NSMutableArray new];
    }
    [self.pathPoints removeAllObjects];
    
    self.chartData=data;
    self.yAxisDetal=yAxisDetal;
    self.yAxisRate=yAxisRate;
    [self setupChartData];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(CGFloat)getXOffset{
    CGFloat width=CGRectGetWidth(self.bounds);
    return  width/(self.chartData.count-2);
}

-(void)setupChartData{
    if([_selectedShapeLayer superlayer]){
        [_selectedShapeLayer removeFromSuperlayer];
    }
    //计算x轴位移
    CGFloat xOffset=[self getXOffset];
    CGFloat height=CGRectGetHeight(self.bounds)-self.yAxisDetal;
    //划线
    UIBezierPath *path=[UIBezierPath bezierPath];
    UIBezierPath *pointPath=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(- xOffset * 0.5, height - self.chartData[0].value * self.yAxisRate )];
    [pointPath moveToPoint:CGPointMake(xOffset * 0.5, height - self.chartData[0].value * self.yAxisRate )];
    for(int i=0;i<self.chartData.count;i++){
        
        JAChartData *chartData=self.chartData[i];
        CGFloat xPoint=(i-0.5) * xOffset;
        CGFloat yPoint=height - self.chartData[i].value * self.yAxisRate ;
        [_pathPoints addObject:[NSValue valueWithCGPoint:CGPointMake(xPoint, yPoint)]];
        
        if([chartData.lableTitle isEqualToString:@"以前"]){
            [path moveToPoint:CGPointMake(xOffset * 0.5, height - self.chartData[i+1].value * self.yAxisRate )];
            [pointPath moveToPoint:CGPointMake(xOffset * 0.5, height - self.chartData[i+1].value * self.yAxisRate )];
            [self drawText:@"" atPoint:CGPointMake(xPoint, yPoint)];
            continue;
        }
        if([chartData.lableTitle isEqualToString:@"现在"]){
            [self drawText:@"" atPoint:CGPointMake(xPoint, yPoint)];
            continue;
        }
        
        
        [path addLineToPoint:CGPointMake(xPoint, yPoint)];
        UIBezierPath *circlePath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(xPoint, yPoint) radius:2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [pointPath appendPath:circlePath];
        
        if(i==0){
            continue;
        }
        [self drawText:self.chartData[i].lableTitle atPoint:CGPointMake(xPoint, yPoint)];
    }
    _shapeLayer.path=path.CGPath;
    _pointShapeLayer.path=pointPath.CGPath;
    
}

-(void)drawText:(NSString *)text atPoint:(CGPoint)point{
    CGFloat height=CGRectGetHeight(self.frame);
    CATextLayer *textLayer=[CATextLayer layer];
    textLayer.fontSize=10;
    textLayer.string=text;
    textLayer.frame=CGRectMake(point.x-15, height-20, 30, 10);
    [self.layer addSublayer:textLayer];
}

-(void)drawRect:(CGRect)rect{
    [self fillLine];
}
-(void)fillLine{
    if(!_shapeLayer){
        _shapeLayer=[CAShapeLayer layer];
        _shapeLayer.frame=self.bounds;
        _shapeLayer.strokeColor=[UIColor redColor].CGColor;
        _shapeLayer.fillColor=[UIColor clearColor].CGColor;
        _shapeLayer.lineWidth=1.0f;
        
        [self.layer addSublayer:_shapeLayer];
    }
    if(!_pointShapeLayer){
        _pointShapeLayer=[CAShapeLayer layer];
        _pointShapeLayer.frame=self.bounds;
        _pointShapeLayer.strokeColor=[UIColor greenColor].CGColor;
        _pointShapeLayer.fillColor=[UIColor clearColor].CGColor;
        _pointShapeLayer.lineWidth=4.0f;
        
        [self.layer addSublayer:_pointShapeLayer];
    }
    if(!_selectedShapeLayer){
        _selectedShapeLayer=[CAShapeLayer layer];
        _selectedShapeLayer.strokeColor=[UIColor yellowColor].CGColor;
        _selectedShapeLayer.fillColor=[UIColor clearColor].CGColor;
        _selectedShapeLayer.lineWidth=10.0f;
    }
    
    [self setupChartData];
    
}

//touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self touchKeyPoint:touches withEvent:event];
}


- (void)touchKeyPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    for (int i = 0; i < (int)_pathPoints.count; i += 1) {
        CGPoint p1 = [_pathPoints[i] CGPointValue];
        float distanceToP1 = fabs(hypot(touchPoint.x - p1.x, touchPoint.y - p1.y));
        if (distanceToP1 <= 20.0) {
            JAChartData *selectedData=self.chartData[i];
            NSLog(@"oooclick0000  index: %@ point ,y:%@",@(i+1),@(selectedData.value));
            if(self.pointDelegate && [self.pointDelegate respondsToSelector:@selector(chartCollectionViewCell:didSelectedPoint:value:)]){
                NSLog(@"didselected.................");
                [self.pointDelegate chartCollectionViewCell:self didSelectedPoint:p1 value:selectedData];
            }
            [self setSelectedPonint:p1];
            return;
        }
    }
}


-(void)setSelectedPonint:(CGPoint)point{
    if(![_selectedShapeLayer superlayer]){
        [self.layer addSublayer:_selectedShapeLayer];
    }
    UIBezierPath *circlePath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(point.x, point.y) radius:5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    _selectedShapeLayer.path=circlePath.CGPath;
}
@end






