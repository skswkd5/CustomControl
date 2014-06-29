//
//  BarChartGrid.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 25..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BarChartGrid.h"

@implementation BarChartGrid


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializingValues];
    }
    return self;
}

- (void)initializingValues
{
    canvasHeight = self.bounds.size.height;
    canvasWidth = self.bounds.size.width;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //선에 대한 속성 설정
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    //시작점 설정
    originX = self.bounds.origin.x;
    originY = self.bounds.origin.y;
    endX = self.bounds.size.width;
    endY = self.bounds.size.height;
    
    //y축
    CGContextMoveToPoint(context, originX, originY);
    CGContextAddLineToPoint(context, originX, endY);

    //X축
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);;
    
    [self drawYGridLine];
    [self drawXGridLine];
    
    //점선그리기
    //    CGFloat dash1[] = {1.0, 1.0, 3.0};
    //    CGContextSetLineDash(context, 0, dash1, 3);
    
}

- (void)drawXGridLine
{
    //그리드 X축 그리드 라인 그리기
    CGFloat xwidth = endX/self.CountBars;
    for(int i = 1; i<= self.CountBars; i++)
    {
        CGFloat x1 = originX + (xwidth * i);
        CGFloat y1 = originY;
        
        CGFloat x2 = x1;
        CGFloat y2 = endY;
        
        if(self.xGridHidden == NO)
        {
            CGContextRef cntxtX = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(cntxtX, [UIColor grayColor].CGColor);
            CGContextSetLineWidth(cntxtX, 1.0f);
            CGContextMoveToPoint(cntxtX, x1, y1);
            CGContextAddLineToPoint(cntxtX, x2, y2);
            CGContextStrokePath(cntxtX);
        }
    }
}

- (void)drawYGridLine
{
    if(self.yGridHidden == NO)
    {
        //그리드 Y축 그리드 라인 그리기
        CGFloat yheight = round(endY/5);
        for (int i = 0; i < 5; i++)
        {
            CGFloat x1 = originX ;
            CGFloat y1 = originY + (yheight * i);
            if(i == 0)
            {
                y1 = originY;
            }
            
            CGFloat x2 = endX;
            CGFloat y2 = y1;
            
            CGContextRef cntxtY = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(cntxtY, [UIColor grayColor].CGColor);
            CGContextSetLineWidth(cntxtY, 1.0f);
            
            CGContextMoveToPoint(cntxtY, x1, y1);
            CGContextAddLineToPoint(cntxtY, x2, y2);
            CGContextStrokePath(cntxtY);
        }
    }
}


@end
