//
//  ImportClass.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/10.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG // 处于开发阶段
#define NSLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define NSLog(...)
#endif

// 全局使用的分类引用
#ifdef __OBJC__
#import "LXFrameWorkManager.h"
#import "NSString+Hash.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"
#import "UIImage+Extension.h"
#import "UITextView+Extension.h"
#import "NSString+Extension.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"
#import "UIWindow+Extension.h"
#import "NSString+RegularExpression.h"

#import "BasePullTableViewController.h"
#import "BaseCellTableViewController.h"
#import "BaseStepViewController.h"
#import "QRCodeViewController.h"
#import "PlistTool.h"
#import "PathTool.h"
#import "BundleTool.h"
#import "BaseNetworkTool.h"
#import "CoreLocationTool.h"
#import "SystemDeviceTool.h"
#import "CHKeychainTool.h"
#import "UserDefaultsTool.h"
#import "BlockButton.h"
#import "TimeButton.h"
#import "AppDelegate.h"
#import "LXSingleton.h"
#import "LXFrameWorkConst.h"
#import "UserAddressModel.h"

#import <FMDB.h>
#import <PureLayout.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>

#endif

// SYSTEM
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 屏幕宽高
#define kWindowWidth      [UIScreen mainScreen].bounds.size.width
#define kWindowHeight     [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH      ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT     ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <  568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5_OR_5S   (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_OR_6S   (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P_OR_6PS (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kLINE_1_PX (1.0f / [UIScreen mainScreen].scale)
#define MainDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)

// 通知
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// 颜色
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]

#define kRGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kSystemColor  kRGBColor(71, 167, 216, 1)

// 打印frame
#define kFrameLog(f) NSLog(@"%@",NSStringFromCGRect(f));

@interface ImportClass : NSObject

@end

