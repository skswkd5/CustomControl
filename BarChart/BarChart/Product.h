//
//  Product.h
//  BarChart
//
//  Created by 김지선 on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sales;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSSet *sales;
@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addSalesObject:(Sales *)value;
- (void)removeSalesObject:(Sales *)value;
- (void)addSales:(NSSet *)values;
- (void)removeSales:(NSSet *)values;

@end
