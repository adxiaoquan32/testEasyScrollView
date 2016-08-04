//
//  SZBMMeetingTimeRulesHeaderView.h
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, enSZBMRulesHours)
{
    enSZBMRulesHours_8h     = 0,
    enSZBMRulesHours_24h,
    enSZBMRulesHours_ALL
};



@interface SZBMMeetingTimeRulesHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame withHours:(enSZBMRulesHours)hours;


@end
