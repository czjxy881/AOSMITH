//
//  DeviceSettingWifiView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceSettingWifiView.h"
#import <BaseDelegate.h>
#define Delegate  ((BaseDelegate *)[UIApplication sharedApplication].delegate)

@interface DeviceSettingWifiView ()
/***  Wifi 名称  */
@property (weak, nonatomic) IBOutlet UITextField *wifiSSID;
/***  提示框中文字  */
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
/***  下一步按钮  */
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
/***  取消按钮  */
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
/***  显示密码  */
@property (weak, nonatomic) IBOutlet UIButton *showPsd;
/***  头部图片  */
@property (weak, nonatomic) IBOutlet UIImageView *wifiImage;

@end

@implementation DeviceSettingWifiView

- (void)awakeFromNib
{
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    [self.nextBtn setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    [self.cleanBtn setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    self.backgroundColor = UIM.Device_view_bgColor == nil? UIM.All_view_bgColor : UIM.Device_view_bgColor;
    if (UIM.Device_checkbox_default && UIM.Device_checkbox_selected) {
        [self.showPsd setBackgroundImage:UIM.Device_checkbox_default forState:UIControlStateNormal];
        [self.showPsd setBackgroundImage:UIM.Device_checkbox_selected forState:UIControlStateSelected];
    }
    if (UIM.Device_setWifi_bgimg) {
        self.wifiImage.image = UIM.Device_setWifi_bgimg;
    }
    
    if ([BaseNetworkTool isConnectWIFI]) {
        self.wifiSSID.text = [SkywareDeviceTool getWiFiSSID];
    }else{
        self.connectLabel.text = kMessageDeviceLinkWiFi;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:kReachabilityChangedNotification object:nil];
}

+ (instancetype)createDeviceSettingWifiView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AddDeviceViews" owner:nil options:nil][1];
}

/**
 *  下一步
 */
- (IBAction)nextStep:(UIButton *)sender {
    if([BaseNetworkTool isConnectWIFI]){
        NSString *key = self.wifiPassword.text;
        if (!key.length) {
            [SVProgressHUD showErrorWithStatus:kMessageDeviceWriteWiFiPassword];
            return;
        }
        if (self.option) {
            self.option();
        }
    }else{
        [SVProgressHUD showErrorWithStatus:kMessageDeviceLinkWiFi];
    }
}

- (IBAction)cleanBtnClick:(UIButton *)sender {
    [Delegate.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  显示密码
 */
- (IBAction)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.wifiPassword.secureTextEntry = !sender.selected;
}

/**
 *  网络状态发生了改变
 */
- (void) networkChange: (NSNotification*)note {
    Reachability * reach = [note object];
    if (reach.isReachableViaWiFi) {
        self.connectLabel.text = kMessageDeviceAlreadyLinkWiFi;
        self.wifiSSID.text = [SkywareDeviceTool getWiFiSSID];
        return;
    }
    
    if (reach.isReachableViaWWAN) {
        self.connectLabel.text = kMessageDeviceLinkWiFi;
        self.wifiSSID.text = @"";
        return;
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
