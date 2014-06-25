//
//  BCDataHelper.h
//  BarChart
//
//  Created by Jeesun Kim on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BCCoreData.h"
#import "Product.h"
#import "Sales.h"

@interface BCDataHelper : NSObject

+ (NSArray *)ArrayEntitiesWithClassName:(NSString *)className
                        sortDescriptors:(NSArray *)sortDescriptors
                     sectionNameKeyPath:(NSString *)sectionNameKeypath
                              predicate:(NSPredicate *)predicate;


+ (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                           sortDescriptors:(NSArray *)sortDescriptors
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 predicate:(NSPredicate *)predicate;


- (void)initializeChartData;

@end
