//
//  SZBMMeetingTimeRulesHeaderView.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMMeetingTimeRulesHeaderView.h"

@interface SZBMMeetingTimeRulesHeaderView()

@property(nonatomic,assign)enSZBMRulesHours enHours;
@property(nonatomic,strong)NSMutableArray *titleArr;

@end



@implementation SZBMMeetingTimeRulesHeaderView

- (instancetype)initWithFrame:(CGRect)frame withHours:(enSZBMRulesHours)hours
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _enHours = MAX(1, hours);
        _titleArr = [[NSMutableArray alloc] init];
        
        NSArray *beingAddedArr = nil;
        switch ( _enHours )
        {
            case enSZBMRulesHours_8h:
            {
                beingAddedArr = @[@"8:30",@"9:30",@"10:30",@"11:30",@"12:30",@"13:30",@"14:30",@"15:30",@"16:30",@"17:30"];
                break;
            }
            case enSZBMRulesHours_24h:
            {
                beingAddedArr = @[@"0:30",@"1:30",@"2:30",@"3:30",@"4:30",@"5:30",@"6:30",@"7:30",@"8:30",@"9:30",@"10:30",@"11:30",@"12:30",@"13:30",@"14:30",@"15:30",@"16:30",@"17:30",@"18:30",@"19:30",@"20:30",@"21:30",@"22:30",@"23:30"];
                break;
            }
            default:
                break;
        }
        
        
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Drawing code
    [super drawRect:rect];
    
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    float f_width_per_hour = CGRectGetWidth(rect)/(_enHours==enSZBMRulesHours_8h?8:24);
    
    // test
    UIFont *textFont = [UIFont systemFontOfSize:13.0f];
    NSString *textBody = @"8:30";
    NSDictionary *attr = @{NSFontAttributeName:textFont};
    CGSize fontSize = [textBody sizeWithAttributes:attr];
    
    NSLog(@" ___%f %f %f",f_width_per_hour,fontSize.width,fontSize.height);
    
    [textBody drawAtPoint:CGPointMake((f_width_per_hour - fontSize.width)/2.0f, (CGRectGetHeight(rect) - fontSize.height)/2.0f) withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
    
    
}


@end
