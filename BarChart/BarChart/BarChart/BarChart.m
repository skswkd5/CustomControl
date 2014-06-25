//
//  BarChart.m
//  BarChart
//
//  Created by 김지선 on 2014. 6. 25..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "BarChart.h"
#import "BarChartGrid.h"
#import "BarChartBar.h"

static const NSInteger kDefaultWidthForYTitle = 30;
static const NSInteger kDefaultHeightForXTitle = 30;

static const NSInteger kDefaultWidthForYLabel = 30;
static const NSInteger kDefaultHeightForXLabel = 30;

@interface BarChart()
{
    
}

@property (retain, nonatomic) UIView *viewYTitle;
@property (retain, nonatomic) UIView *viewXTitle;
@property (retain, nonatomic) UIView *viewYLabel;
@property (retain, nonatomic) UIView *viewXLabel;
@property (retain, nonatomic) UIView *viewCanvas;

@end

@implementation BarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    bcGrid = [[BarChartGrid alloc] initWithFrame:self.bounds];
//    bcGrid.backgroundColor = [UIColor yellowColor];
//    
//    
//    
//    [self addSubview:bcGrid];
//}

#pragma mark - Default Layout


- (void)layoutSubviews
{
//    [super layoutSubviews];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self.subviews count] == 0)
    {
        [self addSubviews];
    }
    
//    self.viewYLabel.frame = [self setRectForYTitleView];

}

- (void)addSubviews
{
    //Y축 타이틀
    self.viewYTitle = [[UIView alloc] initWithFrame:[self setRectForYTitleView]];
    self.viewYTitle.backgroundColor = [UIColor blueColor];
    
    //Y축 데이터 Label
    self.viewYLabel = [[UIView alloc] initWithFrame:[self setRectForYLabelView]];
    self.viewYLabel.backgroundColor = [UIColor lightGrayColor];
    
    //X축 타이틀
    self.viewXTitle = [[UIView alloc] initWithFrame:[self setRectForXTitleView]];
    self.viewXTitle.backgroundColor = [UIColor greenColor];
    
    //X축 데이터 Label
    self.viewXLabel = [[UIView alloc] initWithFrame:[self setRectForXLabelView]];
    self.viewXLabel.backgroundColor = [UIColor darkGrayColor];
    
    //Canvas
    self.viewCanvas = [[UIView alloc] initWithFrame:[self setRectForCanvasView]];
    self.viewCanvas.backgroundColor = [UIColor redColor];
    
    [self addSubview:self.viewYTitle];
    [self addSubview:self.viewYLabel];

    [self addSubview:self.viewXTitle];
    [self addSubview:self.viewXLabel];
    
    [self addSubview:self.viewCanvas];
    
}

- (CGRect)setRectForYTitleView
{
    CGRect rect = self.bounds;
    
    if (self.viewYTitle.hidden)
    {
        //보이지 않기로 한다면 zero로 한다.
        rect = CGRectZero;
    }
    else
    {
        if (!self.yTitleWidth)
        {
            //만약 따로 설정해주지 않았다면 Default 값을 가진다.
            self.yTitleWidth = kDefaultWidthForYTitle;
        }
        rect.size.height = self.yTitleWidth;
    }
    NSLog(@"%s rect: %@", __PRETTY_FUNCTION__, NSStringFromCGRect(rect));
    return rect;
}

- (CGRect)setRectForYLabelView
{
    CGRect rect = self.bounds;
    
    if (self.viewYLabel.hidden)
    {
        //보이지 않기로 한다면 zero로 한다.
        rect = CGRectZero;
    }
    else
    {
        if (!self.yLabelWidth)
        {
            //만약 따로 설정해주지 않았다면 Default 값을 가진다.
            self.yLabelWidth = kDefaultWidthForYLabel;
        }
        rect.origin.y = self.viewYTitle.frame.origin.y + self.viewYTitle.frame.size.height;
        rect.size.height = self.yLabelWidth;
        
    }
    
    NSLog(@"%s rect: %@", __PRETTY_FUNCTION__, NSStringFromCGRect(rect));
    return rect;
}

- (CGRect)setRectForXTitleView
{
    CGRect rect = self.bounds;
    if (self.viewXTitle.hidden)
    {
        //보이지 않기로 한다면 zero로 한다.
        rect = CGRectZero;
    }
    else
    {
        if (!self.xTitleHeight)
        {
            //만약 따로 설정해주지 않았다면 Default 값을 가진다.
            self.xTitleHeight = kDefaultHeightForXTitle;
        }
        rect.size.width = self.xTitleHeight;
    }
    NSLog(@"%s rect: %@", __PRETTY_FUNCTION__, NSStringFromCGRect(rect));
    return rect;
}

- (CGRect)setRectForXLabelView
{
    CGRect rect = self.bounds;
    if (self.viewXLabel.hidden)
    {
        //보이지 않기로 한다면 zero로 한다.
        rect = CGRectZero;
    }
    else
    {
        if (!self.XLabelHeight)
        {
            //만약 따로 설정해주지 않았다면 Default 값을 가진다.
            self.XLabelHeight = kDefaultHeightForXLabel;
        }
        rect.origin.x = self.viewXTitle.frame.size.width;
        rect.size.width = self.XLabelHeight;
    }
    NSLog(@"%s rect: %@", __PRETTY_FUNCTION__, NSStringFromCGRect(rect));
    return rect;
}

- (CGRect)setRectForCanvasView
{
    CGRect rect = self.bounds;
    
    rect.origin.x = self.viewXTitle.frame.size.width + self.viewXLabel.frame.size.width;
    rect.origin.y = self.viewYTitle.frame.size.height + self.viewYLabel.frame.size.height;
    
    rect.size.width = self.bounds.size.width - rect.origin.x;
    rect.size.height = self.bounds.size.height - rect.origin.y;
    
    NSLog(@"%s rect: %@", __PRETTY_FUNCTION__, NSStringFromCGRect(rect));
    return rect;
}

@end
