//
//  SkywareUIMessage.m
//  SkywareUI
//
//  Created by 李晓 on 15/11/12.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SkywareUIMessage.h"

@implementation SkywareUIMessage

NSString * const kMessageDeviceLinkWiFi = @"请先连接WiFi";

NSString * const kMessageDeviceAlreadyLinkWiFi = @"已连接到WiFi";

NSString * const kMessageDeviceWriteWiFiPassword = @"请输入WiFi密码";

NSString * const kMessageDeviceWriteDeviceName = @"请输入设备名称";

NSString * const kMessageDeviceSettingWiFiSuccess = @"恭喜您，配网成功！";

NSString * const kMessageDeviceSettingWiFiError = @"很抱歉，无法顺利连接到设备，可能由于： \n1.请检查WiFi密码是否输入正确；\n2.当前环境内WiFi路由器过多；\n3.当前路由器禁用某些端口。\n\n我们建议：\n1.将设备断电重新上电，然后长按“手动加水”按键5～10秒，看到WiFi指示灯快闪，快速靠近再试一次；\n2.重启路由器或换一台手机试一下。";

NSString * const kMessageDeviceWriteSNCode = @"请输入机身编码";

NSString * const kMessageDeviceNotFindSNCode = @"未找到该SN码,请重试";

NSString * const kMessageDeviceCheckSNUsed = @"该SN码已被使用,请查证后重试";

NSString * const  kMessageDeviceClock= @"该设备已经锁定 请先解锁";

NSString * const kMessageDeviceBindDeviceError = @"绑定失败,请稍后重试";

NSString * const kMessageDeviceBindDeviceSuccess = @"恭喜您,绑定成功！";

NSString * const kMessageUserAutoLogin = @"自动登录中...";

NSString * const kMessageUserLogin = @"登录中...";

NSString * const kMessageUserNotRegister = @"您还没有注册，请先注册";

NSString * const kMessageUserRegisterSuccess = @"恭喜您!注册成功";

NSString * const kMessageUserAlreadyRegister = @"该手机号已被注册";

NSString * const kMessageUserNameOrPasswordError = @"用户名密码或密码错误";

NSString * const kMessageUserGetCodeError = @"获取验证码失败,请稍后重试";

NSString * const kMessageUserGetCodeLoad = @"努力获取中...";

NSString * const kMessageUserGetCodeSuccess = @"激活码已发送到您%@的手机";

NSString * const kMessageUserWriteCode = @"请输入4位验证码";

NSString * const kMessageUserWriteCodeError = @"验证码有误,请重新输入";

NSString * const kMessageUserChangePassword = @"密码修改中...";

NSString * const kMessageUserChangePasswordSuccess = @"密码修改成功";

NSString * const kMessageUserChangePasswordError = @"密码修改失败,请稍后重试";


@end


