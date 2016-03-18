//
//  SkywareConst.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareConst : NSObject

/** 收到 CurrentDevice MQTT推送消息发送通知 */
extern NSString * const kSkywareNotificationCenterCurrentDeviceMQTT;

/** 收到 CurrentDevice LAN推送消息发送通知 */
extern NSString * const kSkywareNotificationCenterCurrentDeviceLAN;

/** 推送消息发送通知 userInfo 的 Key  */
extern NSString * const kSkywareMQTTuserInfoKey;

/** 查询用户所有绑定设备完成发送通知  */
extern NSString * const kSkywareFindBindUserAllDeviceSuccess;

#pragma mark - 保留类型

/** 设备从后台进入前台注册 MQTT 监听 */
extern NSString * const kApplicationDidBecomeActive;

/** 设备从后台进入前台注册 MQTT 监听 */
extern NSString * const kNotUser_tokenGotoLogin;


#pragma mark ---- LAN V2.0

/** 设备TCP远程端口规定值 */
extern int const PORT_TCP_REMOTE;

/** 设备UDP远程端口规定值 */
extern int const PORT_UDP_REMOTE;

/** 设备UDP广播本地监听端口 */
extern int const PORT_UDP_LOCAL;

/** 设备UDP广播子网掩码 */
extern NSString * const UDP_MASK_HOST;

/** 设备UDP广播口令 */
extern NSString * const UDP_MASK_CODE;

/** 用户切换不同的 WIFI */
extern NSString * const kSkywareSDKChangeWIFI;

@end
