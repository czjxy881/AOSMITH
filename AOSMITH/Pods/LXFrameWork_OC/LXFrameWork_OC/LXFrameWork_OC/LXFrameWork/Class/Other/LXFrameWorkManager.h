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
@property (nonatomic,strong) UIColor *navigationBar_bgColor;
/**
 * 设置NavigationBar 字体颜色
 */
@property (nonatomic,assign) UIColor *navigationBar_textColor;
/**
 *  设置View 默认背景颜色（默认白色）
 */
@property (nonatomic,strong) UIColor *viewController_bgColor;
/**
 *  设置BaseStepViewController 下一步 > 下一步 > 完成 颜色
 */
@property (nonatomic,strong) UIColor *stepViewTitle_bgColor;
/**
 *  设置全局statusBar 颜色
 */
@property (nonatomic,assign) UIStatusBarStyle statusBarStyle;
/**
 *  返回按钮的颜色
 */
@property (nonatomic,assign) navBarBackColor backState;
/**
 *  异常信息邮件接收者（添加多个收件人以逗号隔开）
 *  例： lxiao723@163.com,1019661666@qq.com
 */
@property (nonatomic,copy) NSString *exceptionEmailAddress;

@end
