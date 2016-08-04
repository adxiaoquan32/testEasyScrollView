//
//  SZBMMeetinChartView_TestOb.h
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/4/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZBMMeetinChartView_TestOb : NSObject

@end



/**
 *  testing object
 */

@interface szbmMeetingSchedule : NSObject

@property (nonatomic,strong) NSString       *title;
@property (nonatomic,assign) NSTimeInterval startTimeInterval;
@property (nonatomic,assign) NSInteger      nLastTimeLong;


@end


@interface szbmMeetingChartData : NSObject

@property (nonatomic,strong) NSString       *userName;
@property (nonatomic,strong) NSArray        *schedules;

@end



#define szbmGetResourcePath ([[NSBundle mainBundle] resourcePath])



/*
 
 [{"userName":"张三","schedules":[{"title":"s1","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470289800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470289800","nLastTimeLong":"40"}]},
 {"userName":"张三","schedules":[{"title":"s1","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470289800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470289800","nLastTimeLong":"40"}]},
 {"userName":"张三","schedules":[{"title":"s1","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470289800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470289800","nLastTimeLong":"40"}]},
 {"userName":"张三","schedules":[{"title":"s1","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470271800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470289800","nLastTimeLong":"40"},{"title":"xxx","startTimeInterval":"1470289800","nLastTimeLong":"40"}]}]
 
 
 */
