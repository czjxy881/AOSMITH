//
//  BaseTabBarService.h
//  LiXiao
//
//  Created by 李晓 on 14/12/22.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseTabBarService : NSObject

/**
 *  往TabBarController 中添加子控制器，并设置对应的TabbarItem 图片和文字
 *
 *  @param StoryBoardName    传入StoryBoard 的名称
 *  @param title         tabBarTitle
 *  @param image         普通状态下的image名称
 *  @param selectedImage 选中状态下image名称
 */

+ (UIViewController *) addChildViewWithStoryBoardName:(NSString *) StoryBoardName : (NSString *) title :(NSString *)image :(NSString *) selectedImage;

@end
