//
//  BarChartGrid.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 25..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BarChartGrid.h"

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
    canvasHeight = self.bounds.size.width - kDefaultTopSpace;
    canvasWidth = self.bounds.size.height - kDefaultRightSpace;
    
    arrRectForBars = [[NSMutableArray alloc] init];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"bounds: %@", NSStringFromCGRect(self.bounds));
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //선에 대한 속성 설정
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    //시작점 설정
    CGFloat startX = self.bounds.size.width - kDefaultTopSpace;
    CGFloat originX = self.bounds.origin.x;
    CGFloat originY = self.bounds.origin.y;
    CGFloat endY = self.bounds.size.height - kDefaultRightSpace;
    
    //y축
    CGContextMoveToPoint(context, startX, originY);
    CGContextAddLineToPoint(context, originX, originY);
    CGContextStrokePath(context);
    
    //x축
    CGContextMoveToPoint(context, originX, originY);
    CGContextAddLineToPoint(context, originX, endY);
    CGContextStrokePath(context);
    
    //그리드 Y축 라인 그리기
    CGFloat yheight = startX/5;
    for (int i = 1; i <= 5; i++)
    {
        CGFloat x1 = originX + (yheight *i);
        CGFloat y1 = originY;
        
        CGFloat x2 = x1;
        CGFloat y2 = endY;

        CGContextMoveToPoint(context, x1, y1);
        CGContextAddLineToPoint(context, x2, y2);
        CGContextStrokePath(context);
    }

    //그리드 X축 그리기
    CGFloat xwidth = endY/self.CountBars;
    for(int i =1; i<= self.CountBars; i++)
    {
        CGFloat x1 = originX;
        CGFloat y1 = originY + (xwidth * i);
        
        CGFloat x2 = startX;
        CGFloat y2 = y1;
        
        CGContextMoveToPoint(context, x1, y1);
        CGContextAddLineToPoint(context, x2, y2);
        CGContextStrokePath(context);
        
        CGRect rect = CGRectMake(x1, y1- xwidth, canvasHeight, xwidth);
        [arrRectForBars addObject:[NSValue valueWithCGRect:rect]];
//        NSLog(@"(x1, y1: %f, %f) (x2, y2: %f, %f) rect: %@", x1, y1, x2, y2, NSStringFromCGRect(rect));
        
    }
}

- (void)addChartBar:(NSInteger) idx Value:(NSNumber *)value
{
    if(arrRectForBars.count == 0)
        return;
    
    if(idx < arrRectForBars.count)
    {
        CGRect rect = [arrRectForBars[idx] CGRectValue];

        UIView *bar = [[UIView alloc] initWithFrame:rect];
        bar.backgroundColor = [self getRandomColor];
        
        NSLog(@"barData: idx: %ld, value: %@", (long)idx, value);
        [self addSubview:bar];
    }
    
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
