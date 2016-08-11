//
//  SZBMMeetingChartViewHeader.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/10/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMMeetingChartViewHeader.h"

@implementation SZBMMeetingChartViewHeader


/**
 *  将GMT抽出时间成分转成分钟
 *
 *  @param timeinterval GMT 秒
 *
 *  @return 返回分钟
 */
+ (float)getMinituesFromGMT:( NSTimeInterval )timeinterval
{
    //给一个时间秒数,取出对应的时间
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:timeinterval];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm"];
    NSString *showtimeNew = [formatter1 stringFromDate:d];
    NSArray *timearr = [showtimeNew componentsSeparatedByString:@":"];
    
    NSLog(@"__time:%@",showtimeNew);
    
    if ( [timearr count] >= 2 )
    {
        return [[timearr objectAtIndex:0] integerValue] * 60 + [[timearr objectAtIndex:1] integerValue];
    }
    
    return -1;
}




@end