//
//  DeviceBindSucceedView.m
//  Pods
//
//  Created by ybyao07 on 16/1/20.
//
//

#import "DeviceBindSucceedView.h"
#import "SkywareUIManager.h"
@interface DeviceBindSucceedView()


@property (weak, nonatomic) IBOutlet UITextField *lblWhichDevice;

@property (weak, nonatomic) IBOutlet UITextField *deviceName;
@property (weak, nonatomic) IBOutlet UITextField *deviceLocation;
@property (weak, nonatomic) IBOutlet UITextField *deviceStatus;
@property (nonatomic,strong) IBOutlet UIButton *btnStart;
@property (nonatomic,strong) IBOutlet UIButton *btnContinuAdd;
@property (nonatomic,strong) IBOutlet UIButton *btnShare;
@end

@implementation DeviceBindSucceedView

-(void)awakeFromNib
{
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    [self.btnStart setBackgroundColor:UIM.Device_button_bgColor == nil ? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    [self.btnContinuAdd setBackgroundColor:UIM.Device_button_bgColor == nil ? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    [self.btnShare setBackgroundColor:UIM.Device_button_bgColor == nil ? UIM.All_button_bgColor : UIM.Device_button_bgColor];
}
+ (instancetype)createBindSucceedView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AddDeviceViews" owner:nil options:nil][6];
}

- (IBAction)onAddAnotherDevice:(UIButton *)sender {
    [self onClose:nil];
    if (self.otherOption) {
        self.otherOption();
    }
}


- (IBAction)onBinddingSucceed:(UIButton *)sender {
    //跳到首页
    [self onClose:nil];
    if (self.option) {
        self.option();
    }
}

- (IBAction)onShareDevice:(UIButton *)sender
{
    [self onClose:nil];
    if (self.shareOption) {
        self.shareOption(_deviceInfo);
    }
}

- (IBAction)onClose:(UIButton *)sender {
    [self removeFromSuperview];
}

-(void)setDeviceInfo:(SkywareDeviceInfoModel *)deviceInfo
{
    _deviceInfo = deviceInfo;
    _deviceName.text = deviceInfo.device_name;
    _deviceLocation.text = deviceInfo.device_address;
    _deviceStatus.text = [deviceInfo.device_lock boolValue] ?@"未锁定":@"已锁定";
}
-(void)setParams:(NSDictionary *)params
{
       _lblWhichDevice.text = [NSString stringWithFormat:@"恭喜你已成功添加第%d台设备",[params[@"deviceCount"] intValue]] ;
}





@end
