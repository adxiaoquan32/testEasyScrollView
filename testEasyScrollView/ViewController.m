//
//  ViewController.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "ViewController.h"
#import "SZBMMeetingChartView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    SZBMMeetingChartView *cView = [[SZBMMeetingChartView alloc] initWithFrame:CGRectInset(self.view.bounds, 0, 21)];
    [self.view addSubview:cView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
