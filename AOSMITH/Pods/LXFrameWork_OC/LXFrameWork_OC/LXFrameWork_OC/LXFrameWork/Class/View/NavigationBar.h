//
//  NavigationBar.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/8.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXFrameWorkInstance.h"
#import "PureLayout.h"

@interface NavigationBar : UIView

/**
 *  记录NavBar当前默认显示的 Color
 *  用于滚动显示NavBar的颜色
 */
@property (nonatomic,strong) UIColor *BackColor;
/**
 *  left,right,center 所在 View
 */
@property (nonatomic,strong) UIView *btnView;
/**
 *  NavBar 底部的线
 */
@property (nonatomic,strong) UIView *lineView;
/**
 *  NavBar 左边View
 */
@property (nonatomic,strong) UIView *leftView;
/**
 *  NavBar 中间边View
 */
@property (nonatomic,strong) UIView *centerView;
/**
 *  NavBar 右边View
 */
@property (nonatomic,strong) UIView *rightView;


#pragma mark - Method
/**
 *  动态设置 NavBar BackGroundColor
 */
- (void) setScrollNavigationBarBackColor:(UIColor *) color;
/**
 *  动态设置 NavBar LineBackColor
 */
- (void) setScrollNavigationBarLineBackColor:(UIColor *) color;
/**
 *  设置 NavBar clearColor 但是要显示左右两边的按钮
 */
- (void) setNavigationBarHiddenShowBtn:(BOOL) isHidden;

@end
