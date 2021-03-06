//
//  DeviceBindingView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceBindingView.h"
#import <SelectCityViewController.h>


@interface DeviceBindingView ()
{
    CoreLocationTool *locationTool;
    CLLocation *_location;
}
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
 * 修改地址按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *changeLocationBtn;


/**
 *  开始体验按钮
 */
@property (nonatomic,strong) IBOutlet UIButton *btnStart;
/**
 *  继续添加设备
 */
@property (nonatomic,strong) IBOutlet UIButton *btnContinuAdd;
/**
 *  共享设备
 */
@property (nonatomic,strong) IBOutlet UIButton *btnShare;

/**
 *  位置显示
 */
@property (weak, nonatomic) IBOutlet UITextField *locationLabel;



@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;

@end

@implementation DeviceBindingView

- (void)awakeFromNib
{
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    self.backgroundColor = UIM.Device_view_bgColor == nil? UIM.All_view_bgColor :UIM.Device_view_bgColor;
    if (IS_IPHONE_4_OR_LESS) {
        _buttonTopConstraint.constant = 14;
    }else{
        _buttonTopConstraint.constant = 44;
    }
    [self.changeLocationBtn setBackgroundColor:UIM.Device_button_bgColor == nil ? UIM.All_button_bgColor :UIM.Device_button_bgColor];
    [self.btnStart setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    [self.btnContinuAdd setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    [self.btnShare setBackgroundColor:UIM.Device_button_bgColor == nil? UIM.All_button_bgColor : UIM.Device_button_bgColor];
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
    if (!params.count) return;
    NSString *deviceLocaion = params[@"deviceLocation"];
    if (deviceLocaion.length) {
        self.locationLabel.text = deviceLocaion;
    }else{
        [self setAddressLocation];
    }
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

- (IBAction)selectLocationClick:(UIButton *)sender {
    SelectCityViewController *selectCity = [[SelectCityViewController alloc] init];
    selectCity.cellClick = ^(NSString *addressText){
        _locationLabel.text = addressText;
    };
    self.option(selectCity);
}
//- (IBAction)commitBtnClick:(UIButton *)sender {
//    if (!self.name.text.length) {
//        [SVProgressHUD showErrorWithStatus:kMessageDeviceWriteDeviceName];
//        return;
//    }
//    if (!self.locationLabel.text.length) {
//        [SVProgressHUD showErrorWithStatus:kMessageDeviceWriteDeviceLocation];
//        return;
//    }
//    if (self.otherOption) {
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        [params setValue:self.name.text forKey:@"deviceName"];
//        [params setValue:@(!self.switchBtn.isOn) forKey:@"switchState"];
//        [params setValue:self.locationLabel.text forKey:@"deviceLocation"];
//        self.otherOption(params);
//    }
//}

-(BOOL)checkDeviceNameAndLocationIsEmpty
{
    if (!self.name.text.length) {
        [SVProgressHUD showErrorWithStatus:kMessageDeviceWriteDeviceName];
        return YES;
    }
    if (!self.locationLabel.text.length) {
        [SVProgressHUD showErrorWithStatus:kMessageDeviceWriteDeviceLocation];
        return YES;
    }
    return NO;
}
- (IBAction)onStartExperience:(UIButton *)sender {
    //跳到首页
    if ([self checkDeviceNameAndLocationIsEmpty]) {
        return;
    }
    [self removeFromSuperview];
    if (self.otherOption) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.name.text forKey:@"deviceName"];
        [params setValue:@(!self.switchBtn.isOn) forKey:@"switchState"];
        [params setValue:self.locationLabel.text forKey:@"deviceLocation"];
        self.otherOption(params);
    }
}

- (IBAction)onAddAnotherDevice:(UIButton *)sender {
    if ([self checkDeviceNameAndLocationIsEmpty]) {
        return;
    }
    [self removeFromSuperview];
    if (self.addAnotherOption) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.name.text forKey:@"deviceName"];
        [params setValue:@(!self.switchBtn.isOn) forKey:@"switchState"];
        [params setValue:self.locationLabel.text forKey:@"deviceLocation"];
        self.addAnotherOption(params);
    }
}

- (IBAction)onShareDevice:(UIButton *)sender
{
    if ([self checkDeviceNameAndLocationIsEmpty]) {
        return;
    }
    [self removeFromSuperview];
    if (self.shareOption) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.name.text forKey:@"deviceName"];
        [params setValue:@(!self.switchBtn.isOn) forKey:@"switchState"];
        [params setValue:self.locationLabel.text forKey:@"deviceLocation"];
        self.shareOption(params);
    }
}

- (void) setAddressLocation
{
    locationTool = [[CoreLocationTool alloc] init];
    [locationTool getLocation:^(CLLocation *location) {
        _location = location;
        [locationTool reverseGeocodeLocation:location userAddress:^(UserAddressModel *userAddress){
            self.locationLabel.text = userAddress.City;
        }];
    }];
}




@end
