//
//  SkywareCloudURL.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/14.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareCloudURL.h"

@implementation SkywareCloudURL

//-------------------------User 相关---------------------------------//

NSString * const UserLoginURL = @"token";

NSString * const UserRegisterURL = @"user";

NSString * const User = @"user";

NSString * const UserUploadIcon = @"file";

NSString * const UserPassword = @"passwd";

NSString * const UserCheckId = @"login_id";

NSString * const UserRetrievePassword = @"passwd";

NSString * const UserFeedBack = @"feedback";

//-------------------------Device 相关---------------------------------//

NSString * const DeviceCheckSN = @"deviceSn";

NSString * const DeviceQueryInfo = @"device";

NSString * const DeviceUpdateInfo = @"device";

NSString * const DeviceBindUser = @"bind";

NSString * const DeviceReleaseUser = @"bind";

NSString * const DeviceGetAllDevices = @"devices";

NSString * const DevicePushCMD = @"cmd";


//-------------------------其他相关接口地址---------------------------------//

NSString * const Address_wpm = @"wpm";

@end
