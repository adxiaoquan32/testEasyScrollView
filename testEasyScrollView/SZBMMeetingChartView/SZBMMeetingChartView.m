//
//  SZBMMeetingChartView.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMMeetingChartView.h"
#import "SZBMMeetingTimeRulesHeaderView.h"
#import "SZBMMeetinChartViewCell.h"
#import "SZBMMeetinChartViewNameCell.h"
#import "SZBMTimelongView.h"

// addind a slider optional view
#import "SZBMChartSliderView.h"

@interface SZBMMeetingChartView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    
    float _f_begining_time;
    
    BOOL __broopingMove;
    
    BOOL __bMoveEnable;
    
    NSInteger _nCurrentMode; //1:不留边模式 2:留边模式
    
}


@property (nonatomic,strong) UIScrollView                  *horizonalScrollView;
@property (nonatomic,strong) UITableView                   *leftTbView;
@property (nonatomic,strong) UITableView                   *rightTbView;

@property (nonatomic,strong) SZBMTimelongView              *timeLongView;


@property (nonatomic,strong) NSMutableArray                *chartDataArr;
@property (nonatomic,strong) NSArray                       *timeTitleArr;

@property (nonatomic,copy  ) SZBMMeetingChartViewTimeSBack timeCallBackBlock;
@property (nonatomic,strong) SZBMChartSliderView *sliderView                    ;


@end



@implementation SZBMMeetingChartView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.clipsToBounds                                  = YES;
        __bMoveEnable                                       = SZBMMeetingChartView_TimelongMoveEnable;
        _nCurrentMode                                       = __bMoveEnable?1:2;

        // 2 init left part of uitableview using as user name showing
        CGRect rt                                           = self.bounds;
        rt.size.width                                       = SZBMMeetingChartView_left_width;
        _leftTbView                                         = [[UITableView alloc] initWithFrame:rt style:UITableViewStylePlain];
        _leftTbView.dataSource                              = self;
        _leftTbView.delegate                                = self;
        _leftTbView.rowHeight                               = SZBMMeetingChartView_chart_height;
        _leftTbView.showsVerticalScrollIndicator            = NO;
        _leftTbView.showsHorizontalScrollIndicator          = NO;
        _leftTbView.separatorStyle                          = UITableViewCellSeparatorStyleNone;
        _leftTbView.backgroundColor                         = [UIColor clearColor];
        [self addSubview:_leftTbView];


        // 1 init horizonal scrollivew
        rt                                                  = self.bounds;
        rt.origin.x                                         = SZBMMeetingChartView_total_left;
        rt.size.width                                       = (rt.size.width - rt.origin.x);
        _horizonalScrollView                                = [[UIScrollView alloc] initWithFrame:rt];
        _horizonalScrollView.delegate                       = self;
        _horizonalScrollView.showsVerticalScrollIndicator   = NO;
        _horizonalScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_horizonalScrollView];


        // 3 init rigth part of uitableview using for chart showing
        rt                                                  = self.bounds;
        rt.origin.x                                         = __bMoveEnable?0.0:(WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2;
        rt.size.width                                       = [self _SZBMMeetingChartView_chart_width];
        _rightTbView                                        = [[UITableView alloc] initWithFrame:rt style:UITableViewStylePlain];
        _rightTbView.dataSource                             = self;
        _rightTbView.delegate                               = self;
        _rightTbView.rowHeight                              = SZBMMeetingChartView_chart_height;
        _rightTbView.showsVerticalScrollIndicator           = NO;
        _rightTbView.showsHorizontalScrollIndicator         = NO;
        _rightTbView.separatorStyle                         = UITableViewCellSeparatorStyleNone;
        _rightTbView.backgroundColor                        = [UIColor clearColor];
        [_horizonalScrollView addSubview:_rightTbView];


        // setting horizon contensize
        if ( __bMoveEnable )
        {
            [_horizonalScrollView setContentSize:CGSizeMake([self _SZBMMeetingChartView_chart_width] , 0)];
        }
        else
        {
            [_horizonalScrollView setContentSize:CGSizeMake([self _liubaiScrollivewContentSizeWidth], 0)];
        }


        // set up timelongview
        rt                                                  = self.bounds;
        rt.origin.y                                         = SZBMMeetingChartView_chart_head_height;
        rt.size.height                                      -= SZBMMeetingChartView_chart_head_height;
        rt.size.width                                       = 0;
        _timeLongView                                       = [[SZBMTimelongView alloc] initWithFrame:rt];
        _timeLongView.center                                = CGPointMake(self.center.x + SZBMMeetingChartView_total_left/2, _timeLongView.center.y);
        [_timeLongView setMaxLeftX:CGRectGetMaxX(_leftTbView.frame)];
        {
            __weak __typeof(self)weakSelf = self;
            [_timeLongView setSZBMTimelongViewCallBack:^(CGRect frame,BOOL finish) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf _respondseTimeLongCallBack:frame finish:finish];
            }];
            
        }
        [self addSubview:_timeLongView];


        // testing
        rt                                                  = self.bounds;
        rt.size.height                                      = 60;
        rt.origin.y                                         = CGRectGetHeight(self.bounds) - 20 - rt.size.height;
        rt.size.width                                       = 200;
        rt.origin.x                                         = (CGRectGetWidth(self.bounds) - CGRectGetWidth(rt))/2;
        _sliderView                                         = [[SZBMChartSliderView alloc] initWithFrame:rt];
        [self addSubview:_sliderView];
        
        
        __weak __typeof(self)weakSelf = self;
        [_sliderView setTimeLongCallBack:^(NSInteger nMeetingTime) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf _adjustTimelongFrame:nMeetingTime];
            [strongSelf scrollViewDidScroll:strongSelf.horizonalScrollView];
            [strongSelf _detectScrollivewStopMoving:strongSelf.horizonalScrollView];
            
        }];
        
        

        _chartDataArr                        = [[NSMutableArray alloc] init];


        self.timeTitleArr                    = SZBMMeetingChartView_hours_title;
        _f_begining_time                     = SZBMMeetingChartView_hours_begin_time;
        CGFloat f_init_offset_x = __bMoveEnable?0.0f:(WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2;
        [_horizonalScrollView setContentOffset:CGPointMake(f_init_offset_x, 0)];

 
        _horizonalScrollView.backgroundColor = [UIColor clearColor];
        
        __broopingMove = NO;
        
    }
    return self;
}

/**
 *  设置会议时长
 *
 *  @param minitues 分钟
 */
- (void)setMeetingTimeLong:(NSInteger)minitues
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_sliderView initMeetingTime:minitues];

        [self _adjustTimelongFrame:minitues];
        
        [self scrollViewDidScroll:self.horizonalScrollView];
        
        [self _detectScrollivewStopMoving:self.horizonalScrollView];
        
    });
    
}

/**
 *  设置会议时间
 *
 *  @param startTime 会议开始时间GTM
 *  @param minitues  会议时长
 */
- (void)setMeetingTime:(NSTimeInterval)startTime timeLong:(NSInteger)minitues
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_sliderView initMeetingTime:minitues];
        
        [self _adjustTimelongFrame:minitues];
        
        // moving content set to a visible area
        [self _adjustMeetingStartTime:startTime timeLong:minitues];
        
        [self _judgeTimeSelectedFunc];
        
        [self _detectScrollivewStopMoving:self.horizonalScrollView];
        
    });
    
    
}

// 
- (void)_adjustMeetingStartTime:(NSTimeInterval)startTime timeLong:(NSInteger)minitues
{
    // 第分钟占用的宽度
    float f_widthPerMin = SZBMMeetingChartView_rules_width_unit/(SZBMMeetingChartView_rules_width_unit_minitues*1.0f);
    
    // 时间起始位置
    float fbeginMinPosition = ([SZBMMeetingChartViewHeader getMinituesFromGMT:startTime] - SZBMMeetingChartView_hours_begin_time)*f_widthPerMin;
    
    // 时长view在时间图表的有效宽度
    NSInteger n_distanceIntbview = (minitues * f_widthPerMin);
    
    //1:不留边模式 2:留边模式
    if ( _nCurrentMode == 2 )
    {
        // 相对时间的起点
        float f_start_time_point_x = CGRectGetMinX(_rightTbView.frame) + fbeginMinPosition + n_distanceIntbview/2.0;
        float foffset_x = f_start_time_point_x - CGRectGetWidth(_horizonalScrollView.frame)/2.0;
        
        // just scroll horizenal scrollview to position
        [_horizonalScrollView setContentOffset:CGPointMake(foffset_x, _horizonalScrollView.contentOffset.y)];
    }
    else
    {
        CGRect timeLongViewFrameInScrollview_rt = [self convertRect:_timeLongView.frame toView:_horizonalScrollView];
        
        // 相对时间的起点
        float f_start_time_point_x = CGRectGetMinX(_rightTbView.frame) + fbeginMinPosition;
        
        // || f_start_time_point_x + n_distanceIntbview == _timeLongView(min_x) + _horizonalScrollView.contentOffset.x ? ||;
        float f_need_offset_x = f_start_time_point_x + n_distanceIntbview - CGRectGetMinX(timeLongViewFrameInScrollview_rt);
        
        if ( f_need_offset_x >= 0.0 &&
            f_need_offset_x <= _horizonalScrollView.contentSize.width - CGRectGetWidth(_horizonalScrollView.frame) )
        {
            // 默认绿条放中间，scrollview 随着移动
            _timeLongView.center = CGPointMake(self.center.x + SZBMMeetingChartView_total_left/2, _timeLongView.center.y);
            
            [_horizonalScrollView setContentOffset:CGPointMake(f_need_offset_x - n_distanceIntbview/2, _horizonalScrollView.contentOffset.y)];
        }
        else if( f_need_offset_x < 0.0 )
        {
            [_horizonalScrollView setContentOffset:CGPointMake(0, _horizonalScrollView.contentOffset.y)];
            // scrollview 没办法移动到正确位置时，再移动绿条到相对位置
            // || f_start_time_point_x + n_distanceIntbview == _timeLongView(min_x) ? + _horizonalScrollView.contentOffset.x(0) ||;
            float f_timeLongPostion_x = f_start_time_point_x + n_distanceIntbview - 0;
            _timeLongView.center = CGPointMake(f_timeLongPostion_x + CGRectGetMinX(_horizonalScrollView.frame) - CGRectGetWidth(_timeLongView.bounds)/2, _timeLongView.center.y);
            
        }
        else
        {
            float f_offset_x = _horizonalScrollView.contentSize.width - CGRectGetWidth(_horizonalScrollView.frame);
            [_horizonalScrollView setContentOffset:CGPointMake(f_offset_x, _horizonalScrollView.contentOffset.y)];
            
            // scrollview 没办法移动到正确位置时，再移动绿条到相对位置
            // || f_start_time_point_x + n_distanceIntbview == _timeLongView(min_x) ? + _horizonalScrollView.contentOffset.x(0) ||;
            float f_timeLongPostion_x = f_start_time_point_x + n_distanceIntbview - f_offset_x;
            _timeLongView.center = CGPointMake(f_timeLongPostion_x + CGRectGetMinX(_horizonalScrollView.frame) - CGRectGetWidth(_timeLongView.bounds)/2, _timeLongView.center.y);
        }
    }
}


- (void)_adjustTimelongFrame:(NSInteger)minitues
{
    
    float v_width = SZBMMeetingChartView_rules_width_unit * (minitues/60.0f);
    CGRect rt = _timeLongView.frame;
    rt.size.width = v_width;
    if ( CGRectGetMaxX(rt) > CGRectGetMaxX(self.bounds)) {
        rt.origin.x = CGRectGetMaxX(self.bounds) - CGRectGetWidth(rt);
    }
    _timeLongView.frame = rt;
    
 
    if ( v_width < SZBMMeetingChartView_TimelongMoveMinWidth )
    {
        // 使用留白做法
        _timeLongView.moveEnable = NO;
        __bMoveEnable = NO;
        
        if ( _nCurrentMode != 2 )
        {
            rt = _rightTbView.frame;
            float f_movingdis = rt.origin.x;
            rt.origin.x =  (WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2;
            f_movingdis = (WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2 - f_movingdis;
            
            _rightTbView.frame = rt;
            [_horizonalScrollView setContentSize:CGSizeMake( [self _liubaiScrollivewContentSizeWidth], 0)];
            [_horizonalScrollView setContentOffset:CGPointMake(_horizonalScrollView.contentOffset.x + f_movingdis, _horizonalScrollView.contentOffset.y)];
            
            _nCurrentMode = 2;
        }
        
    }
    else
    {
        // 不使用留白做法
        _timeLongView.moveEnable = YES;
        __bMoveEnable = YES;
        
        if ( _nCurrentMode != 1 )
        {
            
            rt = _rightTbView.frame;
            float f_movingdis = rt.origin.x;   
            rt.origin.x =  0;
            float f_offset_x = MAX(0, _horizonalScrollView.contentOffset.x - f_movingdis);
            
            _rightTbView.frame = rt;
            [_horizonalScrollView setContentSize:CGSizeMake([self _SZBMMeetingChartView_chart_width], 0)];
            [_horizonalScrollView setContentOffset:CGPointMake(f_offset_x, _horizonalScrollView.contentOffset.y)];
            
            _nCurrentMode = 1;
        }
        
    }
    
    if ( !__bMoveEnable)
    {
        _timeLongView.center = CGPointMake(self.center.x + SZBMMeetingChartView_total_left/2, _timeLongView.center.y);
    }
    
}

- (float)_liubaiScrollivewContentSizeWidth
{
    return [self _SZBMMeetingChartView_chart_width] + (WINDOW_WIDTH - SZBMMeetingChartView_left_width);
}

/**
 *  实时返回滚动后的时间
 *
 *  @param callBacBlock SZBMMeetingChartViewTimeSBack
 */
- (void)setTimeSelectedCallBack:(SZBMMeetingChartViewTimeSBack)callBacBlock
{
    _timeCallBackBlock = NULL;
    _timeCallBackBlock = [callBacBlock copy];
    
}

/**
 *  设置用户的日程数据
 *
 *  @param datas datas description
 */
- (void)loadChartData:(NSArray *)datas
{
    [_chartDataArr removeAllObjects];
    
    if ( datas ) {
        [_chartDataArr addObjectsFromArray:datas];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_leftTbView reloadData];
        [_rightTbView reloadData];

    });
    
}


#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?SZBMMeetingChartView_chart_head_height:0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 0 &&
        tableView == _rightTbView)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), SZBMMeetingChartView_chart_head_height)];
        view.backgroundColor = [UIColor clearColor];
        SZBMMeetingTimeRulesHeaderView *hview = [[SZBMMeetingTimeRulesHeaderView alloc] initWithFrame:view.bounds withTitles:self.timeTitleArr];
        hview.layer.cornerRadius = 10.0f; 
        hview.layer.masksToBounds = YES;
        hview.backgroundColor = [UIColor whiteColor];
        [view addSubview:hview];
        
        return view;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0?[_chartDataArr count]:0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *stringClassName = _leftTbView == tableView?NSStringFromClass([SZBMMeetinChartViewNameCell class]): NSStringFromClass([SZBMMeetinChartViewCell class]);
    
    //NSLog(@"___identify:%@",stringClassName);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stringClassName];
    if (cell == nil)
    {
        cell = [[NSClassFromString(stringClassName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringClassName] ;
    }
    
    if ( [cell respondsToSelector:@selector(setCellData:)]) {
        [cell performSelector:@selector(setCellData:) withObject:[_chartDataArr objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}

#pragma mark UITableViewDataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{ 
    if ( scrollView == _leftTbView)
    {
        CGPoint point = _rightTbView.contentOffset; point.y = scrollView.contentOffset.y;
        [_rightTbView setContentOffset:point];
        
    }
    else if( scrollView == _rightTbView )
    {
        
        CGPoint point = _leftTbView.contentOffset; point.y = scrollView.contentOffset.y;
        [_leftTbView setContentOffset:point];
    }
    
    // detect distance and offset
    if ( _horizonalScrollView == scrollView )
    {
        [self _judgeTimeSelectedFunc];
    }
}

- (float) _SZBMMeetingChartView_chart_width
{
    NSArray *arrtime = SZBMMeetingChartView_hours_title;
    return  (SZBMMeetingChartView_rules_width_unit * [arrtime count]);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self _detectScrollivewStopMoving:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _detectScrollivewStopMoving:scrollView];
}

- (void)_detectScrollivewStopMoving:(UIScrollView *)scrollView
{
    // --------------------------------------------------
    
    if ( scrollView != _horizonalScrollView ) {
        return;
    }
    
    CGRect rtInSuper = [self _getRightTbviewSuperViewPosition];
    
    if ( CGRectGetMinX(rtInSuper) > CGRectGetMinX(_timeLongView.frame) )
    {
        float f_tozero = CGRectGetMinX(_timeLongView.frame) - CGRectGetMinX(_horizonalScrollView.frame);
        float f_offset = CGRectGetMinX(_rightTbView.frame) - f_tozero;
        [scrollView setContentOffset:CGPointMake(f_offset, 0) animated:YES];
    }
    else if( CGRectGetMaxX(rtInSuper) < CGRectGetMaxX(_timeLongView.frame) )
    {
        CGRect rt = [self convertRect:_timeLongView.frame toView:_horizonalScrollView];
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x - (CGRectGetMaxX(rt) - CGRectGetMaxX(_rightTbView.frame)), 0) animated:YES];
    }
}

- (CGRect)_getRightTbviewSuperViewPosition
{
    return [_horizonalScrollView convertRect:_rightTbView.frame toView:self];
}

/**
 *  计算会议开始的时间并返回
 */
- (void)_judgeTimeSelectedFunc
{
    CGRect rtInSuper = [self _getRightTbviewSuperViewPosition];
    float f_inside_x = CGRectGetMinX(_timeLongView.frame) - CGRectGetMinX(rtInSuper) ;
    
    if ( f_inside_x >= 0 &&
        f_inside_x <= [self _SZBMMeetingChartView_chart_width])
    {
        // 时长view在时间图表的有效位置
        NSInteger n_increace_miniues = f_inside_x/SZBMMeetingChartView_rules_width_unit*SZBMMeetingChartView_rules_width_unit_minitues;
        // 针对 时间刻度进来取舍
        NSInteger n_return_minitues = floor((n_increace_miniues + SZBMMeetingChartView_rules_unit/2.0)/SZBMMeetingChartView_rules_unit)*SZBMMeetingChartView_rules_unit + _f_begining_time;
        
        if (_timeCallBackBlock) {
            _timeCallBackBlock(n_return_minitues);
        }
    }
}

/**
 *  绿条移动后的检测
 *
 *  @param frame 绿条的frame
 */
- (void)_respondseTimeLongCallBack:(CGRect)frame finish:(BOOL)finish
{
    
    float f_moving_speed = 0.0;
    
    // 接近到多少开始启动
    float f_start_closing_distancing = 2.0f;
    
    // 速度系数，越小越快
    float f_speed_xishu = 30.0f;
    if ( CGRectGetMinX(frame) < CGRectGetMaxX(_leftTbView.frame) + f_start_closing_distancing ) {
        // to the left
        f_moving_speed = (CGRectGetMinX(frame) - (CGRectGetMaxX(_leftTbView.frame) + f_start_closing_distancing))/f_speed_xishu;
    }
    else if ( CGRectGetMaxX(frame) > CGRectGetMaxX(self.bounds) - f_start_closing_distancing )
    {
        // to the right
        f_moving_speed = (CGRectGetMaxX(frame) - (CGRectGetMaxX(self.bounds) - f_start_closing_distancing))/f_speed_xishu;
    }
    
    
    if (  f_moving_speed == 0.0 )
    {
        [_horizonalScrollView.layer removeAllAnimations];
        __broopingMove = NO;
        // judging
        [self _judgeTimeSelectedFunc];
    }
    else
    {
        // moving horizenall scrollview
        __broopingMove = YES;
        [self _movingBySpeedSet:f_moving_speed];
       
    }
    
    if ( finish ) {
        [_horizonalScrollView.layer removeAllAnimations];
        __broopingMove = NO;
    }
    
}

- (void)_movingBySpeedSet:(CGFloat)x
{
    [_horizonalScrollView.layer removeAllAnimations];
    
    if ( !__broopingMove) {
        return;
    }
    
    float f_time = 0.3f;
    float f_widthPersec = 10;
    float f_position = f_time*f_widthPersec*x;
    
    [UIView animateWithDuration:f_time
                     animations:^{
                         CGFloat f_offset = MAX(0, _horizonalScrollView.contentOffset.x + f_position);
                         f_offset = MIN(_horizonalScrollView.contentSize.width - CGRectGetWidth(_horizonalScrollView.bounds), f_offset);
                         [_horizonalScrollView setContentOffset:CGPointMake(f_offset, _horizonalScrollView.contentOffset.y)];
                     }
                     completion:^(BOOL finished){
                         if ( _horizonalScrollView.contentOffset.x <= 0.0 ||
                              _horizonalScrollView.contentOffset.x > _horizonalScrollView.contentSize.width - CGRectGetWidth(_horizonalScrollView.bounds))
                         {
                             __broopingMove = NO;
                         }
                         [self _movingBySpeedSet:x];
                     }];
}



@end
