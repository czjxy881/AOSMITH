//
//  UIWindow+Extension.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/15.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "BaseDelegate.h"
#define KBaseDelegate  ((BaseDelegate *)[UIApplication sharedApplication].delegate)
@implementation UIWindow (Extension)

+ (UIWindow *) changeWindowRootViewController:(UIViewController *) viewController animated:(BOOL)animated
{
    UIWindow *window = KBaseDelegate.window;
    if (animated) {
        [UIView transitionFromView:window.rootViewController.view toView:viewController.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            window.rootViewController = viewController;
            [window makeKeyAndVisible];
            KBaseDelegate.navigationController = (UINavigationController *)viewController;
        }];
    }else{
        window.rootViewController = viewController;
        [window makeKeyAndVisible];
        KBaseDelegate.navigationController = (UINavigationController *)viewController;
    }
    return window;
}

+ (UIWindow *)getCurrentWindow
{
    return [[UIApplication sharedApplication].windows lastObject];
}

@end
