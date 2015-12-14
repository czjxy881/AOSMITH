//
//  DeviceSettingWifiView.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "StepNextView.h"
#import "SkywareUIManager.h"
#import <Reachability.h>
#import <BaseNetworkTool.h>

@interface DeviceSettingWifiView : StepNextView

/**
 *  Wifi密码
 */
@property (weak, nonatomic) IBOutlet UITextField *wifiPassword;

/**
 *  创建 设备Wifi页面
 */
+ (instancetype) createDeviceSettingWifiView;

@end
