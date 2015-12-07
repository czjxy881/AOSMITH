//
//  BaseTabBarService.m
//  LiXiao
//
//  Created by 李晓 on 14/12/22.
//  Copyright (c) 2014年 All rights reserved.
//

#import "BaseTabBarService.h"

@implementation BaseTabBarService

+ (UIViewController *) addChildViewWithStoryBoardName:(NSString *) StoryBoardName : (NSString *) title :(NSString *)image :(NSString *) selectedImage
{
    UIViewController *controller = [[UIStoryboard storyboardWithName:StoryBoardName bundle:nil] instantiateInitialViewController];
    controller.title = title;
    // 设置默认图标和选中时候的图标
    UIImage *nomimage = [UIImage imageNamed:image];
    UIImage *selImage = [UIImage imageNamed:selectedImage];
    [controller.tabBarItem setSelectedImage:[selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    controller.tabBarItem.image = [nomimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置字体普通和选中模式下的颜色
    NSMutableDictionary *normalDict =  [NSMutableDictionary dictionary];
    normalDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    normalDict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [controller.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedDict =  [NSMutableDictionary dictionary];
    selectedDict[NSForegroundColorAttributeName] = [UIColor redColor];
    [controller.tabBarItem setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
    
    return controller;
}

@end
