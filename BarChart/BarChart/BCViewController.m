//
//  BCViewController.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BCViewController.h"

#import "Utility.h"
#import "Product.h"
#import "Sales.h"
#import "BCCoreData.h"
#import "BCDataHelper.h"

@implementation BCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setCoreData];
    [self FetchedResultSalesFromModel:@"K_K5" selectYear:2014];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DB Data Query
- (void)FetchedResultSalesFromModel:(NSString *)aModel selectYear:(NSUInteger)aSelectYear
{
    self.selectYear = aSelectYear;
//    NSDate *dateStart = [NSDate dateWithYear:aSelectYear month:1 day:1];
//    NSDate *dateEnd = [NSDate dateWithYear:aSelectYear month:12 day:31];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(product.model == %@) ", aModel];
    NSSortDescriptor *sorDesc = [NSSortDescriptor sortDescriptorWithKey:@"model" ascending:YES];
    
//    self.fetchedResultsController = [BCDataHelper fetchEntitiesWithClassName:ENTITY_SALES sortDescriptors:@[sorDesc] sectionNameKeyPath:nil predicate:predicate];
    NSArray *arr = [BCDataHelper ArrayEntitiesWithClassName:ENTITY_SALES sortDescriptors:@[sorDesc] sectionNameKeyPath:nil predicate:predicate];
    
    int i =0;
    
    for (Sales *sale in arr)
    {
        NSLog(@"%d: displayName: %@ model: %@ count: %@ date: %@", i, sale.displayName, sale.model, sale.count, sale.date);
        i++;

    }
}

- (NSArray *)getFetchedResultSalesYearCountData
{
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(int month=1; month < 13; month++)
    {
        [data addObject:[self countFromSalesMonth:month]];
    }
    return data;
}

- (NSString *)countFromSalesMonth:(NSUInteger)aMonth
{
    NSUInteger countMonthSalesMonth = 0;
//    NSDate *dateStart = [NSDate dateWithYear:self.selectYear month:aMonth day:1];
//    NSDate *dateEnd = [NSDate dateWithYear:self.selectYear month:aMonth day:31];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@""];
    
    NSArray *arraySalesMonth = [[self.fetchedResultsController fetchedObjects] filteredArrayUsingPredicate:predicate];
    
    for(Sales *sale in arraySalesMonth)
    {
        countMonthSalesMonth += [sale.count intValue];
    }
    return [NSString stringWithFormat:@"%d", countMonthSalesMonth];
}



#pragma  mark - set CoreData
- (void)setCoreData
{
    //Product
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    NSArray *products = [BCDataHelper ArrayEntitiesWithClassName:ENTITY_PRODUCT sortDescriptors:@[sortDesc] sectionNameKeyPath:nil predicate:nil];
    if([products count] == 0)
    {
        [self setProductCoreData];
    }

    //Sales
    sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sales = [BCDataHelper ArrayEntitiesWithClassName:ENTITY_SALES sortDescriptors:@[sortDesc] sectionNameKeyPath:nil predicate:nil];
    if([sales count] == 0)
    {
        [self setSalesCoreData];
    }
}

- (void)setProductCoreData
{
    NSArray *arrayProductName = @[@"K5", @"K7", @"Avante MD", @"Lay"];
    NSArray *arrayModel = @[@"K_K5", @"K_K7", @"H_A_HD", @"K_L_2011"];
    
    Product *sampleProduct = nil;
    
    for(int i=0; i < [arrayProductName count]; i++)
    {
        sampleProduct = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_PRODUCT inManagedObjectContext:[[BCCoreData sharedInstance] managedObjectContext]];
        sampleProduct.displayName = [arrayProductName objectAtIndex:i];
        sampleProduct.model = [arrayModel objectAtIndex:i];
        sampleProduct.releaseDate = [NSDate date];
    }
    
    [[BCCoreData sharedInstance] saveContext];
}

- (void)setSalesCoreData
{
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    
    NSFetchedResultsController *results = [BCDataHelper fetchEntitiesWithClassName:ENTITY_PRODUCT sortDescriptors:@[sortDesc] sectionNameKeyPath:nil predicate:predicate];
    int cnt = [[results fetchedObjects] count];
    
    if(cnt == 0)
    {
        NSLog(@"No Data in Product Entity");
        return;
    }
    
    for (Product *product in results.fetchedObjects)
    {
        NSInteger maxCount = random() % 100;
        NSLog(@"product: %@", product.displayName);
        
        for(int i = 0; i < maxCount; i++)
        {
            Sales *sales = nil;
            
            NSDate *newDate = [self returnRandumDate];
            NSInteger count = random() % 1000;
            
            NSLog(@"i: %d = count/newDate: %d/%@",i, count, newDate);
            
            sales = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SALES inManagedObjectContext:product.managedObjectContext];
            sales.date = newDate;
            sales.count = [NSNumber numberWithInteger:count ];
            [product addSalesObject:sales];
        }
        
        [product.managedObjectContext save:nil];
    }
    
    [[BCCoreData sharedInstance] saveContext];
}

- (NSDate *)returnRandumDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd"];
    
    NSDate *startDay = [formatter dateFromString:@"2014-01-01"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:startDay];
    
    int r = arc4random() % 364;
    [dateComponents setDay:r];
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    
    return newDate;
}
@end
