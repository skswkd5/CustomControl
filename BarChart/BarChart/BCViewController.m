//
//  BCViewController.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BCViewController.h"
#import "Utility.h"

@interface BCViewController ()

@property (retain, nonatomic) NSDictionary *dicBCData;

@end

@implementation BCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //초기화 하기
	[self initializeCoreData];
    
    //데이터 가져오기
    self.dicBCData = [self getBarChartData];

    //Chart Setting
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
    CGRect main = [UIScreen mainScreen].bounds;
    CGRect rect = main;
    CGFloat statusBar = 20;
    rect.size.height = main.size.width;
    rect.size.width = main.size.height;
    rect.origin.y = statusBar;
    rect.size.height -= statusBar;
    
    barChart = [[BarChart alloc] initWithFrame:rect DataSource:self.dicBCData];
    [self.view addSubview:barChart];
}


#pragma mark - prepare data for a bar chart
- (NSDictionary *)getBarChartData
{
    NSArray *arrSales = [self getDataForThisYear];
    NSDictionary *dicData = [self setSalesData:arrSales];
    
    return dicData;
    
}

- (NSDictionary *)setSalesData:(NSArray *)arr
{
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
    
    if (arr.count > 0)
    {
        for (Sales *sales in arr)
        {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:sales.date];

            NSString *month = [NSString stringWithFormat:@"%ld", [components month]];
            if(![dicData objectForKey:month])
            {
                [dicData setObject:sales.count forKey:month];
            }
            else
            {
                NSNumber *count = [dicData objectForKey:month];
                [dicData setObject:@([count integerValue] + [sales.count integerValue]) forKey:month];
            }
        }
    }
    
    return dicData;
}

- (NSArray *)getDataForThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    [components setDay:1];
    [components setMonth:1];
    NSDate *firstDay = [calendar dateFromComponents:components];
    
    components = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    [components setDay:12];
    [components setMonth:31];
    NSDate *lastDay = [calendar dateFromComponents:components];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) and (date <= %@)", firstDay, lastDay];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *arrData = [BCDataHelper ArrayEntitiesWithClassName:ENTITY_SALES sortDescriptors:@[sort] sectionNameKeyPath:nil predicate:predicate];
    
    return arrData;
}

#pragma mark - initializing CoreData
- (void)initializeCoreData
{
    dataHelper = [[BCDataHelper alloc] init];
    [dataHelper initializeChartData];
}
@end
