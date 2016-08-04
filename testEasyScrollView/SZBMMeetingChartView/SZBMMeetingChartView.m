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

@interface SZBMMeetingChartView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    float _f_begining_time;
}


@property (nonatomic,strong) UIScrollView *horizonalScrollView;
@property (nonatomic,strong) UITableView  *leftTbView;
@property (nonatomic,strong) UITableView  *rightTbView;

@property (nonatomic,strong) UIView       *timeLongView;


@property (nonatomic,strong) NSMutableArray *chartDataArr;
@property (nonatomic,strong) NSArray        *timeTitleArr;

@property (nonatomic,copy) SZBMMeetingChartViewTimeSBack timeCallBackBlock;


@end



@implementation SZBMMeetingChartView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.clipsToBounds                                  = YES;

        // 2 init left part of uitableview using as user name showing
        CGRect rt                                           = self.bounds;
        rt.size.width                                       = SZBMMeetingChartView_left_width;
        _leftTbView                                         = [[UITableView alloc] initWithFrame:rt style:UITableViewStylePlain];
        _leftTbView.dataSource                              = self;
        _leftTbView.delegate                                = self;
        _leftTbView.rowHeight                               = SZBMMeetingChartView_chart_height;
        _leftTbView.showsVerticalScrollIndicator            = NO;
        _leftTbView.showsHorizontalScrollIndicator          = NO;
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
        rt.origin.x                                         = (WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2;
        rt.size.width                                       = [self _SZBMMeetingChartView_chart_width];
        _rightTbView                                        = [[UITableView alloc] initWithFrame:rt style:UITableViewStylePlain];
        _rightTbView.dataSource                             = self;
        _rightTbView.delegate                               = self;
        _rightTbView.rowHeight                              = SZBMMeetingChartView_chart_height;
        _rightTbView.showsVerticalScrollIndicator           = NO;
        _rightTbView.showsHorizontalScrollIndicator         = NO;
        [_horizonalScrollView addSubview:_rightTbView];


        // setting horizon contensize
        [_horizonalScrollView setContentSize:CGSizeMake([self _SZBMMeetingChartView_chart_width] + (WINDOW_WIDTH - SZBMMeetingChartView_left_width), 0)];
        
        
        // set up timelongview
        rt = self.bounds;
        rt.origin.y = SZBMMeetingChartView_chart_head_height;
        rt.size.height -= SZBMMeetingChartView_chart_head_height;
        rt.size.width = 0;
        _timeLongView = [[UIView alloc] initWithFrame:rt];
        _timeLongView.backgroundColor = [UIColor blackColor];
        _timeLongView.userInteractionEnabled = NO;
        _timeLongView.alpha = 0.5f;
        _timeLongView.layer.borderWidth = 0.5f;
        _timeLongView.layer.borderColor = [UIColor redColor].CGColor;
        _timeLongView.center = CGPointMake(self.center.x + SZBMMeetingChartView_total_left/2, _timeLongView.center.y);
        [self addSubview:_timeLongView];

        _chartDataArr                                       = [[NSMutableArray alloc] init];
        
        
        self.timeTitleArr = SZBMMeetingChartView_hours_title;
        _f_begining_time = SZBMMeetingChartView_hours_begin_time;
        

        _rightTbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _horizonalScrollView.backgroundColor                = [UIColor whiteColor];
        [_horizonalScrollView setContentOffset:CGPointMake((WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2 , 0)];
    
        
        // using for test
        _rightTbView.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.1];
        
    }
    return self;
}

/**
 *  设置会议时长
 *
 *  @param minitues 分钟
 */
- (void)setMeetingTimeLong:(float)minitues
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        float v_width = SZBMMeetingChartView_rules_width_unit * (minitues/60.0f);
        CGRect rt = _timeLongView.frame;
        rt.size.width = v_width;
        _timeLongView.frame = rt;
        _timeLongView.center = CGPointMake(self.center.x + SZBMMeetingChartView_total_left/2, _timeLongView.center.y);
    });
     
    
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
        view.backgroundColor = [UIColor lightGrayColor];
        SZBMMeetingTimeRulesHeaderView *hview = [[SZBMMeetingTimeRulesHeaderView alloc] initWithFrame:view.bounds withTitles:self.timeTitleArr];
        hview.layer.cornerRadius = 10.0f; 
        hview.layer.masksToBounds = YES;
        hview.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:hview];
        
        return view;
    }
    
    return nil;
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
        float f_inside_x = scrollView.contentOffset.x - CGRectGetWidth(_timeLongView.bounds)/2;
        
        if ( f_inside_x >= 0 &&
            f_inside_x <= [self _SZBMMeetingChartView_chart_width])
        {
            // 时长view在时间图表的有效位置
            NSInteger n_increace_miniues = f_inside_x/SZBMMeetingChartView_rules_width_unit*60;
            // 针对 时间刻度进来取舍
            NSInteger n_return_minitues = floor((n_increace_miniues + SZBMMeetingChartView_rules_unit/2.0)/SZBMMeetingChartView_rules_unit)*SZBMMeetingChartView_rules_unit + _f_begining_time;
            
            if (_timeCallBackBlock) {
                _timeCallBackBlock(n_return_minitues);
            }
        }
        
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
    
    
    float f_inside_x = scrollView.contentOffset.x - CGRectGetWidth(_timeLongView.bounds)/2;
    
    if ( f_inside_x < 0 )
    {
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(_timeLongView.bounds)/2, 0) animated:YES];
    }
    else if(f_inside_x >= [self _SZBMMeetingChartView_chart_width] - CGRectGetWidth(_timeLongView.bounds)/2)
    {
        [scrollView setContentOffset:CGPointMake([self _SZBMMeetingChartView_chart_width] - CGRectGetWidth(_timeLongView.bounds)/2, 0) animated:YES];
    }
    
}

@end
