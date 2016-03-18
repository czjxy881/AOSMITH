//
//  SkywareUIMessage.h
//  SkywareUI
//
//  Created by 李晓 on 15/11/12.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareUIMessage : NSObject

/**
 *    AddDeviceView
 *  添加设备页面的所有提示消息
 */

/**
 *  请先连接WiFi
 **/
extern NSString * const kMessageDeviceLinkWiFi;
/**
 *  已连接到WiFi
 **/
extern NSString * const kMessageDeviceAlreadyLinkWiFi;
/**
 *  请输入WiFi密码
 **/
extern NSString * const kMessageDeviceWriteWiFiPassword;
/**
 *  请输入设备名称
 */
extern NSString * const kMessageDeviceWriteDeviceName;
/**
 *  请输入设备地址
 */
extern NSString * const kMessageDeviceWriteDeviceLocation;
/**
 *  恭喜您，配网成功！
 */
extern NSString * const kMessageDeviceSettingWiFiSuccess;
/**
 *  （很抱歉，无法顺利连接到设备，可能由于： \n1.请检查WiFi密码是否输入正确；\n2.当前环境内WiFi路由器过多；\n3.当前路由器禁用某些端口。\n\n我们建议：\n1.将设备断电重新上电，然后长按“手动加水”按键5～10秒，看到WiFi指示灯快闪，快速靠近再试一次；\n2.重启路由器或换一台手机试一下。）配网失败提示
 */
extern NSString * const kMessageDeviceSettingWiFiError;
/**
 *  请输入机身编码
 */
extern NSString * const kMessageDeviceWriteSNCode;
/**
 *  未找到该SN码 请重试
 */
extern NSString * const kMessageDeviceNotFindSNCode;
/**
 *  该设备已经锁定 请先解锁
 */
extern NSString * const kMessageDeviceClock;
/**
 *  该SN码已被使用 请查证后重试
 */
extern NSString * const kMessageDeviceCheckSNUsed;
/**
 *  绑定失败，请稍后重试
 */
extern NSString * const kMessageDeviceBindDeviceError;
/**
 *  恭喜您，绑定成功
 */
extern NSString * const kMessageDeviceBindDeviceSuccess;


/**
 *    UserUI
 *  用户的登录，注册，找回密码 --------------------------------------------------
 */

/**
 *  自动登录中...
 */
extern NSString * const kMessageUserAutoLogin;
/**
 *  登录中...
 */
extern NSString * const kMessageUserLogin;
/**
 *  您还没有注册，请先注册
 */
extern NSString * const kMessageUserNotRegister;
/**
 *  该手机号已被注册
 */
extern NSString * const kMessageUserAlreadyRegister;
/**
 *  恭喜您!注册成功
 */
extern NSString * const kMessageUserRegisterSuccess;
/**
 *  用户名密码或密码错误
 */
extern NSString * const kMessageUserNameOrPasswordError;
/**
 *  努力获取中...（验证码）
 */
extern NSString * const kMessageUserGetCodeLoad;
/**
 *  激活码已发送到您%@的手机
 */
extern NSString * const kMessageUserGetCodeSuccess;
/**
 *  获取验证码失败，请稍后重试
 */
extern NSString * const kMessageUserGetCodeError;
/**
 *  请输入验证码
 */
extern NSString * const kMessageUserWriteCode;
/**
 *  验证码有误,请重新输入
 */
extern NSString * const kMessageUserWriteCodeError;
/**
 *  密码修改中...
 */
extern NSString * const kMessageUserChangePassword;
/**
 *  密码修改成功
 */
extern NSString * const kMessageUserChangePasswordSuccess;
/**
 *  密码修改失败,请稍后重试
 */
extern NSString * const kMessageUserChangePasswordError;



@end
