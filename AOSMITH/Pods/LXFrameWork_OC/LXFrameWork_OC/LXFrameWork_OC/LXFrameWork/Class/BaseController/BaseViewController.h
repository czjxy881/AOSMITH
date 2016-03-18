//
//  BaseViewController.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

//                    _oo0oo_
//                   o8888888o
//                   88" . "88
//                   (| -_- |)
//                   0\  =  /0
//                 ___/`___'\___
//               .' \\|     |// '.
//              / \\|||  :  |||// \
//             / _||||| -:- |||||_ \
//            |   | \\\  _  /// |   |
//            | \_|  ''\___/''  |_/ |
//            \  .-\__  '_'  __/-.  /
//          ___'. .'  /--.--\  '. .'___
//        ."" '<  .___\_<|>_/___. '>' "".
//     | | :  `_ \`.;` \ _ / `;.`/ - ` : | |
//     \ \  `_.   \_ ___\ /___ _/   ._`  / /
//  ====`-.____` .__ \_______/ __. -` ___.`====
//                   `=-----='
//
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//        南无阿弥陀佛           永无BUG


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IQKeyboardReturnKeyHandler.h>
#import <SVProgressHUD.h>
#import "NavigationBar.h"
#import "UIView+Extension.h"
#import "BlockButton.h"
#import "BundleTool.h"

#define kRGBColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kWindowWidth [UIScreen mainScreen].bounds.size.width

// 屏幕宽高
#define kWindowWidth [UIScreen mainScreen].bounds.size.width
#define kWindowHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <=568.0)
#define IS_IPHONE_5_OR_5S (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_OR_6S (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P_OR_6PS (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kLINE_1_PX (1.0f / [UIScreen mainScreen].scale)

#pragma mark - Block
typedef void (^ClickButton)();

@interface BaseViewController : UIViewController

/***  NavBar 的 View */
@property (nonatomic,strong) NavigationBar *navView;
/***  无网状态刷新按钮点击 */
@property (nonatomic,copy) ClickButton networkRefreshOption;

#pragma mark - Base Method

/**
 *  设置自定义NavigationBar
 */
- (void)setCustomNavView:(UIView *) customView;

/**
 *  设置左边View
 */
- (void)setLeftView:(UIView *) leftView;

/**
 *  设置右边View
 */
- (void)setRightView:(UIView *) rightView;

/**
 *  设置中间View
 */
- (void)setCenterView:(UIView *) centerView;

/**
 *  设置navigationBar 返回按钮
 */
- (UIButton *) setNavBackBtn;

/**
 *  设置 NavigationController Title
 */
- (UILabel *) setNavTitle:(NSString *) title;

/**
 *  设置 NavBar 左边按钮集
 *
 *  @param btnArray @[Button,Button,Button] ;
 */
- (void) setLeftBtnArray:(NSArray *) btnArray;

/**
 *  设置 NavBar 右边按钮集
 *
 *  @param btnArray @[Button,Button,Button] ;
 */
- (void) setRightBtnArray:(NSArray *) btnArray;

/**
 *  设置 NavBar 左上角点击事件
 *
 *  供子类继承自由控制;
 */
- (void)NavBackBtnClick;

/**
 *  设置leftBtn
 */
- (UIButton *) setLeftBtnWithImage:(UIImage *)image orTitle:(NSString *) title ClickOption:(ClickButton) clickOption ;

/**
 *  设置rightBtn
 */
- (UIButton *) setRightBtnWithImage:(UIImage *)image orTitle:(NSString *) title ClickOption:(ClickButton) clickOption ;

#pragma mark - NetWork Method

/**
 *  设置无网状态下的提示页面
 *
 *  @param show YES：显示 NO：隐藏显示
 */
- (void) showNetWorkView:(BOOL) show;

@end
