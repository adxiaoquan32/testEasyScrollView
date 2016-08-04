//
//  SZBMMeetingChartView.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMMeetingChartView.h"
#import "SZBMMeetingTimeRulesHeaderView.h"

@interface SZBMMeetingChartView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>


@property (nonatomic,strong) UIScrollView *horizonalScrollView;
@property (nonatomic,strong) UITableView  *leftTbView;
@property (nonatomic,strong) UITableView  *rightTbView;


@property (nonatomic,strong) NSMutableArray *chartDataArr;


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
        rt.size.width                                       = (rt.size.width - rt.origin.x);// SZBMMeetingChartView_chart_width; //
        _horizonalScrollView                                = [[UIScrollView alloc] initWithFrame:rt];
        _horizonalScrollView.delegate                       = self;
        _horizonalScrollView.showsVerticalScrollIndicator   = NO;
        _horizonalScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_horizonalScrollView];


        // 3 init rigth part of uitableview using for chart showing
        rt                                                  = self.bounds;
        rt.origin.x                                         = (WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2;
        rt.size.width                                       = SZBMMeetingChartView_chart_width;
        _rightTbView                                        = [[UITableView alloc] initWithFrame:rt style:UITableViewStylePlain];
        _rightTbView.dataSource                             = self;
        _rightTbView.delegate                               = self;
        _rightTbView.rowHeight                              = SZBMMeetingChartView_chart_height;
        _rightTbView.showsVerticalScrollIndicator           = NO;
        _rightTbView.showsHorizontalScrollIndicator         = NO;
        [_horizonalScrollView addSubview:_rightTbView];


        // setting horizon contensize
        [_horizonalScrollView setContentSize:CGSizeMake(SZBMMeetingChartView_chart_width + (WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2 + SZBMMeetingChartView_right_pading, 0)];

        _chartDataArr                                       = [[NSMutableArray alloc] init];


        // test
        _rightTbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _horizonalScrollView.backgroundColor                = [UIColor whiteColor];
        [_horizonalScrollView setContentOffset:CGPointMake((WINDOW_WIDTH - SZBMMeetingChartView_left_width)/2 , 0)];
        //_horizonalScrollView.bounces = NO;

        for (int i = 0; i < 50; i++) {
            [_chartDataArr addObject:[NSNull null]];
        }
        
        
    }
    return self;
}


#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?SZBMMeetingChartView_chart_height:0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section == 0 &&
        tableView == _rightTbView)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), SZBMMeetingChartView_chart_height)];
        view.backgroundColor = [UIColor lightGrayColor];
        SZBMMeetingTimeRulesHeaderView *hview = [[SZBMMeetingTimeRulesHeaderView alloc] initWithFrame:view.bounds withHours:enSZBMRulesHours_24h];
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
    static NSString *CellIdentifier = @"UIAlbumItemCell__";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = tableView == _leftTbView?[UIColor greenColor]:[UIColor redColor];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    
    
    
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
    
}




@end
