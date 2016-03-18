//
//  DeviceSettingErrorView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceSettingErrorView.h"
#import <BaseDelegate.h>
#define Delegate  ((BaseDelegate *)[UIApplication sharedApplication].delegate)
@interface DeviceSettingErrorView ()

/**
 *  提示 textView
 */
@property (weak, nonatomic) IBOutlet UITextView *textView;
/**
 *  重试按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
/**
 * 取消操作按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;

@end

@implementation DeviceSettingErrorView

- (void)awakeFromNib
{
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    self.backgroundColor = UIM.Device_view_bgColor == nil? UIM.All_view_bgColor :UIM.Device_view_bgColor;
    [self.againBtn setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    [self.cleanBtn setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    
    if (UIM.Device_setting_error.length) {
        self.textView.text = UIM.Device_setting_error;
    }else{
        self.textView.text = kMessageDeviceSettingWiFiError;
    }
    self.textView.font = [UIFont systemFontOfSize:17];
}

+ (instancetype)createDeviceSettingErrorView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AddDeviceViews" owner:nil options:nil][3];
}

- (IBAction)againBtnClick:(UIButton *)sender {
    if (self.option) {
        self.option();
    }
}

- (IBAction)cleanBtnClick:(UIButton *)sender {
    [Delegate.navigationController popToRootViewControllerAnimated:YES];
}


@end
