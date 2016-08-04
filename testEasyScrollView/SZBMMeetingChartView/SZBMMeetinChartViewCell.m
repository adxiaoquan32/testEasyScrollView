//
//  SZBMMeetinChartViewCell.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/4/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMMeetinChartViewCell.h"

@interface SZBMMeetinChartViewCell()
@property (nonatomic,strong)szbmMeetingChartData *chartData;


@end




@implementation SZBMMeetinChartViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        
        [self _initData];
    }
    
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)_initData
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

- (void)setCellData:(id)data
{
    if ( data )
    {
        szbmMeetingChartData *chartData = (szbmMeetingChartData*)data;
        self.chartData = chartData;
    }
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect: rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    float f_startDraw_y = (CGRectGetHeight(rect) - SZBMMeetingChartView_chart_view_height)/2;
    
    for ( szbmMeetingSchedule *schedulOb in self.chartData.schedules)
    {
        float f_start_time = [self _getStartTimeline:schedulOb];
        
        float f_startDraw_x = (f_start_time - SZBMMeetingChartView_hours_begin_time) * (SZBMMeetingChartView_rules_width_unit/60.0f);
        float f_startDraw_w = schedulOb.nLastTimeLong * (SZBMMeetingChartView_rules_width_unit/60.0f);
        
        UIColor *fileclickcore = SZBMMeetingChartView_chart_view_color;
        UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(f_startDraw_x, f_startDraw_y, f_startDraw_w, SZBMMeetingChartView_chart_view_height) cornerRadius:2.0f];
        CGContextSetFillColorWithColor(context, fileclickcore.CGColor);
        [roundedPath fill];
        
    }
    
    NSLog(@"\n\n\n______end_____");
    
}

//
- (float)_getStartTimeline:( szbmMeetingSchedule * )schedulOb
{
    //给一个时间秒数,取出对应的时间
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:schedulOb.startTimeInterval];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm"];
    NSString *showtimeNew = [formatter1 stringFromDate:d];
    NSArray *timearr = [showtimeNew componentsSeparatedByString:@":"];
    
    NSLog(@"___time:%@ timelong:%ld",showtimeNew,(long)schedulOb.nLastTimeLong);
    
    if ( [timearr count] >= 2 )
    {
        return [[timearr objectAtIndex:0] integerValue] * 60 + [[timearr objectAtIndex:1] integerValue];
    }
    
    return -1;
}



@end
