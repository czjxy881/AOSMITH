//
//  DeviceBindingView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceBindingView.h"
@interface DeviceBindingView ()

/**
 *  设备名称
 */
@property (weak, nonatomic) IBOutlet UITextField *name;
/**
 *  设备状态
 */
@property (weak, nonatomic) IBOutlet UILabel *state;
/**
 *  切换状态按钮
 */
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
/**
 *  绑定完成按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation DeviceBindingView

- (void)awakeFromNib
{
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    self.backgroundColor = UIM.Device_view_bgColor == nil? UIM.All_view_bgColor :UIM.Device_view_bgColor;
    [self.finishBtn setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
}

+ (instancetype)createDeviceBindingView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AddDeviceViews" owner:nil options:nil][5];
}

/**
 *  0 : 锁定状态  1:未锁定状态
 *
 *  奇葩的思维我没办法
 */
- (void)setParams:(NSDictionary *)params
{
    [super setParams:params];
    NSString *deviceName = params[@"deviceName"];
    BOOL device_lock = [params[@"deviceLock"] boolValue];
    [self setStateWithState:!device_lock];
    self.name.text = deviceName;
}

- (IBAction)switchChange:(UISwitch *)sender {
    [self setStateWithState:sender.isOn];
}

- (void)setStateWithState:(BOOL)state
{
    [self.switchBtn setOn:state];
    if (state) {
        self.state.text = @"已锁定";
        self.state.textColor = [UIColor redColor];
    }else{
        self.state.text = @"未锁定";
        self.state.textColor = [UIColor blackColor];
    }
}

- (IBAction)commitBtnClick:(UIButton *)sender {
    if (!self.name.text.length) {
        [SVProgressHUD showErrorWithStatus:kMessageDeviceWriteDeviceName];
        return;
    }
    if (self.otherOption) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.name.text forKey:@"deviceName"];
        [params setValue:@(!self.switchBtn.isOn) forKey:@"switchState"];
        self.otherOption(params);
    }
}

@end
