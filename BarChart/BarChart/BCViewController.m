//
//  BCViewController.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BCViewController.h"

@interface BCViewController ()

@end

@implementation BCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initializeCoreData];
    [self setBarChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setBarChart
- (void)setBarChart
{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    barChart = [[BarChart alloc] initWithFrame:rect];
    barChart.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:barChart];
}

#pragma mark - initializing CoreData
- (void)initializeCoreData
{
    dataHelper = [[BCDataHelper alloc] init];
    [dataHelper initializeChartData];
}
@end
