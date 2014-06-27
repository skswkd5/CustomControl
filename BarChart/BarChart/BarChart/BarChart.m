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

static const NSInteger kDefaultWidthForYLabel = 30;
static const NSInteger kDefaultHeightForXLabel = 20;

static const NSInteger kTagForTitleLabel = 200;
static const NSInteger kTagForValueLabel = 100;

static const NSInteger kNumberOfYLabel = 6;

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
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame DataSource:(NSDictionary *)chartData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ChartData = chartData;
        [self initializingValues];
    }
    return self;
}

#pragma mark - Initializing
- (void)initializingValues
{
//    self.gridHidden = YES;
    
//    self.viewYTitle.hidden = YES;
//    self.viewYLabel.hidden = YES;
//    self.viewXTitle.hidden = YES;
//    self.viewXLabel.hidden = YES;
//    self.viewCanvas.hidden = YES;
    
    maxValue = 0;
    minValue = 0;
    countBars = 0;
    
    [self manageChartData];
    
}

- (void)manageChartData
{
    if(self.ChartData.count == 0)
    {
        return;
    }
    //TODO: 1월 부터 12월로 데이터 정렬하기
    NSArray *keys = [self.ChartData allValues];
//    NSArray* sortedArray = [keys sortedArrayUsingComparator:^(id a, id b) {
//        return [a compare:b options:NSNumericSearch];
//    }];
    
//    NSLog(@"sortedArray: %@", sortedArray);
    
    countBars = keys.count;
    for(NSNumber *count in keys)
    {
        maxValue = MAX([count integerValue], maxValue);
        minValue = MIN([count integerValue], minValue);
    }
}



#pragma mark - Default Layout
- (void)layoutSubviews
{
    if ([self.subviews count] == 0)
    {
        [self addSubviews];
    }
    
    self.viewYTitle.frame = [self setRectForYTitleView];
    self.viewYLabel.frame = [self setRectForYLabelView];
    self.viewXTitle.frame = [self setRectForXTitleView];
    self.viewXLabel.frame = [self setRectForXLabelView];
    self.viewCanvas.frame = [self setRectForCanvasView];

}


- (void)addSubviews
{
    //Y축 타이틀
    self.viewYTitle = [[UIView alloc] initWithFrame:[self setRectForYTitleView]];
//    [self.viewYTitle addSubview:[self setLabelForTitle:self.viewYTitle.frame]];
    
    //Y축 데이터 Label
    self.viewYLabel = [[UIView alloc] initWithFrame:[self setRectForYLabelView]];
    [self addYLabelSubView];
    
    //X축 타이틀
    self.viewXTitle = [[UIView alloc] initWithFrame:[self setRectForXTitleView]];
//    [self.viewXTitle addSubview:[self setLabelForTitle:self.viewXTitle.frame]];
    
    //X축 데이터 Label
    self.viewXLabel = [[UIView alloc] initWithFrame:[self setRectForXLabelView]];
    [self addXLabelSubView];
    
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

- (void)addXLabelSubView
{
    if(countBars != 0)
    {
        CGFloat width =  round(self.viewXLabel.bounds.size.width / countBars);
        
        for (int i = 1; i <= countBars; i ++)
        {
            CGRect rect = self.viewXLabel.bounds;
            rect.size.width = width;
            if (i > 1)
            {
                rect.origin.x = width * (i - 1);
            }
            
            UILabel * lbl = [[UILabel alloc] initWithFrame:rect];
            lbl.tag = kTagForValueLabel + i;
            lbl.font = [UIFont systemFontOfSize:10];
            lbl.textColor = [UIColor blackColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            
            NSArray *arr = [self.ChartData allKeys];
            NSString *lblValue = [arr objectAtIndex:(i-1)];
            
            lbl.text = lblValue;
            
            [self.viewXLabel addSubview: lbl];
        }
    }
}

- (void)addYLabelSubView
{
    if(maxValue != 0)
    {
        NSInteger topValue = maxValue + ( maxValue * 0.10);
        NSInteger interval = topValue / kNumberOfYLabel ;
        CGFloat height =  round(self.viewYLabel.bounds.size.height / kNumberOfYLabel);
        
        for (int i = 1; i <= kNumberOfYLabel; i ++)
        {
            CGRect rect = self.viewYLabel.bounds;
            rect.size.height = height;
            rect.origin.y = self.viewYLabel.bounds.size.height - (height * i);
            
            UILabel * lbl = [[UILabel alloc] initWithFrame:rect];
            lbl.tag = kTagForValueLabel + i;
            lbl.font = [UIFont systemFontOfSize:10];
            lbl.textColor = [UIColor blackColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            NSInteger lblValue = 0;
            
            if(i > 1)
            {
                lblValue = interval * (i -1);
            }
            
            lbl.text = [NSString stringWithFormat:@"%ld", (long)lblValue];
            
            [self.viewYLabel addSubview: lbl];
        }
    }
}

- (UILabel *)setLabelForTitle:(CGRect)rect
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.tag = kTagForTitleLabel;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.textColor = [UIColor colorWithRed:161/255.0 green:174/255.0 blue:200/255.0 alpha:1];
    lbl.text = @"Default";
//    lbl.transform = CGAffineTransformMakeRotation((M_PI / 45.0));
//    lbl.textAlignment = NSTextAlignmentCenter;
    
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
        rect.size.width = self.yTitleWidth;
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
    
        rect.origin.x = self.viewYTitle.frame.size.width;
        rect.size.width = self.yLabelWidth;
        rect.size.height -= (self.viewXTitle.frame.size.height);
        
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
        rect.origin.y = self.bounds.size.height - self.xTitleHeight;
        rect.size.height = self.xTitleHeight;
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
        rect.origin.y = self.bounds.size.height - self.viewXTitle.bounds.size.height - self.XLabelHeight;
        rect.origin.x = self.viewYTitle.frame.size.width + self.viewYLabel.frame.size.width;
        
        rect.size.width = self.bounds.size.width - rect.origin.x;
        rect.size.height = self.XLabelHeight;
    }
    return rect;
}

- (CGRect)setRectForCanvasView
{
    CGRect rect = self.frame;
    
    rect.origin.x = self.viewYTitle.frame.size.width + self.viewYLabel.frame.size.width;
    
    rect.size.width = self.bounds.size.width - rect.origin.x;
    rect.size.height = self.bounds.size.height - (self.viewXTitle.frame.size.height + self.viewXLabel.frame.size.height) - rect.origin.y;
    
    return rect;
}

@end
