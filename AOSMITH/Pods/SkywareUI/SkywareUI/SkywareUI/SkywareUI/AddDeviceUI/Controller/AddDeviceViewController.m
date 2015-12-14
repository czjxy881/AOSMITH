//
//  AddDeviceViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "SelectCityViewController.h"

@interface AddDeviceViewController ()
{
    settingState _state;
    HFSmartLink * _smtlk;
    SkywareDeviceInfoModel *_deviceInfo;
    NSString *_MAC;
    dispatch_source_t _timer;
}
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) NSString *code;  //sn
@property (strong, nonatomic) NSString *wifiPassword; //无线密码
@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"添加设备"];
    [self.dataList addObject:@"激活设备"];
    [self.dataList addObject:@"设置WiFi"];
    [self.dataList addObject:@"绑定设备"];
    [self reloadData];
    
    // 判断是配置网络还是添加设备
    if (!self.isAddDevice) {// 只配网
        self.stepHeadView.hidden = YES;
        [self.stepHeadView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.constant == 44) {
                [self.stepHeadView removeConstraint:obj];
                *stop = YES;
            }
        }];
        [self.stepHeadView autoSetDimension:ALDimensionHeight toSize:0];
        [self toPage:2];
    }else{
        self.stepHeadView.hidden = NO;
        [self.stepHeadView autoSetDimension:ALDimensionHeight toSize:44];
    }
    
    // 初始化 smtlkLink
    _smtlk = [HFSmartLink shareInstence];
    _smtlk.isConfigOneDevice = true;
}

#pragma mark - StepViewControllerDelegate

- (NSArray *) titleArrayAtHeadView:(UIView *)StepView
{
    return self.dataList;
}

- (UIView *)viewForRowAtFootView:(UIView *)StepView Count:(NSInteger)number
{
    if (number == 1) {
        DeviceSettingSNView *CodeView = [DeviceSettingSNView createDeviceSettingSNView];
        CodeView.option = ^{
            _code = CodeView.codeTextField.text;
            [self nextPage];
        };
        CodeView.otherOption = ^(id obj) {
            SkywareDeviceInfoModel *deviceInfo = (SkywareDeviceInfoModel *)obj;
            _deviceInfo = deviceInfo;
            [self toPage:3];
        };
        return CodeView;
        
    }else if (number == 2){
        if (_state == inputPassword) {
            DeviceSettingWifiView *settingView = [DeviceSettingWifiView createDeviceSettingWifiView];
            settingView.option = ^{
                _wifiPassword = settingView.wifiPassword.text;
                _state = resetDevice;
                [self toPage:2];
            };
            return settingView;
        }else if (_state == resetDevice){
            DeviceResetView *restView = [DeviceResetView createDeviceResetView];
            restView.option = ^{
                // 开始配网
                [self startSmartlink];
                _state = settingStart;
                [self toPage:2];
            };
            restView.otherOption = ^(id obj){
                _state = inputPassword;
                [self toPage:2];
            };
            return restView;
        }else if (_state == settingStart){
            DeviceSmartLinkStart *startView = [DeviceSmartLinkStart createDeviceSmartLinkStartView];
            startView.option = ^{
                // 点击了取消
                [self restDeviceNotClick];
            };
            return startView;
        }else if (_state == settingError){
            DeviceSettingErrorView *errorView = [DeviceSettingErrorView createDeviceSettingErrorView];
            errorView.option = ^{
                // 点击了重试
                _state = inputPassword;
                [self toPage:2];
            };
            return errorView;
        }
    }else if (number == 3){
        DeviceBindingView *bindingView = [DeviceBindingView createDeviceBindingView];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (_deviceInfo.device_name.length) {
            [params setObject:_deviceInfo.device_name forKey:@"deviceName"];
            [params setObject:_deviceInfo.device_lock forKey:@"deviceLock"];
            [params setObject:_deviceInfo.device_address forKey:@"deviceLocaion"];
        }
        bindingView.params = params;
        bindingView.option = ^(SelectCityViewController *selectCity){
            [self.navigationController pushViewController:selectCity animated:YES];
        };
        bindingView.otherOption = ^(id obj){
            // 更新设备信息
            NSDictionary *params = (NSDictionary *) obj;
            [self updateDeviceInfoWithDict:params];
        };
        return bindingView;
    }
    return nil;
}

/**
 *  取消配网
 */
- (void)restDeviceNotClick
{
    [_smtlk closeWithBlock:^(NSString *closeMsg, BOOL isOK) {
        if (isOK) {
            _state = inputPassword;
            [self toPage:2];
        }
    }];
}

- (void)startSmartlink
{
    
    [_smtlk startWithKey:self.wifiPassword processblock:^(NSInteger process) {
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        [self smartLinkSettingSuccessWithDev:dev];
    } failBlock:^(NSString *failmsg) {
        _state = settingError;
        [self toPage:2];
    } endBlock:^(NSDictionary *deviceDic) {
        
    }];
}

- (void) smartLinkSettingSuccessWithDev:(HFSmartLinkDeviceInfo *) dev
{
    if (!self.isAddDevice) { // 配网成功
        [self.navigationController popToRootViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:kMessageDeviceSettingWiFiSuccess];
    }else{ // 添加设备
        _MAC = dev.mac;
        // 循环查询方式查看设备是否上报信息
        [self startWithTimer];
    }
}

/**
 *  查询设备信息
 */
- (void)queryDeviceInfoWithMac
{
    SkywareDeviceQueryInfoModel *queryInfo = [[SkywareDeviceQueryInfoModel alloc] init];
    queryInfo.mac = _MAC;
    [SkywareDeviceManager DeviceQueryInfo:queryInfo Success:^(SkywareResult *result) {
        // 查询到设备后停止计时查询
        _deviceInfo = [SkywareDeviceInfoModel mj_objectWithKeyValues:result.result];
        [self endTimed];
        NSLog(@"找到设备");
        // 该设备已经被合法的SN绑定过
        if(_deviceInfo.device_sn.length){
            [SVProgressHUD showErrorWithStatus:kMessageDeviceCheckSNUsed];
            _state = inputPassword;
            [self toPage:2];
        }else{
            [self nextPage];
            [SVProgressHUD dismiss];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        // 没有找到设备
        if ([result.status isEqualToString:@"404"]) {
            NSLog(@"没有找到设备");
        }
    }];
}

/**
 *  更新设备信息
 */

- (void) updateDeviceInfoWithDict:(NSDictionary *) dict
{
    SkywareDeviceUpdateInfoModel *updateInfo = [[SkywareDeviceUpdateInfoModel alloc] init];
    updateInfo.device_mac = _deviceInfo.device_mac; // 必须设置，因为要根据 MAC 地址更新设备
    updateInfo.device_name = dict[@"deviceName"];
    updateInfo.device_lock = dict[@"switchState"];
    updateInfo.device_address = dict[@"deviceLocaion"];
    if (self.code.length) {
        updateInfo.device_sn = self.code;
    }
    [SVProgressHUD show];
    [SkywareDeviceManager DeviceUpdateDeviceInfo:updateInfo Success:^(SkywareResult *result) {
        // 用户设备绑定
        [self deviceBindUser];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:kMessageDeviceBindDeviceError];
    }];
}

/**
 *  用户绑定设备
 */
- (void)deviceBindUser
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_deviceInfo.device_mac forKey:@"device_mac"];
    [SkywareDeviceManager DeviceBindUser:params Success:^(SkywareResult *result) {
        [SVProgressHUD showSuccessWithStatus:kMessageDeviceBindDeviceSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:kMessageDeviceBindDeviceError];
    }];
}

- (void)startWithTimer
{
    __block NSInteger timeout = 10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),2 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _state = settingError;
                [self toPage:2];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self queryDeviceInfoWithMac];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void) endTimed
{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_smtlk closeWithBlock:^(NSString *closeMsg, BOOL isOK) {
        
    }];
}

#pragma mark - 懒加载

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
