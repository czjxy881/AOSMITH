//
//  LXFrameWorkManager.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/12/10.
//  Copyright © 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXSingleton.h"

typedef enum Sex{
    defaultBase,
    writeBase,
    blackBase
} navBarBackColor;

@interface LXFrameWorkManager : NSObject
LXSingletonH(LXFrameWorkManager);

/**
 *  设置NavigationBar 背景颜色（默认白色）
 */
@property (nonatomic,strong) UIColor *NavigationBar_bgColor;
/**
 *  设置全局statusBar 颜色
 */
@property (nonatomic,assign) UIStatusBarStyle statusBarStyle;
/**
 *  设置View 默认背景颜色（默认白色）
 */
@property (nonatomic,strong) UIColor *ViewController_bgColor;
/**
 *  返回按钮的颜色
 */
@property (nonatomic,assign) navBarBackColor backState;
/**
 * 设置NavigationBar 字体颜色
 */
@property (nonatomic,assign) UIColor *NavigationBar_textColor;
/**
 *  是否开启请求日志记录
 */
@property (nonatomic,assign) BOOL openHttpDebug;


@end
