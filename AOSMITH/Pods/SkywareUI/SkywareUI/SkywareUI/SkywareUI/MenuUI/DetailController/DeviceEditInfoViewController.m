//
//  DeviceEditInfoViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceEditInfoViewController.h"

@interface DeviceEditInfoViewController ()
/*** 设备名称 */
@property (weak, nonatomic) IBOutlet UITextField *device_name;
/*** 设备状态切换 Swithch  */
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
/*** 设备状态标识Label  */
@property (weak, nonatomic) IBOutlet UILabel *state;
/*** 解除绑定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *releaseUserBtn;
/*** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation DeviceEditInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
        self.view.backgroundColor = UIM.Menu_view_bgColor == nil?UIM.All_view_bgColor : UIM.Menu_view_bgColor;
        [self.releaseUserBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
        [self.finishBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设备管理"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BOOL device_lock = [_DeviceInfo.device_lock boolValue];
    [self setStateWithState:!device_lock];
    self.device_name.text = _DeviceInfo.device_name;
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceRelseaseUserRefreshTableView object:nil];
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
    [SVProgressHUD show];
    [SkywareDeviceManager DeviceUpdateDeviceInfo:update Success:^(SkywareResult *result) {
        [SVProgressHUD showSuccessWithStatus:@"修改设备信息成功"];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceRelseaseUserRefreshTableView object:nil];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"修改失败，请稍后重试"];
    }];
}

@end
