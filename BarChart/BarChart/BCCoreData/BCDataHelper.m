//
//  BCDataHelper.m
//  BarChart
//
//  Created by Jeesun Kim on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BCDataHelper.h"
#import "Utility.h"

@implementation BCDataHelper

+ (NSArray *)ArrayEntitiesWithClassName:(NSString *)className
                        sortDescriptors:(NSArray *)sortDescriptors
                     sectionNameKeyPath:(NSString *)sectionNameKeypath
                              predicate:(NSPredicate *)predicate
{
    //class 이름으로 데이터 찾기
    NSFetchedResultsController *resultController = [BCDataHelper fetchEntitiesWithClassName:className sortDescriptors:sortDescriptors sectionNameKeyPath:sectionNameKeypath predicate:predicate];
    return [resultController fetchedObjects];
}

+ (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                           sortDescriptors:(NSArray *)sortDescriptors
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 predicate:(NSPredicate *)predicate
{
    
    NSLog(@"\nNSFetchedResultsController Reqeust\nClassName : %@\nssortDescriptors : %@\nsectionNameKeyPath : %@\npredicate : %@",className,sortDescriptors,sectionNameKeypath,predicate);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:[[BCCoreData sharedInstance] managedObjectContext]];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    [NSFetchedResultsController deleteCacheWithName:CACHE_FILE_NAME];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:[[BCCoreData sharedInstance] managedObjectContext]
                                                                                                 sectionNameKeyPath:sectionNameKeypath
                                                                                                          cacheName:CACHE_FILE_NAME];
    
    NSError *error = nil;
    BOOL success = [fetchedResultsController performFetch:&error];
    
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"CoreData Error" message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
    }
    
    return fetchedResultsController;
}


#pragma mark - initializingChartData
- (void)initializeChartData
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
        
        for(int i = 0; i < maxCount; i++)
        {
            Sales *sales = nil;
            
            NSDate *newDate = [self returnRandomDate];
            NSInteger count = random() % 1000;
            
            sales = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_SALES inManagedObjectContext:product.managedObjectContext];
            sales.date = newDate;
            sales.count = [NSNumber numberWithInteger:count ];
            [product addSalesObject:sales];
        }
        
        [product.managedObjectContext save:nil];
    }
    
    [[BCCoreData sharedInstance] saveContext];
}

- (NSDate *)returnRandomDate
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
