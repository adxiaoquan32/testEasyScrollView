//
//  SZBMChartSliderView.h
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/6/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZBMMeetingChartViewHeader.h"

#define SZBMChartSliderView_maximum 100

// 最大时间调整范围
#define SZBMChartSliderView_maximum_time 5


typedef void(^SZBMChartSliderViewTimeLong)(NSInteger nMeetingTime);


@interface SZBMChartSliderView : UIView

/**
 *  初始开会时长
 *
 *  @param minitues NSInteger
 */
- (void)initMeetingTime:(NSInteger)minitues;


/**
 *  开会时长回调
 *
 *  @param callBacBlock callBacBlock description
 */
- (void)setTimeLongCallBack:(SZBMChartSliderViewTimeLong)callBacBlock;




@end
