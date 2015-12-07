//
//  SkywareUIInstanceModel.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareUIMessage.h"    // SkywareUI 中提示消息
#import <LXSingleton.h>
#import <SkywareSDK.h>

@interface SkywareUIInstance : NSObject
LXSingletonH(SkywareUIInstance)

/***  所有页面View背景颜色 */
@property (nonatomic,strong) UIColor *All_view_bgColor;
/***  所有页面按钮背景颜色 */
@property (nonatomic,strong) UIColor *All_button_bgColor;

// ----------------------   UserUI   ---------------------------------//

/***  用户相关页面背景颜色 */
@property (nonatomic,strong) UIColor *User_view_bgColor;
/***  用户相关页面按钮背景颜色 */
@property (nonatomic,strong) UIColor *User_button_bgColor;
/***  登录页面 Logo */
@property (nonatomic,strong) UIImage *User_loginView_logo;

// ----------------------   AddDeviceViews   ---------------------------------//

/***  addDeviceView 的背景颜色  */
@property (nonatomic,strong) UIColor *Device_view_bgColor;
/***  设备相关页面按钮背景颜色 */
@property (nonatomic,strong) UIColor *Device_button_bgColor;
/***  配置Wifi 显示密码 checkbox define */
@property (nonatomic,strong) UIImage *Device_checkbox_default;
/***  配置Wifi 显示密码 checkbox selected */
@property (nonatomic,strong) UIImage *Device_checkbox_selected;
/***  配置Wifi 页面图片 */
@property (nonatomic,strong) UIImage *Device_setWifi_bgimg;
/***  添加设备重置设备，灯闪亮图片Array */
@property (nonatomic,strong) NSArray *Device_bickerArray;
/***  添加设备重置设备，Title */
@property (nonatomic,copy) NSString *Device_resetTitle;
/***  添加设备重置设备，Content */
@property (nonatomic,copy) NSString *Device_resetContent;
/***  smartLink配网，动态信号图片 */
@property (nonatomic,strong) NSArray *Device_smartLink_array;
/***  添加设备错误提示信息 */
@property (nonatomic,copy) NSString *Device_setting_error;

// ----------------------   Menu   ---------------------------------//

/***  Menu 背景颜色 */
@property (nonatomic,strong) UIColor *Menu_view_bgColor;
/***  Menu相关页面按钮背景颜色 */
@property (nonatomic,strong) UIColor *Menu_button_bgColor;
/***  关于页面 img 图片 */
@property (nonatomic,strong) UIImage *Menu_about_img;
/***  关于页面的公司信息 */
@property (nonatomic,copy) NSString *company;
/***  关于页面的版权信息 */
@property (nonatomic,copy) NSString *copyright;


@end
