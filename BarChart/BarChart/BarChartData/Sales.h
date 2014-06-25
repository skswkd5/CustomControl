//
//  Sales.h
//  BarChart
//
//  Created by Jeesun Kim on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Product.h"

@class Product;

@interface Sales : Product

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Product *product;

@end
