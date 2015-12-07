//
//  UIWindow+Extension.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/15.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)

/**
 *  切换当前窗口的RootViewController
 *
 *  @param viewController 要切换到的ViewController
 *
 *  @return 切换成功后的Window
 */
+ (UIWindow *) changeWindowRootViewController:(UIViewController *) viewController animated:(BOOL)animated;

/**
 *  获取当前最上面显示的窗口
 *
 *  @return Window
 */
+ (UIWindow *) getCurrentWindow;

@end
