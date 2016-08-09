//
//  SZBMTimelongView.h
//  testEasyScrollView
//
//  Created by xiaoquan jiang on 8/9/16.
//  Copyright © 2016 xiaoquan jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SZBMTimelongViewFramPanChanging)(CGRect frame,BOOL finish);


@interface SZBMTimelongView : UIView

@property(nonatomic,assign)BOOL moveEnable;

- (void)setMaxLeftX:(CGFloat)fPositionX;


/**
 *   改变的回调
 *
 *  @param callBacBlock 
 */
- (void)setSZBMTimelongViewCallBack:(SZBMTimelongViewFramPanChanging)callBacBlock;


@end
