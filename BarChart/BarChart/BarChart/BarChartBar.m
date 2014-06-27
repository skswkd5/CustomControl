//
//  BarChartBar.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 25..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BarChartBar.h"

@implementation BarChartBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    
    CGColorRef color = [self getRandomColor].CGColor;
    CGContextSetFillColorWithColor(context, color);
    CGContextFillRect(context, rect);
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
