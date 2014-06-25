//
//  BarChart.h
//  BarChart
//
//  Created by 김지선 on 2014. 6. 25..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BarChartBar;
@class BarChartGrid;

@interface BarChart : UIView
{
    BarChartGrid *bcGrid;
}

@property (assign, nonatomic) NSInteger yTitleWidth;
@property (assign, nonatomic) NSInteger xTitleHeight;
@property (assign, nonatomic) NSInteger yLabelWidth;
@property (assign, nonatomic) NSInteger XLabelHeight;

@end
