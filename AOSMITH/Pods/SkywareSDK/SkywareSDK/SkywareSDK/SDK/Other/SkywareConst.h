//
//  SkywareConst.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareConst : NSObject

/** 收到 CurrentDevice 推送消息发送通知 */
extern NSString * const kSkywareNotificationCenterCurrentDeviceMQTT;

/** 推送消息发送通知 userInfo 的 Key  */
extern NSString * const kSkywareMQTTuserInfoKey;

/** 查询用户所有绑定设备完成发送通知  */
extern NSString * const kSkywareFindBindUserAllDeviceSuccess;

#pragma mark - 保留类型

/** 设备从后台进入前台注册 MQTT 监听 */
extern NSString * const kApplicationDidBecomeActive;


/** 设备从后台进入前台注册 MQTT 监听 */
extern NSString * const kNotUser_tokenGotoLogin;

@end
