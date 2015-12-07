//
//  AddDeviceViewController.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseStepViewController.h"

/** 汉风配网 SmartLink */
#import <HFSmartLink.h>
#import <HFSmartLinkDeviceInfo.h>

/** Skyware_SDK */
#import <SkywareDeviceInfoModel.h>
#import <SkywareDeviceUpdateInfoModel.h>
#import <SkywareDeviceManager.h>

/** 添加设备需要的View */
#import "DeviceSettingSNView.h"
#import "DeviceSettingWifiView.h"
#import "DeviceResetView.h"
#import "DeviceSmartLinkStart.h"
#import "DeviceSettingErrorView.h"
#import "DeviceBindingView.h"

/** Skyware_UI */
#import "SkywareUIConst.h"

typedef enum {
    inputPassword,  // 输入密码
    resetDevice,   // 重置设备，灯闪亮
    settingStart, // 开始 SmartLink 配网
    settingError // 添加设备出现错误
}settingState;

@interface AddDeviceViewController : BaseStepViewController

/**
 *  设备的状态，是添加设备，还是离线配置WiFi
 */
@property (nonatomic,assign) BOOL isAddDevice;

@end
