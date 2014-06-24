//
//  ViewController.m
//  01RangeSlider
//
//  Created by 김지선 on 2014. 6. 17..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize labelSlider;
@synthesize sliderBar;

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%s", __FUNCTION__);
    
}

- (void)viewDidLoad
{
    NSLog(@"%s", __FUNCTION__);
    
    [super viewDidLoad];
    
    [self setViewforStandardSlider];
    [self setRangeSlider];
    
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%s", __FUNCTION__);
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TestSlider
- (void) setTestSlider
{
    //    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(5, 30, 300, 50)];
    UISlider *slider = [[UISlider alloc] init];
    [self.view addSubview:slider];
    NSLog(@"slider.bounds: %@", NSStringFromCGRect(slider.bounds));
    
}

#pragma mark - RamgeSlider
- (void)setRangeSlider
{
    NSLog(@"%s", __FUNCTION__);
    
//    UISlider *slider = [[UISlider alloc] init];
//    [self.view addSubview:slider];
    
    CGRect rect = CGRectMake(50, 100, 200, 50);
    self.viewRangeSlider = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:self.viewRangeSlider];
    self.viewRangeSlider.backgroundColor = [UIColor colorWithRed:193/255.0 green:150/255.0 blue:197/255.0 alpha:0.3];
    
    rect = CGRectMake(0, 25, 200, 30);
    self.sliderRange = [[RangeSlider alloc] initWithFrame:rect];
    self.sliderRange.delegate = self;
    [self.viewRangeSlider addSubview:self.sliderRange];
    
    self.sliderRange.maximumValue = 200;
    self.sliderRange.minimumValue = 0;
    
    self.sliderRange.leftValue = 10;
    self.sliderRange.rightValue = 100;
    
    CGRect rectLabel1 = CGRectMake(0, 0, 50, 15);
    self.labelLeftThumb = [[UILabel alloc] initWithFrame:rectLabel1];
    self.labelLeftThumb.textColor = [UIColor colorWithRed:161/255.0 green:174/255.0 blue:200/255.0 alpha:1];
    self.labelLeftThumb.font = [UIFont systemFontOfSize:12];
    self.labelLeftThumb.text = [NSString stringWithFormat:@"%d", (int)self.sliderRange.leftValue];
    [self.viewRangeSlider addSubview:self.labelLeftThumb];
    
    
    CGRect rectLabel2 = CGRectMake(100, 0, 50, 15);
    self.labelRightThumb = [[UILabel alloc] initWithFrame:rectLabel2];
    self.labelRightThumb.textColor = [UIColor colorWithRed:161/255.0 green:174/255.0 blue:200/255.0 alpha:1];
    self.labelRightThumb.font = [UIFont systemFontOfSize:12];
    self.labelRightThumb.text = [NSString stringWithFormat:@"%d", (int)self.sliderRange.rightValue];
    [self.viewRangeSlider addSubview:self.labelRightThumb];
    
    

}


#pragma mark - StandardSlider
- (void)setViewforStandardSlider
{
    NSLog(@"%s", __FUNCTION__);
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    CGRect vRect = [UIScreen mainScreen].bounds;
    vRect.origin.y = 30.0f;
    vRect.size.height = 100.0f;
    
    //    self.viewStandardSlider = [[UIView alloc] initWithFrame:vRect];
    self.viewStandardSlider.frame = CGRectMake(10, 20, 200, 300);// vRect;
    self.viewStandardSlider.backgroundColor = [UIColor colorWithRed:254/255.0 green:525/255.0 blue:234/255.0 alpha:1];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectZero.origin.x +5, CGRectZero.origin.y +5, vRect.size.width, 15.0f)];
    labelTitle.font = [UIFont systemFontOfSize:18];
    labelTitle.text = @"Standard Slider";
    labelTitle.textAlignment = UITextAlignmentLeft;
    [self.viewStandardSlider addSubview:labelTitle];
    
    CGRect sRect = self.viewStandardSlider.frame;
    sRect.origin.y = sRect.size.height/2;
    
    //    self.sliderBar = [[UISlider alloc] initWithFrame:sRect];
    self.sliderBar.minimumValue = -1.0f;
//    self.sliderBar.maximumValue = 0.0f;
    self.sliderBar.value = 1;
    
    //    self.labelSlider.frame = CGRectMake(0, 0, 100, 20);
    //    self.labelSlider.backgroundColor = [UIColor blueColor];
    self.labelSlider.center = self.sliderBar.center;
    
    self.labelSlider.textColor = [UIColor colorWithRed:161/255.0 green:174/255.0 blue:200/255.0 alpha:1];
    
    self.labelSlider.font = [UIFont systemFontOfSize:12];
    self.labelSlider.text = @"0";
    
//    [self.sliderBar setMaximumValueImage:[UIImage imageNamed:@"progress_bar_mask_right" ]];
//    [self.sliderBar setMinimumValueImage:[UIImage imageNamed:@"progress_bar_mask_left" ]];
    
    
//   [self.sliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider-default7-track" ] forState:UIControlStateNormal];
//   [self.sliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider-default7-trackCrossedOver" ] forState:UIControlStateNormal];
    
//    [self.sliderBar setThumbImage:[UIImage imageNamed:@"btn_chat_input_field01_02"] forState:UIControlStateNormal];
//    [self.sliderBar setThumbImage:[UIImage imageNamed:@"btn_chat_input_field01_03"] forState:UIControlStateHighlighted];
    
}


- (IBAction)changingValue:(id)sender
{
    //값이 변할때
    self.labelSlider.text = [NSString stringWithFormat:@"%d", (int)self.sliderBar.value ];
    
}

#pragma mark - RangeSlider Delegate
//- (void)changeLeftThumbValue:(CGFloat)value
//{
//     NSLog(@"%s", __FUNCTION__);
//     self.labelLeftThumb.text = [NSString stringWithFormat:@"%d", (int)value];
//}
//
//- (void)changeRightThumbValue:(CGFloat)value
//{
//     NSLog(@"%s", __FUNCTION__);
//    self.labelRightThumb.text = [NSString stringWithFormat:@"%d", (int)value];
//}

- (void)changeLeftThumbValue:(CGFloat)value CenterPoint:(CGPoint) point
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"Left CenterPoint: %@", NSStringFromCGPoint(point));
    NSLog(@"self.labelLeftThumb CenterPoint: %@", NSStringFromCGPoint(self.labelLeftThumb.center));
    
    self.labelLeftThumb.text = [NSString stringWithFormat:@"%d", (int)value];
    CGPoint rect = self.labelLeftThumb.center;
    rect.x = point.x + 25;
//    rect.y = point.y + 20;
    self.labelLeftThumb.center = rect;
    
}

- (void)changeRightThumbValue:(CGFloat)value CenterPoint:(CGPoint) point
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"Right CenterPoint: %@", NSStringFromCGPoint(point));
    NSLog(@"self.labelRightThumb CenterPoint: %@", NSStringFromCGPoint(self.labelRightThumb.center));
    
    self.labelRightThumb.text = [NSString stringWithFormat:@"%d", (int)value];
    CGPoint rect = self.labelRightThumb.center;
    rect.x = point.x + 25;
//    rect.y = point.y + 20;
    self.labelRightThumb.center = rect;
    
}


@end
