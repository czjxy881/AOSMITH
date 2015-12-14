//
//  DeviceSettingSNView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceSettingSNView.h"
#import <BaseDelegate.h>
#define Delegate  ((BaseDelegate *)[UIApplication sharedApplication].delegate)
@interface DeviceSettingSNView()<QRCodeViewControllerDelegate>

@end

@implementation DeviceSettingSNView

- (void)awakeFromNib
{
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    [self.activationDeviceBtn setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor :UIM.Device_button_bgColor];
    self.backgroundColor = UIM.Device_view_bgColor == nil? UIM.All_view_bgColor :UIM.Device_view_bgColor;
}

+ (instancetype)createDeviceSettingSNView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AddDeviceViews" owner:nil options:nil][0];
}

/**
 *  点击了激活设备
 */
- (IBAction)activateDeviceBtnClick:(UIButton *)sender {
    if (self.codeTextField.text.length) {
        [self.codeTextField resignFirstResponder];
        [SVProgressHUD show];
        [SkywareDeviceManager DeviceVerifySN:self.codeTextField.text Success:^(SkywareResult *result) {
            [self queryDeviceMessage];
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:kMessageDeviceNotFindSNCode];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:kMessageDeviceWriteSNCode];
    }
}
- (IBAction)readQRCode:(UIButton *)sender {
    QRCodeViewController *readCode = [[QRCodeViewController alloc] init];
    readCode.delegate = self;
    [Delegate.navigationController presentViewController:readCode animated:YES completion:nil];
}

/**
 *  检查设备是否绑定过
 */
- (void)queryDeviceMessage
{
    SkywareDeviceQueryInfoModel *query = [[SkywareDeviceQueryInfoModel alloc] init];
    query.sn = self.codeTextField.text;
    [SkywareDeviceManager DeviceQueryInfo:query Success:^(SkywareResult *result) {
        SkywareDeviceInfoModel *model = [SkywareDeviceInfoModel mj_objectWithKeyValues:result.result];
        if (![model.device_lock boolValue]) { // 该设备已经锁定，禁止再绑定
            [SVProgressHUD showErrorWithStatus:kMessageDeviceClock];
            return ;
        }
        // SN 已经绑定了MAC,直接和用户绑定
        if (self.otherOption) {
            self.otherOption(model);
        }
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        if ([result.message isEqualToString:@"404"]) { // SN 没有绑定 MAC
            if (self.option) {
                self.option();
            }
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - QRCode 代理

- (void)ReaderCode:(QRCodeViewController *)readerViewController didScanResult:(NSString *)result
{
    self.codeTextField.text = result;
    [Delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)ReaderCoderDidCancel:(QRCodeViewController *)readerViewController
{
    [Delegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
