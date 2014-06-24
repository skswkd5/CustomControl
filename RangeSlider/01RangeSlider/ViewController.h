//
//  ViewController.h
//  01RangeSlider
//
//  Created by 김지선 on 2014. 6. 17..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RangeSlider.h"

@interface ViewController : UIViewController <RangeSliderDelegater>

@property (nonatomic, strong) IBOutlet UIView *viewStandardSlider;
@property (nonatomic, strong) IBOutlet UILabel *labelSlider;
@property (nonatomic, strong) IBOutlet UISlider *sliderBar;

@property (nonatomic, retain) UIView *viewRangeSlider;
@property (nonatomic, retain) RangeSlider  *sliderRange;
@property (nonatomic, retain) UILabel  *labelLeftThumb;
@property (nonatomic, retain) UILabel  *labelRightThumb;

//CustomClass 로 만들기 전에 미리 만들어보기
@property (nonatomic, retain) UIView  *viewCustomSlider;

@end