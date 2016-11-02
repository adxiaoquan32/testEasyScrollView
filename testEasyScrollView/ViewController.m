//
//  ViewController.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "ViewController.h"
#import "SZBMMeetingChartView.h"
#import "SZBMMeetingChartViewHeader.h"

@interface ViewController ()


@property (nonatomic,strong) UILabel *addressLabel;


@end

@implementation ViewController


- (void)_test
{
    NSLog(@"AAA");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"BBB");
    });
    NSLog(@"CCC");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"DDD");
    });
    NSLog(@"EEE");
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //NSDate *date = [NSDate date];
    //NSLog(@"__%@__%f__",date,[date timeIntervalSince1970]);
    
    
   // [self _test];
 
    
    self.view.backgroundColor = RGB(244,245,246,205);//[UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:0.1];
    
    CGRect rt = self.view.bounds;
    rt.origin.y = 21;
    rt.size.height = 21;
    _addressLabel  = [[UILabel alloc] initWithFrame:rt];
    _addressLabel.text = @"";
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.textColor = [UIColor redColor];
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_addressLabel];
    _addressLabel.numberOfLines = 0;
    
    
    rt = self.view.bounds;
    rt.origin.y = 42;
    rt.size.height -= 42;
    SZBMMeetingChartView *cView = [[SZBMMeetingChartView alloc] initWithFrame:rt];
    [self.view addSubview:cView];
    
    /*
     
    1470268800 08:00
    1470240000 00:00
    1470297000 15:50
    1470325800 23:50
    1470322800 23:00
     */
    
    
    [cView setMeetingTime:1470297000 timeLong:40];
    [cView loadChartData:[self _loadChartViewData]];
    
    
    __weak __typeof(self)weakSelf = self;
    [cView setTimeSelectedCallBack:^(NSInteger nMbeginTimeMins) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        strongSelf.addressLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)(nMbeginTimeMins/60),(long)(nMbeginTimeMins%60)];
    }];
    
    
}

- (NSArray *)_loadChartViewData
{
    NSString *jsonfilepath = [NSString stringWithFormat:@"%@/chartViewData.json",szbmGetResourcePath];
 
    NSString *stringjson = [NSString stringWithContentsOfFile:jsonfilepath encoding:NSUTF8StringEncoding error:nil];
    
   // NSLog(@"___:\n\n%@\n\n",stringjson);
    
    
    if ( stringjson )
    {
       NSError *error = nil;
        NSArray *pdataArray = [NSJSONSerialization JSONObjectWithData:[stringjson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        NSMutableArray *returnChartArr = [NSMutableArray new];
        for ( NSDictionary *dic in pdataArray )
        {
            szbmMeetingChartData *chartData = [[szbmMeetingChartData alloc] init];
            chartData.userName = [dic objectForKey:@"userName"];
            
            NSArray *schArr = [dic objectForKey:@"schedules"];
            NSMutableArray *schArrObs = [NSMutableArray new];
            for ( NSDictionary *dic in schArr )
            {
                szbmMeetingSchedule *msOb = [[szbmMeetingSchedule alloc] init];
                msOb.title = [dic objectForKey:@"title"];
                msOb.startTimeInterval = [[dic objectForKey:@"startTimeInterval"] longLongValue];
                msOb.nLastTimeLong = [[dic objectForKey:@"nLastTimeLong"] integerValue];
                
                [schArrObs addObject:msOb];
            }
            
            chartData.schedules = schArrObs;
            
            [returnChartArr addObject:chartData];
            
        }
        
        return returnChartArr;
       
    }
    
    return nil;;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
