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
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"bounds: %@", NSStringFromCGRect(self.bounds));
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    //시작점 설정
    CGFloat startX = self.bounds.size.width - kDefaultTopSpace;
    CGFloat originX = self.bounds.origin.x;
    CGFloat originY = self.bounds.origin.y;
    CGFloat endY = self.bounds.size.height - kDefaultRightSpace;
    
    CGContextMoveToPoint(context, startX, originY);
    CGContextAddLineToPoint(context, originX, originY);
    CGContextAddLineToPoint(context, originX, endY);
    
    //라인 닫기
    CGContextClosePath(context);
    
    
    
    
    
}




@end
