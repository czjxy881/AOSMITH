//
//  SkywareCloudURL.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/14.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareCloudURL : NSObject

//-------------------------User 相关---------------------------------//

/** 用户登陆URL */
extern NSString * const UserLoginURL;

/** 用户注册URL */
extern NSString * const UserRegisterURL;

/** 用户信息 */
extern NSString * const User;

/** 用户Password */
extern NSString * const UserPassword;

/** 上传用户头像 */
extern NSString * const UserUploadIcon;

/** 验证用户id */
extern NSString * const UserCheckId;

/** 找回用户密码 */
extern NSString * const UserRetrievePassword;

/** 用户反馈 */
extern NSString * const UserFeedBack;


//-------------------------Device 相关---------------------------------//

/** 验证 SN 码是否合法 */
extern NSString * const DeviceCheckSN;

/** 查询设备(设备在smartlink之前的第一步，是看设备是否在数据库中) */
extern NSString *const DeviceQueryInfo;

/** 更新设备信息 */
extern NSString *const DeviceUpdateInfo;

/** 被分享的设备是否确认绑定**/
extern NSString * const DeviceShareUserBind;

/** 设备被绑定的列表*/
extern NSString * const DeviceShareListBind;

/**主用户锁定该设备时，所有分享用户不可操作该设备，不可绑定该设备。**/
extern NSString * const DeviceUserLock;

/** 主用户解锁该设备，所有分享用户可以操作以及绑定该设备*/
extern NSString * const DeviceUnlock;

/** 主用户解除分享用户与设备之间的绑定关系*/
extern NSString * const DeviceReleaseShareUser;

/** 获取分享用户的未未确认绑定设备 **/
extern NSString * const DeviceGetUndefinedDevices;

/** 分享用户确认绑定设备 **/
extern NSString * const DeviceTrueUndefinedDevices;

/** 分享用户取消绑定设备 **/
extern NSString * const DeviceCancelUndefinedDevices;

/** 绑定设备 新接口 */
extern NSString * const DeviceBindUserNew;
/** 绑定设备 */
extern NSString *const DeviceBindUser;

/** 主用户 解绑设备 确认 */
extern NSString * const DeviceReleaseMasterUser;
/** 用户解绑设备 */
extern NSString *const DeviceReleaseUser;

/** 获取设备清单 */
extern NSString *const DeviceGetAllDevices;

/** 发送指令 */
extern NSString *const DevicePushCMD;


//-------------------------其他相关接口地址---------------------------------//

/** 天气接口 */
extern NSString *const Address_wpm;
/** 日志 */
extern NSString * const LogEvent;

@end
