//
//  SZBMMeetingChartView.h
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZBMMeetingChartViewHeader.h"


#define SZBMMeetingChartView_total_left (SZBMMeetingChartView_left_width +     SZBMMeetingChartView_left_right_pading)

// 图表区占用宽度
#define SZBMMeetingChartView_chart_width    (SZBMMeetingChartView_rules_width_unit * SZBMMeetingChartView_hours)


typedef void(^SZBMMeetingChartViewTimeSBack)(NSInteger nMbeginTimeMins);


@interface SZBMMeetingChartView : UIView

/**
 *  设置会议时长
 *
 *  @param minitues 分钟
 */
- (void)setMeetingTimeLong:(float)minitues;

/**
 *  实时返回滚动后的时间
 *
 *  @param callBacBlock SZBMMeetingChartViewTimeSBack
 */
- (void)setTimeSelectedCallBack:(SZBMMeetingChartViewTimeSBack)callBacBlock;

/**
 *  设置用户的日程数据
 *
 *  @param datas datas description
 */
- (void)loadChartData:(NSArray *)datas;


@end
