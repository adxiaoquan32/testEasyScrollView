//
//  SZBMChartSliderView.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/6/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMChartSliderView.h"


@interface SZBMChartSliderView()

@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,strong)UILabel *meetTimeLabel;

@property (nonatomic,copy) SZBMChartSliderViewTimeLong timeCallBackBlock;

@end

@implementation SZBMChartSliderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        //self.alpha = 0.5f;
        
        CGRect rt = self.bounds;
        rt.size.height = 21;
        _meetTimeLabel  = [[UILabel alloc] initWithFrame:rt];
        _meetTimeLabel.text = @"";
        _meetTimeLabel.font = [UIFont boldSystemFontOfSize:16];
        _meetTimeLabel.textColor = [UIColor redColor];
        _meetTimeLabel.textAlignment = NSTextAlignmentCenter;
        _meetTimeLabel.adjustsFontSizeToFitWidth = YES;
        _meetTimeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_meetTimeLabel];
        
        rt = self.bounds;
        rt.origin.y = CGRectGetHeight(_meetTimeLabel.bounds);
        rt.size.height = CGRectGetHeight(frame) - CGRectGetHeight(_meetTimeLabel.bounds);
        
        _slider = [[UISlider alloc] initWithFrame:rt];
        _slider.minimumValue = 0;
        _slider.maximumValue = SZBMChartSliderView_maximum;
        _slider.value = SZBMChartSliderView_maximum/2;
        UIColor *color = [UIColor brownColor];
        _slider.minimumTrackTintColor = color;
        _slider.maximumTrackTintColor = color;
        [self addSubview:_slider];
        
        [_slider addTarget:self action:@selector(slide:)forControlEvents:UIControlEventValueChanged];
        
        
    }
    return self;
}

/**
 *  初始开会时长
 *
 *  @param minitues NSInteger
 */
- (void)initMeetingTime:(NSInteger)minitues
{
    _slider.value = (minitues/(SZBMChartSliderView_maximum_time*60.0f)) * SZBMChartSliderView_maximum;
    [self _updateTimeLabel];
    
    //NSLog(@"___s:%ld %f",(long)minitues,_slider.value);
}


/**
 *  开会时长回调
 *
 *  @param callBacBlock callBacBlock description
 */
- (void)setTimeLongCallBack:(SZBMChartSliderViewTimeLong)callBacBlock
{
    _timeCallBackBlock = NULL;
    _timeCallBackBlock = [callBacBlock copy];
}

#pragma mark - KVO

- (void)slide:( id )sender
{
 
    [self _updateTimeLabel];
    
}

- (void)_updateTimeLabel
{
    
    CGRect rt = [_slider thumbRectForBounds:_slider.bounds
                                  trackRect:[_slider trackRectForBounds:_slider.bounds]
                                      value:_slider.value];
    
    _meetTimeLabel.center = CGPointMake(rt.origin.x + rt.size.width/2, _meetTimeLabel.center.y);
    //NSLog(@"____%f_%f_",rt.origin.x,rt.size.width);
    
    
    NSInteger nmeetingTime = _slider.value/SZBMChartSliderView_maximum * (SZBMChartSliderView_maximum_time*60);
    NSInteger n_return_minitues = floor((nmeetingTime + SZBMMeetingChartView_rules_unit/2.0)/SZBMMeetingChartView_rules_unit)*SZBMMeetingChartView_rules_unit ;
    NSInteger nmeeting = MAX(SZBMMeetingChartView_rules_unit, n_return_minitues);
    if (_timeCallBackBlock) {
        _timeCallBackBlock(nmeeting);
    }
    
    _meetTimeLabel.text = [NSString stringWithFormat:@"时长:%ld",(long)nmeeting];
    
    //NSLog(@"___time:%ld %ld %ld ",(long)nmeetingTime,(long)n_return_minitues,(long)nmeeting);
    
}



@end
