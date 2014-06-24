//
//  RangeSlider.m
//  01RangeSlider
//
//  Created by 김지선 on 2014. 6. 17..
//  Copyright (c) 2014년 skswkd5. All rights reserved.
//

#import "RangeSlider.h"

#define HALF_LEFT_THUMB self.viewLeftThumb.frame.size.width / 2
#define HALF_RIGHT_THUMB self.viewLeftThumb.frame.size.width / 2

@interface RangeSlider ()
{
    CGFloat fWidthForValue;
    CGFloat fLeftThumbOffset;
    CGFloat fRightThumbOffset;
    
    CGFloat fLeftThumbPrePos;
    CGFloat fRightThumbPrePos;
}

@property (retain, nonatomic) UIImageView* viewLeftThumb;
@property (retain, nonatomic) UIImageView* viewRightThumb;
@property (retain, nonatomic) UIImageView* viewTrack;
@property (retain, nonatomic) UIImageView* viewTrackBackground;

@property(retain, nonatomic) UIImage* imgTrackBackgroud;
@property(retain, nonatomic) UIImage* imgTrack;

@end

static const CGFloat kDefaultSlideWidth = 100;
static const CGFloat kDefaultSlideHeight = 34;

@implementation RangeSlider

- (id)init
{
//    NSLog(@"%s", __FUNCTION__);
    self = [super init];
    if (self) {
        [self initializingValue];
        [self addSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
//    NSLog(@"%s", __FUNCTION__);
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initializingValue];
    }
    return self;
}


- (void)initializingValue
{
//    NSLog(@"%s", __FUNCTION__);
    //Default 값으로 초기화 시키기
    
    _maximumValue = 1.0f;
    _minimumValue = -1.0f;
    
    _leftValue = self.minimumValue;
    _rightValue = self.maximumValue;
    
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, kDefaultSlideWidth, kDefaultSlideHeight);
        self.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, kDefaultSlideWidth, kDefaultSlideHeight);
    }
    
    [self setWidthForValue];

}


- (void)addSubviews
{
//    NSLog(@"%s", __FUNCTION__);
    //------------------------------
    // Track Brackground
    self.viewTrackBackground = [[UIImageView alloc] initWithImage:self.imgTrackBackgroud];
    self.viewTrackBackground.frame = [self trackBackgroundRect];
    NSLog(@"self.viewTrackBackground.bounds: %@", NSStringFromCGRect(self.viewTrackBackground.bounds));
    
    //------------------------------
    // Track
    self.viewTrack = [[UIImageView alloc] initWithImage:[self trackImage]];
    self.viewTrack.frame = [self trackRect];
    NSLog(@"self.viewTrackBackground.bounds: %@", NSStringFromCGRect(self.viewTrackBackground.bounds));

    //------------------------------
    // Left Thumb
    self.viewLeftThumb = [[UIImageView alloc] initWithImage:self.leftThumbNormalImage highlightedImage:self.leftThumbHighlightedImage];
    self.viewLeftThumb.frame = [self thumbRectForValue:self.leftValue image:self.leftThumbNormalImage];
    NSLog(@"viewLeftThumb.bounds: %@", NSStringFromCGRect(self.viewLeftThumb.bounds));
    //------------------------------
    
    // Right Thumb
    self.viewRightThumb = [[UIImageView alloc] initWithImage:self.rightThumbNormalImage highlightedImage:self.rightThumbHighlightedImage];
    self.viewRightThumb.frame = [self thumbRectForValue:self.rightValue image:self.rightThumbNormalImage];
    NSLog(@"viewRightThumb.bounds: %@", NSStringFromCGRect(self.viewRightThumb.bounds));
    
    
    [self addSubview:self.viewTrackBackground];
    [self addSubview:self.viewTrack];
    [self addSubview:self.viewLeftThumb];
    [self addSubview:self.viewRightThumb];
}


- (void)layoutSubviews
{
    //initwithFrame 을 할때 뷰를 그려준다.
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"self.bounds: %@", NSStringFromCGRect(self.bounds));
    NSLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
    
    if ([self.subviews count] == 0 )
    {
        [self addSubviews];
    }
    
    NSLog(@"addSubviews 이후");
    
    //init으로 인스턴스를 생성했을때, 값 변환 이루어 지는 곳
    self.viewLeftThumb.image = self.leftThumbNormalImage;
    self.viewLeftThumb.highlightedImage = self.leftThumbHighlightedImage;
    self.viewLeftThumb.frame = [self thumbRectForValue:_leftValue image:self.leftThumbNormalImage];
    
    self.viewRightThumb.image = self.rightThumbNormalImage;
    self.viewRightThumb.highlightedImage = self.rightThumbHighlightedImage;
    self.viewRightThumb.frame = [self thumbRectForValue:_rightValue image:self.rightThumbNormalImage];
    
    self.viewTrack.frame = [self trackRect];
    
}




/* // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
      NSLog(@"%s", __FUNCTION__);
 // Drawing code
 }*/



#pragma mark - setting property
- (void)setMaximumValue:(CGFloat)maximumValue
{
//    NSLog(@"%s", __FUNCTION__);
    float value = maximumValue;
    
    value = MAX(value, _minimumValue);
    
    _maximumValue = value;
    
    NSLog(@"_maximumValue: %f", _maximumValue);
    
    [self setWidthForValue];
    [self setNeedsLayout];
    
}

- (void)setMinimumValue:(CGFloat)minimumValue
{
    NSLog(@"%s", __FUNCTION__);
    float value = minimumValue;
    value = MIN(value, _maximumValue);
    
    _minimumValue = value;
    
    NSLog(@"_minimumValue: %f", _minimumValue);
    
    [self setWidthForValue];
    [self setNeedsLayout];
    
}

- (void)setLeftValue:(CGFloat)leftValue
{
    NSLog(@"%s", __FUNCTION__);
    float value = leftValue;
    
    //값은 최소값과 최대값 사이에 있어야 한다
    value = MIN(value, _maximumValue);
    value = MAX(value, _minimumValue);
    
    _leftValue = value;
    
    NSLog(@"_leftValue: %f", _leftValue);
    
    [self setNeedsLayout];
}

- (void)setRightValue:(CGFloat)rightValue
{
//    NSLog(@"%s", __FUNCTION__);
    float value = rightValue;
    
    //값은 최소값과 최대값 사이에 있어야 한다
    value = MIN(value, _maximumValue);
    value = MAX(value, _minimumValue);
    
    _rightValue = value;
    
    NSLog(@"_rightValue: %f", _rightValue);
    
    [self setNeedsLayout];
}

- (void)setWidthForValue
{
//    NSLog(@"%s", __FUNCTION__);
    CGFloat fRange = 1;
    
    if (fabsf(self.maximumValue - self.minimumValue) != 0)
    {
        fRange = fabsf(self.maximumValue - self.minimumValue);
    }
    
    fWidthForValue = self.bounds.size.width/ fRange;
    
    NSLog(@"fWidthForValue: %f", fWidthForValue);
    
}

#pragma mark - LayOut
- (void)loadView
{
    NSLog(@"%s", __FUNCTION__);
}


#pragma mark - setting Rect
- (CGRect)trackBackgroundRect
{
    NSLog(@"%s", __FUNCTION__);
    
    CGRect rectTrack = self.bounds;
    rectTrack.size = CGSizeMake(self.bounds.size.width, self.imgTrackBackgroud.size.height);
    rectTrack.origin.y = (self.bounds.size.height - rectTrack.size.height)/2;
    
    //크기 조정: 버튼 이미지 주위에 여백이 있어 트랙 이미지가 삐져 나오므로 임의로 크기를 조정한다.
    rectTrack.size.width -= 2;
    rectTrack.origin.x  += 1;
    
//    if(self.imgTrackBackgroud.capInsets.top || self.imgTrackBackgroud.capInsets.bottom)
//    {
//        rectForTrack.size.height = self.bounds.size.height;
//    }
//
//    if(self.imgTrackBackgroud.capInsets.left || self.imgTrackBackgroud.capInsets.right)
//    {
//        rectForTrack.size.width = self.bounds.size.width - 4;
//    }
//
//    rectForTrack.origin = CGPointMake(2, (self.bounds.size.height/2.0f) - (rectForTrack.size.height / 2.0f));
    
    return rectTrack;
}

- (CGRect)trackRect
{
    NSLog(@"%s", __FUNCTION__);
//    UIImage *img_track = [self trackImage];
    
    CGRect rectTrack = self.bounds;
    rectTrack.size = CGSizeMake(self.bounds.size.width, self.imgTrack.size.height);
    rectTrack.origin.y = (self.bounds.size.height - rectTrack.size.height)/2;
    
    //두 Thumb 사이를 색칠해줘야 한다.
    CGPoint leftCenter = self.viewLeftThumb.center;
    CGPoint rightCenter = self.viewRightThumb.center;

    rectTrack.size.width = fabsf(rightCenter.x - leftCenter.x);
    rectTrack.origin.x  = leftCenter.x;

    
//    rectTrack.size = CGSizeMake(img_track.size.width, img_track.size.height);
//    
//    if(img_track.capInsets.top || img_track.capInsets.bottom)
//    {
//        retValue.size.height = self.bounds.size.height;
//    }
//    
//    float lowerHandleWidth = _lowerHandleHidden ? 2.0f : _lowerHandle.frame.size.width;
//    float upperHandleWidth = _upperHandleHidden ? 2.0f : _upperHandle.frame.size.width;
//    
//    float xLowerValue = ((self.bounds.size.width - lowerHandleWidth) * (_lowerValue - _minimumValue) / (_maximumValue - _minimumValue))+(lowerHandleWidth/2.0f);
//    float xUpperValue = ((self.bounds.size.width - upperHandleWidth) * (_upperValue - _minimumValue) / (_maximumValue - _minimumValue))+(upperHandleWidth/2.0f);
//    
//    retValue.origin = CGPointMake(xLowerValue, (self.bounds.size.height/2.0f) - (retValue.size.height/2.0f));
//    retValue.size.width = xUpperValue-xLowerValue;
    
    return rectTrack;
}


- (CGRect)thumbRectForValue:(float)value image:(UIImage*) thumbImage
{
    NSLog(@"%s", __FUNCTION__);
    
//    UIEdgeInsets insets = thumbImage.capInsets;
//    
//    thumbRect.size = CGSizeMake(thumbImage.size.width, thumbImage.size.height);
//    
//    if(insets.top || insets.bottom)
//    {
//        thumbRect.size.height = self.bounds.size.height;
//    }
    
    CGRect thumbRect = self.bounds;
    thumbRect.size = CGSizeMake(thumbImage.size.width, thumbImage.size.height);
    
    CGFloat fThumbY = (self.bounds.size.height - thumbRect.size.height)/2;
    CGFloat fThumbX = fWidthForValue * fabsf(value - _minimumValue);
    
    if(fThumbX < 0 )
    {
        //왼쪽 맨 끝으로 이동했을때 Thumb 버튼이 트랙밖으로 넘어가지 않아야 한다.
        fThumbX = 0;
    }
    if ((fThumbX + thumbRect.size.width) > self.bounds.size.width)
    {
        //오른쪽 맨 끝으로 이동시켰을때 Thumb 버튼이 트랙을 넘어가지 않아야 한다
        fThumbX -= thumbRect.size.width;
    }
    
//    float xValue = ((self.bounds.size.width - thumbRect.size.width) * ((value - _minimumValue) / (_maximumValue - _minimumValue)));
    thumbRect.origin = CGPointMake(fThumbX, fThumbY);
    
//    NSLog(@"thumbRect.origin: %@", NSStringFromCGPoint(thumbRect.origin));
    
    return CGRectIntegral(thumbRect);
}


#pragma mark - Default ImageView
- (UIImage *)imgTrackBackgroud
{
    NSLog(@"%s", __FUNCTION__);
    if(_imgTrackBackgroud == nil)
    {
//        if(IS_PRE_IOS7())
//        {
            UIImage* image = [UIImage imageNamed:@"slider-default7-trackBackground"];
            //이미지의 가운데를 늘려 이미지 보다 큰 이미지를 만든다
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0)];
            _imgTrackBackgroud = image;
//        }
//        else
//        {
//            UIImage* image = [UIImage imageNamed:@"slider-default7-trackBackground"];
//            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
//            _imgTrackBackgroud = image;
//        }
    }
    
    return _imgTrackBackgroud;
}

- (UIImage *)trackImage
{
    NSLog(@"%s", __FUNCTION__);
//    if(self.leftValue <= self.rightValue)
//    {
        return self.imgTrack;
//    }
}

- (UIImage *)imgTrack
{
    NSLog(@"%s", __FUNCTION__);
    if(_imgTrack == nil)
    {
//        if(IS_PRE_IOS7())
//        {
            UIImage* image = [UIImage imageNamed:@"slider-default7-track"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0)];
            _imgTrack = image;
//        }
//        else
//        {
//            
//            UIImage* image = [UIImage imageNamed:@"slider-default7-track"];
//            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
//            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//            _trackImage = image;
//        }
    }
    
    return _imgTrack;
}

- (UIImage *)leftThumbNormalImage
{
    NSLog(@"%s", __FUNCTION__);
    if(_leftThumbNormalImage == nil)
    {
//        if(IS_PRE_IOS7())
//        {
            UIImage* image = [UIImage imageNamed:@"slider-default-handle"];
            _leftThumbNormalImage = image;
//        }
//        else
//        {
//            UIImage* image = [UIImage imageNamed:@"slider-default7-handle"];
//            _lowerHandleImageNormal = image;
//        }
        
    }
    
    return _leftThumbNormalImage;
}

- (UIImage *)leftThumbHighlightedImage
{
    NSLog(@"%s", __FUNCTION__);
    if(_leftThumbHighlightedImage == nil)
    {
//        if(IS_PRE_IOS7())
//        {
        UIImage* image = [UIImage imageNamed:@"slider-default-handle-highlighted"];
        _leftThumbHighlightedImage = image;
//        }
//        else
//        {
//            UIImage* image = [UIImage imageNamed:@"slider-default7-handle"];
//            _lowerHandleImageNormal = image;
//        }
        
    }
    
    return _leftThumbHighlightedImage;
}

- (UIImage *)rightThumbNormalImage
{
    NSLog(@"%s", __FUNCTION__);
    if(_rightThumbNormalImage == nil)
    {
//        if(IS_PRE_IOS7())
//        {
        UIImage* image = [UIImage imageNamed:@"slider-default-handle"];
        _rightThumbNormalImage = image;
//        }
//        else
//        {
//            UIImage* image = [UIImage imageNamed:@"slider-default7-handle"];
//            _lowerHandleImageNormal = image;
//        }
        
    }
    
    return _rightThumbNormalImage;
}

- (UIImage *)rightThumbHighlightedImage
{
    NSLog(@"%s", __FUNCTION__);
    if(_rightThumbHighlightedImage == nil)
    {
//        if(IS_PRE_IOS7())
//        {
        UIImage* image = [UIImage imageNamed:@"slider-default-handle-highlighted"];
        _rightThumbHighlightedImage = image;
//        }
//        else
//        {
//            UIImage* image = [UIImage imageNamed:@"slider-default7-handle"];
//            _lowerHandleImageNormal = image;
//        }
        
    }
    
    return _rightThumbHighlightedImage;
}


#pragma mark - Touch handling

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"%s", __FUNCTION__);
    
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"touchPoint: %@",NSStringFromCGPoint(touchPoint));
    
    if(CGRectContainsPoint(self.viewLeftThumb.frame, touchPoint))
    {
        //왼쪽 버튼을 터치했을때
        self.viewLeftThumb.highlighted = YES;
        self.viewRightThumb.highlighted = NO;
        fLeftThumbOffset = touchPoint.x - _viewLeftThumb.center.x;
        fLeftThumbPrePos = _viewLeftThumb.center.x;
        NSLog(@"fLeftThumbPrePos: %f", fLeftThumbPrePos);
    }
    
    if(CGRectContainsPoint(self.viewRightThumb.frame, touchPoint))
    {
        //오른쪽 버튼을 터치한거라면..
        self.viewLeftThumb.highlighted = NO;
        self.viewRightThumb.highlighted = YES;
        fRightThumbOffset = touchPoint.x - _viewRightThumb.center.x;
        fRightThumbPrePos = _viewRightThumb.center.x;
        NSLog(@"fRightThumbPrePos: %f", fRightThumbPrePos);
    }
    
    return YES;
}


- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    NSLog(@"%s", __FUNCTION__);
  
    if(!self.viewLeftThumb.highlighted && !self.viewRightThumb.highlighted )
    {
        //선택된 상태가 아니라면, 계속 움직이고 있는 상태가 아니다.
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"touchPoint: %@",NSStringFromCGPoint(touchPoint));
    NSLog(@"fLeftThumbOffset: %f fLeftThumbOffset: %f",fLeftThumbOffset, (touchPoint.x - fLeftThumbOffset));
    
    if(self.viewLeftThumb.highlighted)
    {
        CGFloat fNewValue = [self returnChangedLeftThumbValue:(touchPoint.x - fLeftThumbOffset)];
        //오른쪽 Thumb과 겹치지 않기 위해
        CGFloat fHalfX = HALF_LEFT_THUMB/ fWidthForValue;
        NSLog(@" NewValue: %f _rightValue: %f new+halfX: %f", fNewValue, _rightValue, (fNewValue + (fHalfX * 2)));
        
        if (fLeftThumbOffset > 0) {
            //오른쪽으로 이동
            if( _minimumValue < fNewValue && _rightValue > (fNewValue + (fHalfX * 2)))
                //        if(!self.viewLeftThumb.highlighted || fNewValue <_leftValue)
            {
                NSLog(@"움직임");
                
                [self bringSubviewToFront:self.viewLeftThumb];
                [self setLeftValue:fNewValue];
                //이동에 따라 값을 넘겨준다.
                [self returnChangedLeftThumbInfo];
            }
            else
            {
                NSLog(@"움직이지 않음");
                self.viewLeftThumb.highlighted = NO;
            }
        }
        else
        {
            //왼쪽으로 이동
            if( _minimumValue < fNewValue)
            {
                NSLog(@"움직임");
                
                [self bringSubviewToFront:self.viewLeftThumb];
                [self setLeftValue:fNewValue];
                
                //이동에 따라 값을 넘겨준다.
                [self returnChangedLeftThumbInfo];            }
            else
            {
                NSLog(@"움직이지 않음");
                self.viewLeftThumb.highlighted = NO;
            }
        }
        
        
//        if(!self.viewLeftThumb.highlighted || newValue <_lowerValue)
//        {
//            _upperHandle.highlighted = NO;
//            [self bringSubviewToFront:_lowerHandle];
//            
//            [self setLowerValue:newValue animated:_stepValueContinuously ? YES : NO];
//        }
//        else
//        {
//            _lowerHandle.highlighted = NO;
//        }
    }
    
    if(self.viewRightThumb.highlighted )
    {
        NSLog(@"self.viewRightThumb.highlighted");
        
        CGFloat fNewValue = [self returnChangedRightThumbValue:(touchPoint.x - fRightThumbOffset)];
        //오른쪽 Thumb과 겹치지 않기 위해
        CGFloat fHalfX = HALF_RIGHT_THUMB/ fWidthForValue;
        NSLog(@" NewValue: %f _lefttValue: %f new+halfX: %f", fNewValue, _leftValue, (fNewValue + (fHalfX * 2)));
        
        if (fRightThumbOffset > 0) {
            //오른쪽으로 이동
            if( _maximumValue > fNewValue )
            {
                NSLog(@"움직임");
                
                [self bringSubviewToFront:self.viewRightThumb];
                [self setRightValue:fNewValue];
                
                //이동에 따라 값을 넘겨준다.
                [self returnChangedRightThumbInfo];
            }
            else
            {
                NSLog(@"움직이지 않음");
                self.viewRightThumb.highlighted = NO;
            }
        }
        else
        {
            //왼쪽으로 이동
            if( _maximumValue > fNewValue && _leftValue < (fNewValue + (fHalfX * 2)))
            {
                NSLog(@"움직임");
                
                [self bringSubviewToFront:self.viewRightThumb];
                [self setRightValue:fNewValue];
                
                //이동에 따라 값을 넘겨준다.
                [self returnChangedRightThumbInfo];
            }
            else
            {
                NSLog(@"움직이지 않음");
                self.viewRightThumb.highlighted = NO;
            }
        }
        
    }
    
    
//    //send the control event
//    if(_continuous)
//    {
//        [self sendActionsForControlEvents:UIControlEventValueChanged];
//    }
    
    //redraw
    [self setNeedsLayout];
    
    return YES;
}



-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"%s", __FUNCTION__);
    
    self.viewLeftThumb.highlighted = NO;
    self.viewRightThumb.highlighted = NO;
    
//    if(_stepValue>0)
//    {
//        _stepValueInternal=_stepValue;
//        
//        [self setLowerValue:_lowerValue animated:YES];
//        [self setUpperValue:_upperValue animated:YES];
//    }
//    
//    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma -mark re-set Thumbs
- (CGFloat)returnChangedLeftThumbValue:(CGFloat)x
{
    NSLog(@"%s", __FUNCTION__);
    //왼쪽 Thumbdml X는 0보다 크고 오른쪽 Thumb 보다 작아야 한다
    CGFloat fHalf = _viewLeftThumb.frame.size.width / 2;
    CGFloat value = _minimumValue + (x -fHalf) / (self.frame.size.width - (fHalf * 2)) * (_maximumValue - _minimumValue);
    
    value = MAX(value, _minimumValue);
    value = MIN(value, _rightValue);
    
    NSLog(@"Left Changed Value: %f", value);
    return value;
}

- (CGFloat)returnChangedRightThumbValue:(CGFloat)x
{
    NSLog(@"%s", __FUNCTION__);

    CGFloat fHalf = _viewRightThumb.frame.size.width / 2;
    CGFloat value = _minimumValue + (x -fHalf) / (self.frame.size.width - (fHalf * 2)) * (_maximumValue - _minimumValue);
    
    value = MIN(value, _maximumValue);
    value = MAX(value, _leftValue);
    
    NSLog(@"Right Changed Value: %f", value);
    
    return value;
}

#pragma mark - 
- (void) returnChangedLeftThumbInfo
{
     NSLog(@"%s", __FUNCTION__);
    
    if ([self.delegate respondsToSelector:@selector(changeLeftThumbValue:)])
        [self.delegate changeLeftThumbValue:_leftValue];
    
    if ([self.delegate respondsToSelector:@selector(changeLeftThumbValue:CenterPoint:)])
        [self.delegate changeLeftThumbValue:_leftValue CenterPoint:self.viewLeftThumb.frame.origin];
}

- (void) returnChangedRightThumbInfo
{
    NSLog(@"%s", __FUNCTION__);
    
    if ([self.delegate respondsToSelector:@selector(changeRightThumbValue:)])
        [self.delegate changeRightThumbValue:_rightValue];
    
    if ([self.delegate respondsToSelector:@selector(changeLeftThumbValue:CenterPoint:)])
        [self.delegate changeRightThumbValue:_rightValue CenterPoint:self.viewRightThumb.frame.origin];
}

@end
