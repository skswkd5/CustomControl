//
//  BCViewController.h
//  BarChart
//
//  Created by 김지선 on 2014. 6. 24..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCCoreData.h"
#import "BCDataHelper.h"
#import "BCCoreDataHandler.h"

@interface BCViewController : UIViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) NSUInteger selectYear;
@property (nonatomic, strong) NSMutableArray *arraySalesCount;

@end
