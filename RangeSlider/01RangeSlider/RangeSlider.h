//
//  RangeSlider.h
//  01RangeSlider
//
//  Created by 김지선 on 2014. 6. 17..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RangeSliderDelegater;

@interface RangeSlider : UIControl


@property (nonatomic, strong) NSObject<RangeSliderDelegater> *delegate;

@property(assign, nonatomic) CGFloat minimumValue; // Slider의 최소값
@property(assign, nonatomic) CGFloat maximumValue; // Slider의 최대값

@property(assign, nonatomic) CGFloat leftValue; // Slider Range의 왼쪽값
@property(assign, nonatomic) CGFloat rightValue; // Slider Range의 오른쪽값

@property(retain, nonatomic) UIImage *maximumTrackImage;
@property(retain, nonatomic) UIImage *minimumTrackImage;

@property(retain, nonatomic) UIImage *leftThumbNormalImage;
@property(retain, nonatomic) UIImage *rightThumbNormalImage;
@property(retain, nonatomic) UIImage *leftThumbHighlightedImage;
@property(retain, nonatomic) UIImage *rightThumbHighlightedImage;

@end;

@protocol RangeSliderDelegater <NSObject>

@optional
- (void)changeLeftThumbValue:(CGFloat)value;
- (void)changeLeftThumbValue:(CGFloat)value CenterPoint:(CGPoint) point;
- (void)changeRightThumbValue:(CGFloat)value;
- (void)changeRightThumbValue:(CGFloat)value CenterPoint:(CGPoint) point;
@end