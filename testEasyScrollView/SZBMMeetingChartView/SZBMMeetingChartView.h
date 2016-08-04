//
//  SZBMMeetingChartView.h
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import <UIKit/UIKit.h>


#define WINDOW_WIDTH        [[UIScreen mainScreen] bounds].size.width

#define SZBMMeetingChartView_left_width                                        100
#define SZBMMeetingChartView_left_right_pading                                 0
#define SZBMMeetingChartView_total_left (SZBMMeetingChartView_left_width +     SZBMMeetingChartView_left_right_pading)


// 一个单位刻度宽度
#define SZBMMeetingChartView_rules_unit                                        50
// 图表包含多少小时
#define SZBMMeetingChartView_hours                                             24
// 图表区占用宽度
#define SZBMMeetingChartView_chart_width    (SZBMMeetingChartView_rules_unit * SZBMMeetingChartView_hours)
#define SZBMMeetingChartView_chart_height                                      40
#define SZBMMeetingChartView_right_pading                                      10

@interface SZBMMeetingChartView : UIView





@end
