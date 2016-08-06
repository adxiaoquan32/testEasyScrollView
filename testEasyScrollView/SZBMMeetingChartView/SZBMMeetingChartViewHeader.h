//
//  SZBMMeetingChartViewHeader.h
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/4/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

// just fot test data defining
#import "SZBMMeetinChartView_TestOb.h"


#ifndef SZBMMeetingChartViewHeader_h
#define SZBMMeetingChartViewHeader_h


#define WINDOW_WIDTH        [[UIScreen mainScreen] bounds].size.width

#define RGB(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)/255.0f]

// 左部分名字区域的宽度
#define SZBMMeetingChartView_left_width            80

// 左边tableview 和 右边tablveivew 之间留白的宽度
#define SZBMMeetingChartView_left_right_pading     0

// 一个单位刻度宽度
#define SZBMMeetingChartView_rules_width_unit      60
// 一个刻度单位间隔为5分钟
#define SZBMMeetingChartView_rules_unit            5

// 每一个图表数据cell占的高度
#define SZBMMeetingChartView_chart_height          40

// 图表头部占用高度
#define SZBMMeetingChartView_chart_head_height     40

// 画图表的高度
#define SZBMMeetingChartView_chart_view_height     20

// 画图表的颜色
#define SZBMMeetingChartView_chart_view_color      RGB(48, 138, 60, 255)

// 画图表背影的颜色
#define SZBMMeetingChartView_chart_view_bgcolor    RGB(255, 255, 255, 255)

// 时间轴开始的时间
#define SZBMMeetingChartView_hours_begin_time      0   //8*60  //0

// 时间轴显示分隔时间
#define SZBMMeetingChartView_hours_title @[@"0:30",@"1:30",@"2:30",@"3:30",@"4:30",@"5:30",@"6:30",@"7:30",@"8:30",@"9:30",@"10:30",@"11:30",@"12:30",@"13:30",@"14:30",@"15:30",@"16:30",@"17:30",@"18:30",@"19:30",@"20:30",@"21:30",@"22:30",@"23:30"];

//#define SZBMMeetingChartView_hours_title @[@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00"];

 
#endif /* SZBMMeetingChartViewHeader_h */
