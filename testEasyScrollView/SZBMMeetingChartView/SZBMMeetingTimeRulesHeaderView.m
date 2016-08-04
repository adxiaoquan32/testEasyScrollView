//
//  SZBMMeetingTimeRulesHeaderView.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/3/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMMeetingTimeRulesHeaderView.h"

@interface SZBMMeetingTimeRulesHeaderView()

@property (nonatomic,strong) NSArray          *titleArr;

@end



@implementation SZBMMeetingTimeRulesHeaderView


- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray*)titles
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleArr = titles;
  
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

    float f_width_per_hour = CGRectGetWidth(rect)/[_titleArr count];
    UIFont *textFont = [UIFont systemFontOfSize:13.0f];
    NSDictionary *attr = @{NSFontAttributeName:textFont};
    
    
    for ( int i = 0; i < [_titleArr count];i++)
    {
        NSString *stringTimeTiel = [_titleArr objectAtIndex:i];
        CGSize fontSize = [stringTimeTiel sizeWithAttributes:attr];
        //NSLog(@" ___%f %f %f",f_width_per_hour,fontSize.width,fontSize.height);
        [stringTimeTiel drawAtPoint:CGPointMake( f_width_per_hour * i + (f_width_per_hour - fontSize.width)/2.0f, (CGRectGetHeight(rect) - fontSize.height)/2.0f) withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    
}


@end
