//
//  DeviceEditInfoViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceEditInfoViewController.h"
#import "SelectCityViewController.h"

@interface DeviceEditInfoViewController ()
{
    CoreLocationTool *locationTool;
    CLLocation *_location;
}
/*** 设备名称 */
@property (weak, nonatomic) IBOutlet UITextField *device_name;
/*** 设备状态切换 Swithch  */
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
/*** 设备状态标识Label  */
@property (weak, nonatomic) IBOutlet UILabel *state;
/*** 修改地址按钮 */
@property (weak, nonatomic) IBOutlet UIButton *changeLocationBtn;
/*** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
/*** 定位位置的Label */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation DeviceEditInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
        self.view.backgroundColor = UIM.Menu_view_bgColor == nil?UIM.All_view_bgColor : UIM.Menu_view_bgColor;
        [self.changeLocationBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
        [self.finishBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设备管理"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDeviceInfo:(SkywareDeviceInfoModel *)DeviceInfo
{
    _DeviceInfo = DeviceInfo;
    BOOL device_lock = [_DeviceInfo.device_lock boolValue];
    [self setStateWithState:!device_lock];
    self.device_name.text = _DeviceInfo.device_name;
    if (_DeviceInfo.device_address.length) {
        self.locationLabel.text =_DeviceInfo.device_address;
    }else{
        [self setAddressLocation];
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

- (IBAction)switchChange:(UISwitch *)sender {
    [self setStateWithState:sender.isOn];
}

- (IBAction)selectLocationClick:(UIButton *)sender {
    SelectCityViewController *selectCity = [[SelectCityViewController alloc] init];
    selectCity.cellClick = ^(NSString *addressText){
        _locationLabel.text = addressText;
    };
    [self.navigationController pushViewController:selectCity animated:YES];
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

/**
 *  设备解除锁定，已经废弃
 */
- (IBAction)dereference:(UIButton *)sender {
    BOOL device_lock = [_DeviceInfo.device_lock boolValue];
    if(!device_lock) { // 1 未锁定 0 锁定
        [SVProgressHUD showErrorWithStatus:@"该设备已经锁定 禁止解锁"];
        return;
    }
    
    [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定要解除与(%@)绑定",_DeviceInfo.device_name]delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        [SkywareDeviceManager DeviceReleaseUser:@[_DeviceInfo.device_id] Success:^(SkywareResult *result) {
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"解绑失败,请稍后重试"];
        }];
    }
    
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    if (!self.device_name.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请填写设备名称"];
        return;
    }
    SkywareDeviceUpdateInfoModel *update = [[SkywareDeviceUpdateInfoModel alloc] init];
    update.device_mac = _DeviceInfo.device_mac;
    update.device_name = self.device_name.text;
    update.device_lock = [NSString stringWithFormat:@"%d",!self.switchBtn.isOn];
    if ([self.locationLabel.text rangeOfString:@"..."].location == NSNotFound) {
        update.device_address = self.locationLabel.text;
    }
    update.longitude = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
    update.latitude =  [NSString stringWithFormat:@"%f",_location.coordinate.latitude];
    [SVProgressHUD show];
    [SkywareDeviceManager DeviceUpdateDeviceInfo:update Success:^(SkywareResult *result) {
        [SVProgressHUD showSuccessWithStatus:@"修改设备信息成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"修改失败，请稍后重试"];
    }];
}

@end
