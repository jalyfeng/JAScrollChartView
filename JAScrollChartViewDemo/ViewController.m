//
//  ViewController.m
//  JAScrollChartViewDemo
//
//  Created by jalyfeng@gmail.com on 15/12/24.
//  Copyright © 2015年 jalyfeng@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "JAScrollChartView.h"

@interface ViewController ()<JAScrollChartViewPointDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLable;
@property(strong,nonatomic)JAScrollChartView *chartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupChart];
}

-(void)setupChart{
    self.chartView=[[JAScrollChartView alloc]initWithFrame:CGRectMake(0, 280, 320, 200)];
    self.chartView.delegate=self;
    self.chartView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.chartView];
    
}
- (IBAction)addNewData:(id)sender {
    NSMutableArray *data=[NSMutableArray new];
    NSInteger count=arc4random()%8;
    if(count<1){
        count=1;
    }
    for(int i=0;i<6;i++){
        JAChartData *unitData=[JAChartData new];
        unitData.value=arc4random()%200;
        unitData.lableTitle=[NSString stringWithFormat:@"day %d",(int)i];
        [data addObject:unitData];
    }
    [self.chartView addChartData:data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark JAScrollChartViewPointDelegate

- (void)chartView:(JAScrollChartView*)chartView didSelectedWithValue:(JAChartData *)value{
    self.resultLable.text=[NSString stringWithFormat:@"结果:%@",@(value.value)];
}

@end
