//
//  TimeButton.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/15.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockButton.h"
@interface TimeButton : BlockButton

/**
 *  按钮默认的颜色
 */
@property (nonatomic,strong) UIColor *defineColor;

/**
 *  开始计时WithTime
 */
- (void)startWithTimer:(NSInteger)time;

/**
 *  结束计时
 */
- (void) endTimed;

@end
