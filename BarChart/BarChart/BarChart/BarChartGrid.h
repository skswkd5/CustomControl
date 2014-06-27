//
//  BarChartGrid.h
//  BarChart
//
//  Created by 김지선 on 2014. 6. 25..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarChartGrid : UIView
{
    CGFloat canvasWidth;
    CGFloat canvasHeight;
    NSMutableArray *arrRectForBars;
    
}

@property (assign, nonatomic) BOOL gridHidden;
@property (assign, nonatomic) UIColor *CanvasColor;

@property (assign, nonatomic) NSInteger CountBars;

- (void)drawCharBars;
@end
