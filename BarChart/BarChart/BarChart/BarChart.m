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

static const NSInteger kDefaultWidthForYTitle = 20;
static const NSInteger kDefaultHeightForXTitle = 20;

static const NSInteger kDefaultWidthForYLabel = 20;
static const NSInteger kDefaultHeightForXLabel = 20;

static const NSInteger kTagForTitleLabel = 200;
static const NSInteger kTagForValueLabel = 100;

@interface BarChart()
{
    NSInteger maxValue;
    NSInteger minValue;
    NSInteger countBars;
}

@property (retain, nonatomic) UIView *viewYTitle;
@property (retain, nonatomic) UIView *viewXTitle;
@property (retain, nonatomic) UIView *viewYLabel;
@property (retain, nonatomic) UIView *viewXLabel;

@property (retain, nonatomic) BarChartGrid *viewCanvas;

@end

@implementation BarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializingValues];
//        [self initializingViews];
    }
    return self;
}

#pragma mark - Initializing
- (void)initializingValues
{
    self.gridHidden = YES;
    
    self.viewYTitle.hidden = YES;
    self.viewYLabel.hidden = YES;
    self.viewXTitle.hidden = YES;
    self.viewXLabel.hidden = YES;
    self.viewCanvas.hidden = YES;
    
    maxValue = 0;
    minValue = 0;
    countBars = 0;

}




#pragma mark - Default Layout
- (void)layoutSubviews
{
    
    [self manageChartData];
    
    if ([self.subviews count] == 0)
    {
        [self addSubviews];
    }
    
    self.viewYTitle.frame = [self setRectForYTitleView];
    self.viewYLabel.frame = [self setRectForYLabelView];
    self.viewXTitle.frame = [self setRectForXTitleView];
    self.viewXLabel.frame = [self setRectForXLabelView];
    self.viewCanvas.frame = [self setRectForCanvasView];
    
  
    [self setBars];
    

}
- (void)setBars
{
    if (self.ChartData.count == 0)
        return;
    
    NSInteger idx = 0;
    for (NSNumber *count in self.ChartData)
    {
        [self.viewCanvas addChartBar:idx Value:count];
        idx ++;
    }
}

- (void)manageChartData
{
    if(self.ChartData.count == 0)
    {
        return;
    }
    //TODO: 1월 부터 12월로 데이터 정렬하기
    NSArray *keys = [self.ChartData allValues];
    countBars = keys.count;
    for(NSNumber *count in keys)
    {
        maxValue = MAX([count integerValue], maxValue);
        minValue = MIN([count integerValue], minValue);
    }
    
}

- (void)addSubviews
{
    //Y축 타이틀
    self.viewYTitle = [[UIView alloc] initWithFrame:[self setRectForYTitleView]];
//    [self.viewYTitle addSubview:[self setLabelForTitle:self.viewYTitle.frame]];
    
    //Y축 데이터 Label
    self.viewYLabel = [[UIView alloc] initWithFrame:[self setRectForYLabelView]];
    
    //X축 타이틀
    self.viewXTitle = [[UIView alloc] initWithFrame:[self setRectForXTitleView]];
//    [self.viewXTitle addSubview:[self setLabelForTitle:self.viewXTitle.frame]];
    
    //X축 데이터 Label
    self.viewXLabel = [[UIView alloc] initWithFrame:[self setRectForXLabelView]];
    
    //Canvas
    self.viewCanvas = [[BarChartGrid alloc] initWithFrame:[self setRectForCanvasView]];
    self.viewCanvas.backgroundColor = [UIColor clearColor];
    self.viewCanvas.CountBars = countBars;
    
    [self addSubview:self.viewYTitle];
    [self addSubview:self.viewYLabel];

    [self addSubview:self.viewXTitle];
    [self addSubview:self.viewXLabel];
    
    [self addSubview:self.viewCanvas];
    
}

- (UILabel *)setLabelForTitle:(CGRect)rect
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.tag = kTagForTitleLabel;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.textColor = [UIColor colorWithRed:161/255.0 green:174/255.0 blue:200/255.0 alpha:1];
    lbl.text = @"Default";
    lbl.textAlignment = NSTextAlignmentCenter;
    
    return lbl;
}

#pragma mark - set Rect

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
    return rect;
}

- (CGRect)setRectForYLabelView
{
    CGRect rect = self.bounds;
    
    if (self.viewYLabel.hidden)
    {
        rect = CGRectZero;
    }
    else
    {
        if (!self.yLabelWidth)
        {
            self.yLabelWidth = kDefaultWidthForYLabel;
        }
        rect.origin.y = self.viewYTitle.frame.origin.y + self.viewYTitle.frame.size.height;
        rect.size.height = self.yLabelWidth;
        
    }
    return rect;
}

- (CGRect)setRectForXTitleView
{
    CGRect rect = self.bounds;
    if (self.viewXTitle.hidden)
    {
        rect = CGRectZero;
    }
    else
    {
        if (!self.xTitleHeight)
        {
            self.xTitleHeight = kDefaultHeightForXTitle;
        }
        rect.size.width = self.xTitleHeight;
    }
    return rect;
}

- (CGRect)setRectForXLabelView
{
    CGRect rect = self.bounds;
    if (self.viewXLabel.hidden)
    {
        rect = CGRectZero;
    }
    else
    {
        if (!self.XLabelHeight)
        {
            self.XLabelHeight = kDefaultHeightForXLabel;
        }
        rect.origin.x = self.viewXTitle.frame.size.width;
        rect.size.width = self.XLabelHeight;
    }
    return rect;
}

- (CGRect)setRectForCanvasView
{
    CGRect rect = self.frame;
    
    rect.origin.x = self.viewXTitle.frame.size.width + self.viewXLabel.frame.size.width;
    rect.origin.y = self.viewYTitle.frame.size.height + self.viewYLabel.frame.size.height;
    
    rect.size.width = self.bounds.size.width - rect.origin.x;
    rect.size.height = self.bounds.size.height - rect.origin.y;
    
    return rect;
}

@end
