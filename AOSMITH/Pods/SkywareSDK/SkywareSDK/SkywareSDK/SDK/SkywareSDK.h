//
//  SkywareSDK.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/4.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//


// 老接口地址：http://doc.skyware.com.cn/protocol/v1.3/S.html
// 新接口地址：https://github.com/nosun/skyiot/blob/master/protocol/standard/S.md

#define RTServersURL [NSString stringWithFormat:@"http://%@.skyware.com.cn/api",[SkywareSDKManager sharedSkywareSDKManager].service]
#define kMQTTServerHost [NSString stringWithFormat:@"%@.skyware.com.cn",[SkywareSDKManager sharedSkywareSDKManager].service]

/** MQTT 订阅设备MAC */
#define kTopic(deviceMac) [NSString stringWithFormat:@"sjw/%@",deviceMac]

/** 签名中 apiver(必填项) */
#define kSignature_apiver [SkywareSDKManager sharedSkywareSDKManager].service

/** 签名中需要的key(必填项)  */
#define kSignature_key @"skyware"

#ifdef DEBUG // 处于开发阶段
#define NSLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define NSLog(...)
#endif

#define kUserDataPath  [[NSString applicationDocumentsDirectory] stringByAppendingPathComponent:@"User.data"]

#import "SkywareDeviceUpdateInfoModel.h"
#import "SkywareDeviceQueryInfoModel.h"
#import "SkywareAddressWeatherModel.h"
#import "SkywareUserFeedBackModel.h"
#import "SkywareDeviceInfoModel.h"
#import "SkywareWeatherModel.h"
#import "SkywareUserInfoModel.h"
#import "SkywareSDKManager.h"
#import "SkywareSendCmdModel.h"
#import "SkywareResult.h"
#import "SkywareMQTTModel.h"
#import "SkywareDeviceManager.h"
#import "SkywareOtherManager.h"
#import "SkywareUserManager.h"
#import "SkywareNotificationCenter.h"
#import "SkywareConst.h"
#import "SkywareCloudURL.h"
#import "SkywareHttpTool.h"
#import "SkywareDeviceTool.h"
#import "SkywareMQTTTool.h"
#import "SkywareJSApiTool.h"






