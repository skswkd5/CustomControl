//
//  BCDataHelper.m
//  BarChart
//
//  Created by Jeesun Kim on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BCCoreData.h"
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

@end
