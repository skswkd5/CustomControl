//
//  BarChartBar.h
//  BarChart
//
//  Created by 김지선 on 2014. 6. 25..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	BarValueTextOnTop,      //bar 위에
    BarValueTextOnMiddle,   //중간에
    barValueTextNone        //보이지 않음
} BarValueText;

@interface BarChartBar : UIView
{
    NSString *strValue;
}

@property (assign, nonatomic) UIColor *color;
@property (assign, nonatomic) BarValueText barValueText;

- (id)initWithFrame:(CGRect)frame Value:(NSString *) value;
- (void)startAnimation;

@end
