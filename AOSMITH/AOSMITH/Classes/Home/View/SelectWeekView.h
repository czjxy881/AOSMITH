//
//  SelectWeekView.h
//  HangingFurnace
//
//  Created by 李晓 on 15/9/9.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cleanBtnClick)();

@interface SelectWeekView : UIView

/**
 *  创建SelectView
 */
+ (instancetype) createSelectWeekView;
/**
 *  点击了取消Block
 */
@property (nonatomic,copy) cleanBtnClick cleanClick;
/**
 *  取消方法
 */
- (void) cleanMethod;
/**
 *  默认显示的重复的周期
 */
@property (nonatomic,copy) NSString *defineStr;

@end
