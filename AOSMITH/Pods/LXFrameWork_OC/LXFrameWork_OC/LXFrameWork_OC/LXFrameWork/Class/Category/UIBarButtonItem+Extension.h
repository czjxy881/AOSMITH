//
//  UIBarButtonItem+Extension.h
//  HM新浪微博
//
//  Created by 李晓 on 14-10-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  创建 BarButtonItem
 *
 *  @param target     target
 *  @param action     action
 *  @param image      ButtonItem 图片
 *  @param hightImage ButtonItem 高亮图片
 *
 *  @return UIBarButtonItem
 */
+ (UIBarButtonItem *) itemWitchTaget:(id)target action:(SEL) action Image:(NSString *) image highlightImage:(NSString *) hightImage;

@end
