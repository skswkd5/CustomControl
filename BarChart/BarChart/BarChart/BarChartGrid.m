//
//  BarChartGrid.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 25..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BarChartGrid.h"
#import "BarChartBar.h"

static const CGFloat kDefaultTopSpace = 10;
static const CGFloat kDefaultRightSpace = 10;

@implementation BarChartGrid


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializingValues];
    }
    return self;
}

- (void)initializingValues
{
    canvasHeight = self.bounds.size.height - kDefaultTopSpace;
    canvasWidth = self.bounds.size.width - kDefaultRightSpace;
    
    arrRectForBars = [[NSMutableArray alloc] init];
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"bounds: %@", NSStringFromCGRect(self.bounds));
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //선에 대한 속성 설정
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    //시작점 설정
    CGFloat originX = self.bounds.origin.x;
    CGFloat originY = self.bounds.origin.y  + kDefaultTopSpace;
    CGFloat endX = self.bounds.size.width - kDefaultRightSpace;
    CGFloat endY = self.bounds.size.height;
    
    //y축
    CGContextMoveToPoint(context, originX, originY);
    CGContextAddLineToPoint(context, originX, endY);

    //X축
    CGContextAddLineToPoint(context, endX, endY);
    CGContextStrokePath(context);
    CGContextClosePath(context);
    
    //그리드 Y축 라인 그리기
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
        
        NSLog(@"(x1, y1: %f, %f) (x2, y2: %f, %f)", x1, y1, x2, y2);
        
        CGContextRef cntxtY = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(cntxtY, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(cntxtY, 1.0f);

        CGContextMoveToPoint(cntxtY, x1, y1);
        CGContextAddLineToPoint(cntxtY, x2, y2);
        CGContextStrokePath(cntxtY);
        CGContextClosePath(cntxtY);
    }

    //그리드 X축 그리기
    CGFloat xwidth = endX/self.CountBars;
    for(int i = 1; i<= self.CountBars; i++)
    {
        CGFloat x1 = originX + (xwidth * i);
        CGFloat y1 = originY;
        
        CGFloat x2 = x1;
        CGFloat y2 = endY;
        
        CGContextRef cntxtX = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(cntxtX, [UIColor grayColor].CGColor);
        CGContextSetLineWidth(cntxtX, 1.0f);
        CGContextMoveToPoint(cntxtX, x1, y1);
        CGContextAddLineToPoint(cntxtX, x2, y2);
        CGContextStrokePath(cntxtX);
        CGContextClosePath(cntxtX);
        
        CGRect rect = CGRectMake(x1 -xwidth, y1, xwidth, canvasHeight);
        [arrRectForBars addObject:[NSValue valueWithCGRect:rect]];
        
    }
    
    [self drawCharBars];

}

- (void)drawCharBars
{
    //bar 그리기
    if(arrRectForBars.count > 0)
    {
        for(int i = 0; i < arrRectForBars.count; i++)
        {
            CGRect rect = [[arrRectForBars objectAtIndex:i] CGRectValue];
            CGFloat width = rect.size.width;
            
            CGFloat barWidth = round(width/2);
            CGFloat barX = round(barWidth/2);
            rect.origin.x += barX;
            rect.size.width = barWidth;
            
            rect.size.height = round(arc4random() % 230);
            rect.origin.y += (canvasHeight - rect.size.height);
            
            
            NSLog(@"bar Rect: %@", NSStringFromCGRect(rect));
            
            BarChartBar *chartBar = [[BarChartBar alloc] initWithFrame:rect];
            [self addSubview:chartBar];
            
        }
    }
    
    //점선그리기
    //    CGFloat dash1[] = {1.0, 1.0, 3.0};
    //    CGContextSetLineDash(context, 0, dash1, 3);
    
}
- (UIColor *)getRandomColor
{
    NSInteger red = arc4random()%255;
    NSInteger green = arc4random()%255;
    NSInteger blue = arc4random()%255;
    
    UIColor *randColor = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
    
    return randColor;
}

@end
