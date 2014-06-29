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
    
    //시작점
    CGFloat originX;
    CGFloat originY;
   
    //끝점
    CGFloat endX;
    CGFloat endY;
}

@property (assign, nonatomic) BOOL xGridHidden;
@property (assign, nonatomic) BOOL yGridHidden;

@property (assign, nonatomic) UIColor *CanvasColor;

@property (assign, nonatomic) NSInteger CountBars;

@end
