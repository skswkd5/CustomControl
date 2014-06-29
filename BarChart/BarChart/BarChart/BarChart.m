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


static const NSInteger kDefaultWidthForYTitle = 10;
static const NSInteger kDefaultHeightForXTitle = 10;

static const NSInteger kDefaultWidthForYLabel = 30;
static const NSInteger kDefaultHeightForXLabel = 20;

static const NSInteger kTagForTitleLabel = 200;
static const NSInteger kTagForValueLabel = 100;

static const NSInteger kTagForBars = 500;

static const NSInteger kNumberOfYLabel = 6;

static const CGFloat kDefaultTopSpace = 10;
static const CGFloat kDefaultRightSpace = 10;

@interface BarChart()
{
    NSInteger maxValue;
    NSInteger minValue;
    NSInteger topValue;
    
    NSInteger countBars;
}

@property (retain, nonatomic) UIView *viewYTitle;
@property (retain, nonatomic) UIView *viewXTitle;
@property (retain, nonatomic) UIView *viewYLabel;
@property (retain, nonatomic) UIView *viewXLabel;

@property (retain, nonatomic) BarChartGrid *viewCanvas;
@property (retain, nonatomic) UIView *viewBars;
@property (retain, nonatomic) BarChartGrid *viewAnimation;

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
    maxValue = 0;
    minValue = 0;
    topValue = 0;
    countBars = 0;
    
    [self manageChartData];
    
}

- (void)manageChartData
{
    if(self.ChartData.count == 0)
    {
        return;
    }
    
    NSArray *keys = [self.ChartData allValues];
    countBars = keys.count;
    for(NSNumber *count in keys)
    {
        maxValue = MAX([count integerValue], maxValue);
        minValue = MIN([count integerValue], minValue);
    }
}


- (void)startAnimation
{
    self.viewBars.hidden = NO;
    for (int i=0; i < countBars; i++)
    {
        BarChartBar *bar = (BarChartBar *)[self.viewBars viewWithTag:kTagForBars +i];
        [bar startAnimation];
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
//    [self.viewYTitle addSubview:[self setLabelForYTitle:self.viewYTitle.bounds]];

    //X축 타이틀
    self.viewXTitle = [[UIView alloc] initWithFrame:[self setRectForXTitleView]];
//    [self.viewXTitle addSubview:[self setLabelForXTitle:self.viewXTitle.bounds]];
    
    //X축 데이터 Label
    self.viewXLabel = [[UIView alloc] initWithFrame:[self setRectForXLabelView]];
    
    //Y축 데이터 Label
    self.viewYLabel = [[UIView alloc] initWithFrame:[self setRectForYLabelView]];
    
    //Canvas
    self.viewCanvas = [[BarChartGrid alloc] initWithFrame:[self setRectForCanvasView]];
    self.viewCanvas.backgroundColor = [UIColor clearColor];
    self.viewCanvas.CountBars = countBars;
    
    [self addSubview:self.viewYTitle];
    [self addSubview:self.viewYLabel];

    [self addSubview:self.viewXTitle];
    [self addSubview:self.viewXLabel];
    
    [self addSubview:self.viewCanvas];
    
    [self addYLabelSubView];
    [self addXLabelSubView];
    
    //bar들 표시하기..
    self.viewBars = [[UIView alloc] initWithFrame:[self setRectForCanvasView]];
    [self addBarSubviews];
    self.viewBars.hidden = YES;
    [self addValueLabelForBars];
    
    [self insertSubview:self.viewBars aboveSubview:self.viewCanvas];
}

- (void)addBarSubviews
{
    //bar 추가하기
    NSArray *arr = [self getRectForEachBar];
    
    for (int i=0; i< arr.count; i++)
    {
        CGRect rect =  [arr[i] CGRectValue];
        
        BarChartBar *chartBar = [[BarChartBar alloc] initWithFrame:rect];
        chartBar.tag = kTagForBars + i;
        [self.viewBars addSubview:chartBar];
    }
}

- (void)addValueLabelForBars
{
    NSDictionary *dicInfo = [self getRectForBarValue];
    
    NSArray *arrRect = [dicInfo objectForKey:@"rect"];
    NSArray *arrValue = [dicInfo objectForKey:@"value"];
    
    if(arrRect.count > 0)
    {
        for(int i = 0; i < arrRect.count; i++)
        {
            CGRect rect = [arrRect[i] CGRectValue];
            
            UILabel *lbl = [[UILabel alloc]initWithFrame:rect];
            lbl.text = arrValue[i];
            lbl.font = [UIFont systemFontOfSize:10];
            lbl.textColor = [UIColor blackColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.backgroundColor = [UIColor clearColor];
         
            [self.viewBars addSubview:lbl];
        }
    }
}


- (NSDictionary *)getRectForBarValue
{
    //시작점 설정
    CGFloat originX = self.viewBars.bounds.origin.x;
    CGFloat originY = self.viewBars.bounds.origin.y;
    CGFloat height = self.viewBars.bounds.size.height;
    
    CGFloat hForValue = self.viewBars.bounds.size.height  / topValue;
    
    NSMutableArray *arrRect = [[NSMutableArray alloc] init];
    NSMutableArray *arrValue = [[NSMutableArray alloc] init];
    NSInteger space = 3;

    CGFloat width = self.viewBars.bounds.size.width/countBars;
    
    for(int i = 0; i< countBars; i++)
    {
        CGFloat x1 = originX + (width *i) + space;
        CGFloat y1 = originY;
        
        CGFloat barHeight = 20;
        CGFloat lblHeight = 20;
        
        NSNumber *value = nil;
        
        if(self.ChartData.count >0)
        {
            NSArray *arr = [self.ChartData allKeys];
            NSString *key = [arr objectAtIndex:i];
            
            value = [self.ChartData objectForKey:key];
            [arrValue addObject:[value stringValue]];
            
            barHeight = hForValue * [value floatValue];
            y1 += (height - barHeight - lblHeight);
        }
        
        CGRect rect = CGRectMake(x1, y1, width - (space *2), lblHeight);
        [arrRect addObject:[NSValue valueWithCGRect:rect]];
    }
    
    NSMutableDictionary *dicBarInfo = [[NSMutableDictionary alloc] init];
    [dicBarInfo setObject:arrRect forKey:@"rect"];
    [dicBarInfo setObject:arrValue forKey:@"value"];
    
    return dicBarInfo;
}

- (NSArray *)getRectForEachBar
{
    //시작점 설정
    CGFloat originX = self.viewBars.bounds.origin.x;
    CGFloat originY = self.viewBars.bounds.origin.y;
    CGFloat height = self.viewBars.bounds.size.height;
    
    CGFloat hForValue = self.viewBars.bounds.size.height  / topValue;
    
    NSMutableArray *arrRectForBars = [[NSMutableArray alloc] init];
    
    CGFloat width = self.viewBars.bounds.size.width/countBars;
    CGFloat space = width /4;
    
    for(int i = 0; i< countBars; i++)
    {
        CGFloat x1 = originX + space + (width *i);
        CGFloat y1 = originY;
        
        CGFloat barWidth = space * 2;
        CGFloat barHeight = height;
        
        NSNumber *value = nil;
        
        if(self.ChartData.count >0)
        {
            NSArray *arr = [self.ChartData allKeys];
            NSString *key = [arr objectAtIndex:i];
    
            value = [self.ChartData objectForKey:key];
            
            barHeight = hForValue * [value floatValue];
            y1 += height - barHeight;
        }

        CGRect rect = CGRectMake(x1, y1, barWidth, barHeight);
        
        [arrRectForBars addObject:[NSValue valueWithCGRect:rect]];
    }
    
    return arrRectForBars;
}


- (void)addXLabelSubView
{
    if(countBars != 0)
    {
        CGFloat width =  self.viewCanvas.bounds.size.width / countBars;
        
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
        NSInteger labels = kNumberOfYLabel ;
        topValue = maxValue + ( maxValue * 0.10);
        
        NSInteger interval = topValue / (labels -1);
        CGFloat height =  self.viewCanvas.bounds.size.height /(labels-1);
        
        for (int i = 0; i < labels; i ++)
        {
            CGRect rect = self.viewYLabel.bounds;
            rect.size.height = 20;
            if (i > 0)
            {
                rect.origin.y =  height * i;
            }
            
            UILabel * lbl = [[UILabel alloc] initWithFrame:rect];
            lbl.tag = kTagForValueLabel + i;
            lbl.font = [UIFont systemFontOfSize:10];
            lbl.textColor = [UIColor blackColor];
            lbl.textAlignment = NSTextAlignmentRight;
            
            NSInteger lblValue = topValue - (i * interval);
            
            if( (labels -1) == i)
            {
                lblValue = 0;
            }
            
            lbl.text = [NSString stringWithFormat:@"%ld", (long)lblValue];
            [self.viewYLabel addSubview: lbl];
        }
    }
}

- (UILabel *)setLabelForYTitle:(CGRect)rect
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.tag = kTagForTitleLabel +1;
    lbl.font = [UIFont systemFontOfSize:20];
    lbl.textColor = [UIColor colorWithRed:161/255.0 green:174/255.0 blue:200/255.0 alpha:1];
    lbl.text = @"Default";
//    lbl.transform = CGAffineTransformMakeRotation((M_PI / 45.0));
//    lbl.textAlignment = NSTextAlignmentCenter;
    
    return lbl;
}

- (UILabel *)setLabelForXTitle:(CGRect)rect
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    lbl.tag = kTagForTitleLabel + 2;
    lbl.font = [UIFont systemFontOfSize:20];
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
        CGFloat height = rect.origin.y  + self.viewXTitle.frame.size.height;
        rect.size.height -= height ;
        
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
    rect.origin.y = kDefaultTopSpace;
    
    rect.size.width = self.bounds.size.width - rect.origin.x - kDefaultRightSpace;
    rect.size.height = self.bounds.size.height - (self.viewXTitle.frame.size.height + self.viewXLabel.frame.size.height) - rect.origin.y;
    
    return rect;
}

@end
