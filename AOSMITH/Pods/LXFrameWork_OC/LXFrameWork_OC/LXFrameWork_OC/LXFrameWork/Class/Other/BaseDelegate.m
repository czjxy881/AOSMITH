//
//  BaseDelegate.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseDelegate.h"
//#import "CustomQRCodeViewController.h"

@interface BaseDelegate ()

@end

@implementation BaseDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // 设置弹出框后不可操作
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    // 添加键盘自动管理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 开启功能
    manager.shouldResignOnTouchOutside = YES; //点击背景是否收起键盘
    manager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    manager.enableAutoToolbar = YES; //控制是否显示键盘上的工具条
    
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *searchItemType1 = [NSString stringWithFormat:@"%@.Search",bundleIdentifier];
    NSString *searchItemType2 = [NSString stringWithFormat:@"%@.QRCode",bundleIdentifier];
    
    if([shortcutItem.type isEqualToString:searchItemType1]){
        
    }else if ([shortcutItem.type isEqualToString:searchItemType2]){
//        CustomQRCodeViewController *qrcode = [[CustomQRCodeViewController alloc] init];
//        [self.window.rootViewController presentViewController:qrcode animated:YES completion:^{
//        }];
    }
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
