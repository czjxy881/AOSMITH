//
//  SkywareConst.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareConst.h"

@implementation SkywareConst

NSString * const kSkywareNotificationCenterCurrentDeviceMQTT = @"kSkywareNotificationCenterCurrentDeviceMQTT";

NSString * const kSkywareNotificationCenterCurrentDeviceLAN = @"kSkywareNotificationCenterCurrentDeviceLAN";

NSString * const kSkywareFindBindUserAllDeviceSuccess = @"kSkywareFindBindUserAllDeviceSuccess";

NSString * const kSkywareMQTTuserInfoKey = @"MQTT_Model";

NSString * const kApplicationDidBecomeActive = @"kApplicationDidBecomeActive";

NSString * const kNotUser_tokenGotoLogin = @"kNotUser_tokenGotoLogin";

NSString * const kSkywareSDKChangeWIFI = @"kSkywareSDKChangeWIFI";

#pragma mark ---- LAN V2.0

int const PORT_TCP_REMOTE = 8899;

int const PORT_UDP_REMOTE = 48899;

int const PORT_UDP_LOCAL = 8822;

NSString * const UDP_MASK_HOST = @"255.255.255.255";

NSString * const UDP_MASK_CODE = @"HF-A11ASSISTHREAD";


@end
