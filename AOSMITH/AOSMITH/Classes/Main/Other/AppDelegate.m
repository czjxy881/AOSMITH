//
//  AppDelegate.m
//  HangingFurnace
//
//  Created by 李晓 on 15/8/31.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "AppDelegate.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDK+AddressBookMethods.h>
#import <SkywareUIManager.h>
#import "UserLoginViewController.h"
#import "UIColor+Utility.h"

//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
#import "ShareConfig.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#define SMS_SDKAppKey    @"ed73b3e10c78"
#define SMS_SDKAppSecret  @"a2f955b667eeaa5c60e8a1a9d1ba7517"
#define PGY_SDKAppKey  @"c209a082cdb4a8295e3d5f4def3a58c1"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 设置 App_id
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    manager.app_id = 17;
    manager.service_type = testing_new;
    
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    UIM.All_button_bgColor = [UIColor colorWithHexString:@"#001b38"] ;//kSystemBtnBGColor;
    UIM.All_view_bgColor = kSystemLoginViewBackageColor;
    UIM.User_loginView_logo = [UIImage imageNamed:@"ic_launcher"];
    UIM.Menu_about_img = [UIImage imageNamed:@"about"];
    UIM.Device_bickerArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"wifi_normal"],[UIImage imageNamed:@"wifi_flick"],nil];
    
    //添加设备
    UIM.Device_setting_error = DeviceConfigureFail;
    UIM.Device_button_bgColor = [UIColor colorWithHexString:@"#001b38"];

    
    LXFrameWorkManager *LXManager = [LXFrameWorkManager sharedLXFrameWorkManager];
    LXManager.NavigationBar_bgColor = [UIColor colorWithHexString:@"#001b38"];
    LXManager.NavigationBar_textColor = [UIColor whiteColor];
    LXManager.backState = writeBase;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UserLoginViewController *loginRegister = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
    self.window.rootViewController = loginRegister;
    self.navigationController = (UINavigationController *)loginRegister;
    [self.window makeKeyAndVisible];
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:NO];
    [app setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 启动ShareSDK 的短信功能
    [SMSSDK registerApp:SMS_SDKAppKey withSecret:SMS_SDKAppSecret];
    [SMSSDK enableAppContactFriends:NO];
    
    //关闭用户反馈功能
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    // 蒲公英启动
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_SDKAppKey];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_SDKAppKey];
    // 检查更新
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    
    [self initPlat];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0xdcdcdc alpha:0.2]];    
    return YES;
}


/**
 *初始化分享平台
 **/
- (void)initPlat
{
    [ShareSDK registerApp:ShareAppKey];
    //registerWX
    [WXApi registerApp:WeixinAppId];
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:WeixinAppId wechatCls:[WXApi class]];
    //添加新浪微博应用
//    [ShareSDK connectSinaWeiboWithAppKey:SinaWeiboAppKey
//                               appSecret:SinaWeiboAppSecret
//                             redirectUri:@"http://www.skyware.com"];
//    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQZoneAppKey
                           appSecret:QQZoneAppSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:QQZoneAppKey
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
