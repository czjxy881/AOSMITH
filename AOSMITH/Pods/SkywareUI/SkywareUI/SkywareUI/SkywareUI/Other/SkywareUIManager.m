//
//  SkywareUIManager.m
//  SkywareUI
//
//  Created by 李晓 on 15/12/14.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SkywareUIManager.h"

@implementation SkywareUIManager

LXSingletonM(SkywareUIManager)

- (UIColor *)All_view_bgColor
{
    if (_All_view_bgColor == nil) {
        return [UIColor whiteColor];
    }else{
        return _All_view_bgColor;
    }
}

- (UIColor *)All_button_bgColor
{
    if (_All_button_bgColor == nil) {
        return [UIColor lightGrayColor];
    }else{
        return _All_button_bgColor;
    }
}

@end
