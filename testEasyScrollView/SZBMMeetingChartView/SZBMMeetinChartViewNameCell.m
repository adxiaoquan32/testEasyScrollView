//
//  SZBMMeetinChartViewNameCell.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/4/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMMeetinChartViewNameCell.h"

@implementation SZBMMeetinChartViewNameCell
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        
        [self _initData];
    }
    
    return self;
    
}


- (void)_initData
{
    
    self.textLabel.font = [UIFont systemFontOfSize:12.0f];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void)setCellData:(id)data
{
    if ( data )
    {
        szbmMeetingChartData *chartData = (szbmMeetingChartData*)data;
        self.textLabel.text = chartData.userName;
    }
    
}



@end
