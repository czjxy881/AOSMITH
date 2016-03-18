//
//  DeviceBindingView.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "StepNextView.h"
#import "SkywareUIManager.h"

typedef void(^ShareOption)();
typedef void(^AddAnotherDeviceOption)();

@interface DeviceBindingView : StepNextView

/**
 *  创建绑定设备页面
 */
+ (instancetype)createDeviceBindingView;

@property (nonatomic,strong) SkywareDeviceInfoModel *deviceInfo;

@property (nonatomic,copy) ShareOption shareOption;
@property (nonatomic,copy) AddAnotherDeviceOption addAnotherOption;

@end
