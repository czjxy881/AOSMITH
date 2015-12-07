//
//  UIBarButtonItem+Extension.m
//  HM新浪微博
//
//  Created by 李晓 on 14-10-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *) itemWitchTaget:(id)target action:(SEL) action Image:(NSString *) image highlightImage:(NSString *) hightImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置当点击自定义按钮的时候，调用哪个控制器中的哪个方法
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    UIImage *currentImage = [button currentImage];
    button.size = currentImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
