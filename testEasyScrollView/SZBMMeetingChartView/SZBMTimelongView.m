//
//  SZBMTimelongView.m
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/9/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import "SZBMTimelongView.h"
#import "SZBMMeetingChartViewHeader.h"

@interface SZBMTimelongView()
{
    CGRect _keepFrame_rt;
    CGPoint _panBegin_pt;
    BOOL _isMoving;
}

@property (nonatomic,assign)CGFloat fMinimum_X;
@property (nonatomic,copy  ) SZBMTimelongViewFramPanChanging timeCallBackBlock;


@end


@implementation SZBMTimelongView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor                       = [UIColor blackColor];
        self.alpha                                 = 0.1f;
        self.layer.borderWidth                     = 0.5f;
        self.layer.borderColor                     = [UIColor redColor].CGColor;
        
        
        if ( SZBMMeetingChartView_TimelongMoveEnable )
        {
            // add pan re
            UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paningGestureReceive:)];
            [gestureRecognizer setMinimumNumberOfTouches:1];
            [gestureRecognizer setMaximumNumberOfTouches:1];
            [self addGestureRecognizer:gestureRecognizer];
        }
         
        _isMoving = NO;
        _keepFrame_rt = frame;
        
    }
    return self;
}

- (void)setMoveEnable:(BOOL)moveEnable
{
    _moveEnable = moveEnable;
    self.userInteractionEnabled = moveEnable;
}


/**
 *   改变的回调
 *
 *  @param callBacBlock
 */
- (void)setSZBMTimelongViewCallBack:(SZBMTimelongViewFramPanChanging)callBacBlock
{
    _timeCallBackBlock = NULL;
    _timeCallBackBlock = [callBacBlock copy];
}



- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    
    if ( !self.moveEnable ) {
        return;
    }
  
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:self.superview];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan)
    {
        _panBegin_pt = touchPoint;
        _isMoving = YES;
        
        // start an animation 启动效果
        
    }
    else if (recoginzer.state == UIGestureRecognizerStateEnded ||
             recoginzer.state == UIGestureRecognizerStateCancelled ||
             recoginzer.state == UIGestureRecognizerStateFailed )
    {
        _isMoving = NO;
        _keepFrame_rt = self.frame;
    }
    
    // it keeps move with touch
    if ( _isMoving )
    {
        [self _moveViewWithX:touchPoint.x - _panBegin_pt.x];
    }
    else
    {
        if ( _timeCallBackBlock) {
            _timeCallBackBlock(self.frame,YES);
        }
    }
}

- (void)_moveViewWithX:(float)x
{
    CGRect changingRt = _keepFrame_rt;
    changingRt.origin.x += x;
    changingRt.origin.x = MAX(self.fMinimum_X , changingRt.origin.x);
    changingRt.origin.x = MIN(CGRectGetWidth(self.superview.frame) - CGRectGetWidth(self.frame), changingRt.origin.x);
    
    
    __block CGRect pretenRt = _keepFrame_rt;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setFrame:changingRt];
        
        // pretentd
        pretenRt.origin.x += x;
        pretenRt.origin.x = MAX(self.fMinimum_X - pretenRt.size.width*4/5.0f, pretenRt.origin.x);
        if ( _timeCallBackBlock) {
            _timeCallBackBlock(pretenRt,NO);
        }
          
    });
    
    // detect frame and call back
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if ( !_isMoving )
    {
        _keepFrame_rt = self.frame;
    }
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter: center];
    
    if ( !_isMoving )
    {
        CGRect rt = self.frame;
        rt.origin.x = center.x - CGRectGetWidth(rt);
        _keepFrame_rt = rt;
    }
    
}


- (void)setMaxLeftX:(CGFloat)fPositionX
{
    self.fMinimum_X = fPositionX;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
