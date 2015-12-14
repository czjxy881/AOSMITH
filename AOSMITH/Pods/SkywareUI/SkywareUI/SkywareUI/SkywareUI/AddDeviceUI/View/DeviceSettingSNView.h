//
//  DeviceSettingSNView.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "StepNextView.h"
#import "SkywareUIManager.h"
#import <QRCodeViewController.h>

@interface DeviceSettingSNView : StepNextView
/**
 *  SN_Code
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
/**
 *  激活设备按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *activationDeviceBtn;

/**
 *  创建输入二维码的页面
 */
+ (instancetype) createDeviceSettingSNView;

@end
