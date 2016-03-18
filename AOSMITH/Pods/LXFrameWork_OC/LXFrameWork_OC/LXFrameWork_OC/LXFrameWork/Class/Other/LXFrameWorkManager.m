//
//  LXFrameWorkManager.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/12/10.
//  Copyright © 2015年 LXFrameWork. All rights reserved.
//

#import "LXFrameWorkManager.h"
#import "UIColor+Extension.h"

@implementation LXFrameWorkManager
LXSingletonM(LXFrameWorkManager);

- (UIColor *)navigationBar_bgColor
{
    if (_navigationBar_bgColor == nil) {
        return [UIColor whiteColor];
    }else{
        return _navigationBar_bgColor;
    }
}

- (UIColor *)navigationBar_textColor
{
    if (_navigationBar_textColor == nil) {
        return [UIColor blackColor];
    }else{
        return _navigationBar_textColor;
    }
}

- (UIColor *)viewController_bgColor
{
    if (_viewController_bgColor == nil) {
        return [UIColor whiteColor];
    }else{
        return _viewController_bgColor;
    }
}

- (UIColor *)stepViewTitle_bgColor
{
    if (_stepViewTitle_bgColor == nil) {
        return [UIColor colorWithHexString:@"5fc206"];
    }else{
        return _stepViewTitle_bgColor;
    }
}

- (navBarBackColor)backState
{
    if (_backState == defaultBase || _backState == blackBase) {
        return blackBase;
    }else{
        return writeBase;
    }
}

@end
