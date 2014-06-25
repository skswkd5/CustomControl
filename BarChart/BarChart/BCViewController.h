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
#import "BarChart.h"

@interface BCViewController : UIViewController
{
    BCDataHelper *dataHelper;
    BarChart *barChart;
    
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
