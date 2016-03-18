//
//  AddDeviceViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "SelectCityViewController.h"
#import "ShareCodeQRViewController.h"
#import "LogEventModel.h"
#import "DataBaseLogEventManager.h"
#import "TimeUtil.h"
#import "EventProfile.h"

typedef NS_ENUM(NSInteger,BindSucceedOption) {
    BindSucceedStartExperience, //开始体验
    BindSucceedAddAnotherDevice,//添加另一台设备
    BindSucceedShareDevice,     //分享设备
};

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

static NSInteger hasQueryedDevice = 0;

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isAddDevice) {
        [self setNavTitle:@"设备配网"];
    }else{
        [self setNavTitle:@"添加设备"];
    }
    [self.dataList addObject:@"设置WiFi"]; //测试
    [self.dataList addObject:@"添加设备"];
    [self.dataList addObject:@"激活设备"];
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
        [self toPage:1];
    }else{
        //添加设备
        self.stepHeadView.hidden = NO;
        [self.stepHeadView autoSetDimension:ALDimensionHeight toSize:44];
        [self toPage:1];
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

//获取所要传输的日志参数
-(NSMutableDictionary *)getEventCotegoryWithEventId:(NSInteger )eventId
{
    NSArray * eventsCotegories = [EventProfile shareEventProfile].events;
    //event_id =1
    NSMutableDictionary *paramEvent = [NSMutableDictionary new];
    [eventsCotegories enumerateObjectsUsingBlock:^(EventCategory * _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([event.event_id integerValue] == eventId) {
            [paramEvent setObject:event.event_id forKey:@"event_id"];
            [paramEvent setObject:event.event_name forKey:@"event_name"];
            [paramEvent setObject:event.event_category forKey:@"event_category"];
            [paramEvent setObject:event.event_remark forKey:@"event_remark"];
            *stop = YES;
        }
    }];
    return paramEvent;
}

- (UIView *)viewForRowAtFootView:(UIView *)StepView Count:(NSInteger)number
{
    if (number == 1) {
        DeviceSettingWifiView *settingView = [DeviceSettingWifiView createDeviceSettingWifiView];
        if (_wifiPassword.length > 0 ) {
            settingView.wifiPassword.text = _wifiPassword;
        }
        settingView.option = ^{
            _wifiPassword = settingView.wifiPassword.text;
            _state = resetDevice;
            //增加日志-------added 2016-02-17
            //添加设备
            [self logStartEventAddDevice];
            //设备配网事件
            [self logStartEventConfigNetwork];
            //设置wifi事件
            NSMutableDictionary *eventSetWifiParam = [self getEventCotegoryWithEventId:4];
            [eventSetWifiParam setObject:@([TimeUtil sharedTimeUtil].addDeviceStartTime) forKey:@"event_start_time"];
            [eventSetWifiParam setObject:@([TimeUtil sharedTimeUtil].addDeviceStartTime) forKey:@"event_end_time"];
            [eventSetWifiParam setObject:@(0) forKey:@"flag_upload"];
            LogEventModel *logEventSetWifi = [LogEventModel mj_objectWithKeyValues:eventSetWifiParam];
            [[DataBaseLogEventManager shareDatabaseManager] insertData:logEventSetWifi];
            [self toPage:2];
        };
        return settingView;
    }else if (number == 2){
        if (_state == resetDevice){
            DeviceResetView *restView = [DeviceResetView createDeviceResetView];
            restView.option = ^{
                // 开始配网
                hasQueryedDevice = 0;
                [self startSmartlink];
                _state = settingStart;
                [self toPage:2];
            };
            restView.otherOption = ^(id obj){
                [self toPage:1];
            };
            return restView;
        }else if (_state == settingStart){
            DeviceSmartLinkStart *startView = [DeviceSmartLinkStart createDeviceSmartLinkStartView];
            startView.option = ^{
                // 点击了取消
                [self endTimed];
                [self restDeviceNotClick];
            };
            return startView;
        }else if (_state == settingError){
            DeviceSettingErrorView *errorView = [DeviceSettingErrorView createDeviceSettingErrorView];
            errorView.option = ^{
                // 点击了重试
                //                _state = inputPassword;
                [self toPage:1];
            };
            return errorView;
        }
    }else if (number == 3){
        //添加Sn码
        DeviceSettingSNView *CodeView = [DeviceSettingSNView createDeviceSettingSNView];
        CodeView.option = ^{
            _code = CodeView.codeTextField.text;
            //更新设备的SN信息到服务器-- 只更新sn
            [self updateDeviceInfoWithOnlySn:_code];
        };
        return CodeView;
    }
    return nil;
}

-(void)showDeviceBindView
{
    DeviceBindingView *bindingView = [DeviceBindingView createDeviceBindingView];
    bindingView.frame = CGRectMake(0, 64, kWindowWidth, kWindowHeight-64);
    [self.view addSubview:bindingView];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    [params setObject:UIM.defaultDeviceName forKey:@"deviceName"];
    [params setObject:@"1" forKey:@"deviceLock"];
    NSString *appName = [NSString stringWithFormat:@"%@-address",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:appName]?[[NSUserDefaults standardUserDefaults] objectForKey:appName]:@"北京"; //如果没有默认地址，则设置北京为默认地址
    if (_deviceInfo.device_address.length) {
        [params setObject:location forKey:@"deviceLocation"];
    }
    bindingView.params = params;
    bindingView.option = ^(SelectCityViewController *selectCity){ // 选择地址
        [self.navigationController pushViewController:selectCity animated:YES];
    };
    bindingView.otherOption = ^(id obj){ //开始体验---
        // 绑定设备
        NSDictionary *params = (NSDictionary *) obj;
        //增加日志-------added 2016-02-17
        //绑定设备
        [self logStartEventBindDevice];
        //提交绑定接口
        [self logStartEventBindDeviceApi];
        [self deviceAfterBindUpdateWithDic:params withOption:BindSucceedStartExperience];
    };
    bindingView.addAnotherOption = ^(id obj){
        // 绑定设备
        NSDictionary *params = (NSDictionary *) obj;
        //绑定设备
        [self logStartEventBindDevice];
        //提交绑定接口
        [self logStartEventBindDeviceApi];
        [self deviceAfterBindUpdateWithDic:params withOption:BindSucceedAddAnotherDevice];
    };
    bindingView.shareOption = ^(id obj){
        // 绑定设备
        NSDictionary *params = (NSDictionary *) obj;
        //绑定设备
        [self logStartEventBindDevice];
        //提交绑定接口
        [self logStartEventBindDeviceApi];
        [self deviceAfterBindUpdateWithDic:params withOption:BindSucceedShareDevice];
    };
}

/**
 *  取消配网
 */
- (void)restDeviceNotClick
{
    [_smtlk closeWithBlock:^(NSString *closeMsg, BOOL isOK) {
    }];
    [_smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
        if (isOk) {
            [self toPage:1];
        }
    }];
}

- (void)startSmartlink
{
    //增加日志-------added 2016-02-19
    //开始smartLink
    [self logStartEventSmartLink];
    [_smtlk startWithKey:self.wifiPassword processblock:^(NSInteger process) {
        
    } successBlock:^(HFSmartLinkDeviceInfo *dev) {
        //添加日志 ----- 检查设备是否上线   --- checkOnlineAPI
        [self logStartEventCheckOnlineApi];
        //更新日志 -------added 2016-02-19  --- 更新 smartLink end_time   //smartLink 成功
        [self logEndEventSmartLinkWithEventResult:1];
        [self smartLinkSettingSuccessWithDev:dev];
    } failBlock:^(NSString *failmsg) {
        [self logAllEndEventAddDevicekWithEventResult:0];
        _state = settingError;
        [self toPage:2];
    } endBlock:^(NSDictionary *deviceDic) {
        
    }];
}

- (void) smartLinkSettingSuccessWithDev:(HFSmartLinkDeviceInfo *) dev
{
    if (!self.isAddDevice) { // 配网成功
        //更新日志 -------added 2016-02-19 -- 配网成功
        [self logAllEndEventAddDevicekWithEventResult:1];
        [SVProgressHUD showSuccessWithStatus:kMessageDeviceSettingWiFiSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{ // 添加设备
        _MAC = dev.mac;
        // 循环查询方式查看设备是否上报信息
        [self startWithTimer];
    }
}

/**
 *  查询设备信息
 */
- (void)queryDeviceInfoWithMac:(NSInteger)timeOut
{
    SkywareDeviceQueryInfoModel *queryInfo = [[SkywareDeviceQueryInfoModel alloc] init];
    queryInfo.mac = _MAC;
    //间隔2秒一次请求数据，可能请求多次 都成功返回的情况
    [SkywareDeviceManager DeviceQueryInfo:queryInfo Success:^(SkywareResult *result) {
        // 查询到设备后停止计时查询
        hasQueryedDevice ++;
        [SVProgressHUD dismiss];
        _deviceInfo = [SkywareDeviceInfoModel mj_objectWithKeyValues:result.result];
        [self endTimed];
        NSLog(@"----------------query Device Info -----------");
        if (hasQueryedDevice==1) {
            //直接绑定设备
            [SkywareDeviceManager DeviceBindUserNew:@{@"devicemac":_MAC,@"userstate":@"0"} Success:^(SkywareResult *result) {
                [SVProgressHUD dismiss];
                //更新设备信息
                //日志：提交绑定请求成功
                [self logEndEventBindDeviceApiWithEventResult:1];
                [self updateDeviceInfoWithNoSN]; // 不管有没有设备信息，是否曾经有人绑定过该设备，更新sn且重置设备信息
                [self nextPage];
            } failure:^(SkywareResult *result) {
                [SVProgressHUD showErrorWithStatus:kMessageDeviceBindDeviceError];
                [self logEndEventBindDeviceApiWithEventResult:0];
                [self logEndEventBindDeviceWithEventResult:0];
                [self logEndEventAddDeviceWithEventResult:0];
            }];
        }
        //更新日志
        //检查设备上线成功
        [self logEndEventCheckOnlineApiEventResult:1];
        //设备配网成功
        [self logEndEventConfigNetworkWithEventResult:1];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        NSLog(@"没有找到设备");
        if (timeOut < 2) {
            //更新日志
            // 检查设备上线失败  --->   设备配网失败  --->  添加设备失败
            [self logEndEventCheckOnlineApiEventResult:0];
            [self logEndEventConfigNetworkWithEventResult:0];
            [self logEndEventAddDeviceWithEventResult:0];
            //            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备未成功登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            _state = settingError;
            [self toPage:2];
        }
    }];
}
/**
 *  更新设备信息没有sn号，且重置设备的默认信息
 */
-(void)updateDeviceInfoWithNoSN
{
    SkywareDeviceUpdateInfoModel *updateInfo = [[SkywareDeviceUpdateInfoModel alloc] init];
    updateInfo.device_mac = _deviceInfo.device_mac; // 必须设置，因为要根据 MAC 地址更新设备
    NSString *appName = [NSString stringWithFormat:@"%@-address",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    NSString *location = [[NSUserDefaults standardUserDefaults] objectForKey:appName]?[[NSUserDefaults standardUserDefaults] objectForKey:appName]:@"北京"; //如果没有默认地址，则设置北京为默认地址
    if (self.code.length) {
        updateInfo.device_dnsn = self.code;
    }
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    updateInfo.device_name = UIM.defaultDeviceName;
    updateInfo.device_lock = @"1";
    updateInfo.device_address =location;
    updateInfo.city = location;
    [SkywareDeviceManager DeviceUpdateDeviceInfo:updateInfo Success:^(SkywareResult *result) {
    } failure:^(SkywareResult *result) {
    }];
}

/**
 *  只更新设备的Sn号
 *
 *  @param snCode
 */
-(void)updateDeviceInfoWithOnlySn:(NSString *)snCode
{
    SkywareDeviceUpdateInfoModel *updateInfo = [[SkywareDeviceUpdateInfoModel alloc] init];
    updateInfo.device_mac = _deviceInfo.device_mac; // 必须设置，因为要根据 MAC 地址更新设备
    if (snCode.length) {
        updateInfo.device_dnsn = snCode;
    }
    [SkywareDeviceManager DeviceUpdateDeviceInfo:updateInfo Success:^(SkywareResult *result) {
        [self showDeviceBindView];
    } failure:^(SkywareResult *result) {
        
    }];
}


/**
 *  更新设备信息
 */
- (void) updateDeviceInfoWithDict:(NSDictionary *) dict withOption:(BindSucceedOption) option
{
    //添加日志
    [self logStartEventUpdateDeviceApi];
    SkywareDeviceUpdateInfoModel *updateInfo = [[SkywareDeviceUpdateInfoModel alloc] init];
    updateInfo.device_mac = _deviceInfo.device_mac; // 必须设置，因为要根据 MAC 地址更新设备
    updateInfo.device_name = dict[@"deviceName"];
    updateInfo.device_lock = dict[@"switchState"];
    updateInfo.device_address = dict[@"deviceLocation"];
    updateInfo.city = dict[@"deviceLocation"];
    if (self.code.length) {
        updateInfo.device_dnsn = self.code;
    }
    [SVProgressHUD show];
    [SkywareDeviceManager DeviceUpdateDeviceInfo:updateInfo Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if (option == BindSucceedStartExperience) { // 开始体验
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if (option == BindSucceedAddAnotherDevice){ //继续添加设备
            [self toPage:1];
        }else if (option == BindSucceedShareDevice){ //分享设备
            ShareCodeQRViewController *shareViewController = [[ShareCodeQRViewController alloc] init];
            shareViewController.codeStr = [NSString stringWithFormat:@"%@;%@",_deviceInfo.device_id,dict[@"deviceName"]];
            shareViewController.isFromBindViewDevice = YES;
            [self.navigationController pushViewController:shareViewController animated:YES];
        }
        
        //更新日志
        [self logEndEventUpdateDeviceApiWithEventResult:1];
        [self logEndEventBindDeviceWithEventResult:1];
        [self logEndEventAddDeviceWithEventResult:1];
        
    } failure:^(SkywareResult *result) {
        //更新日志
        [self logEndEventUpdateDeviceApiWithEventResult:0];
        [self logEndEventBindDeviceWithEventResult:0];
        [self logEndEventAddDeviceWithEventResult:0];
    }];
}

/**
 *  用户绑定设备设备后，跳转
 */
- (void)deviceAfterBindUpdateWithDic:(NSDictionary *)dic withOption:(BindSucceedOption)option
{
    [self updateDeviceInfoWithDict:dic withOption:option];
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
                [self queryDeviceInfoWithMac:timeout];
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


#pragma mark 日志服务
/**
 *  绑定设备 开始日志  数据库 insertData
 */
-(void)logStartEventBindDevice
{
    [TimeUtil sharedTimeUtil].bindDeviceStartTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventStartParam = [self getEventCotegoryWithEventId:3];
    [eventStartParam setObject:@([TimeUtil sharedTimeUtil].bindDeviceStartTime) forKey:@"event_start_time"];
    [eventStartParam setObject:@(0) forKey:@"flag_upload"];
    LogEventModel *logEventStartlog = [LogEventModel mj_objectWithKeyValues:eventStartParam];
    [[DataBaseLogEventManager shareDatabaseManager] insertData:logEventStartlog];
}

/**
 *  绑定设备 bindDevice 调用数据库update
 *
 *  @param eventResult : 0 为失败 1 为成功
 */
-(void)logEndEventBindDeviceWithEventResult:(int)eventResult
{
    [TimeUtil sharedTimeUtil].bindDeviceEndTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventEndParam= [self getEventCotegoryWithEventId:3];
    [eventEndParam setObject:@([TimeUtil sharedTimeUtil].bindDeviceStartTime) forKey:@"event_start_time"];
    [eventEndParam setObject:@([TimeUtil sharedTimeUtil].bindDeviceEndTime) forKey:@"event_end_time"];
    if (_MAC.length > 0 ) {
        [eventEndParam setObject:_MAC forKey:@"device_mac"];
    }
    [eventEndParam setObject:@(1) forKey:@"flag_upload"];
    [eventEndParam setObject:@(eventResult) forKey:@"event_result"];
    LogEventModel *logEventEndlog = [LogEventModel mj_objectWithKeyValues:
                                     eventEndParam];
    [[DataBaseLogEventManager shareDatabaseManager] updateData:logEventEndlog];
}

/**
 *  提交绑定接口  bindDeviceApi 调用数据库 insert
 */
-(void)logStartEventBindDeviceApi
{
    [TimeUtil sharedTimeUtil].bindDeviceApiStartTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventStartParam = [self getEventCotegoryWithEventId:7];
    [eventStartParam setObject:@([TimeUtil sharedTimeUtil].bindDeviceApiStartTime) forKey:@"event_start_time"];
    [eventStartParam setObject:@(0) forKey:@"flag_upload"];
    LogEventModel *logEventStartlog = [LogEventModel mj_objectWithKeyValues:eventStartParam];
    [[DataBaseLogEventManager shareDatabaseManager] insertData:logEventStartlog];
}

/**
 *  提交绑定请求 bindDeviceApi 调用数据库update
 *
 *  @param eventResult : 0 为失败 1 为成功
 */
-(void)logEndEventBindDeviceApiWithEventResult:(int)eventResult
{
    [TimeUtil sharedTimeUtil].bindDeviceApiEndTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventEndParam= [self getEventCotegoryWithEventId:7];
    [eventEndParam setObject:@([TimeUtil sharedTimeUtil].bindDeviceApiStartTime) forKey:@"event_start_time"];
    [eventEndParam setObject:@([TimeUtil sharedTimeUtil].bindDeviceApiEndTime) forKey:@"event_end_time"];
    if (_MAC.length > 0 ) {
        [eventEndParam setObject:_MAC forKey:@"device_mac"];
    }
    [eventEndParam setObject:@(1) forKey:@"flag_upload"];
    [eventEndParam setObject:@(eventResult) forKey:@"event_result"];
    LogEventModel *logEventEndlog = [LogEventModel mj_objectWithKeyValues:
                                     eventEndParam];
    [[DataBaseLogEventManager shareDatabaseManager] updateData:logEventEndlog];
    
}

/**
 *  提交设备信息请求 updateDeviceApi 调用数据库 insert
 */
-(void)logStartEventUpdateDeviceApi
{
    [TimeUtil sharedTimeUtil].updateDeviceApiStartTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventStartParam = [self getEventCotegoryWithEventId:8];
    [eventStartParam setObject:@([TimeUtil sharedTimeUtil].updateDeviceApiStartTime) forKey:@"event_start_time"];
    [eventStartParam setObject:@(0) forKey:@"flag_upload"];
    LogEventModel *logEventStartlog = [LogEventModel mj_objectWithKeyValues:eventStartParam];
    [[DataBaseLogEventManager shareDatabaseManager] insertData:logEventStartlog];
}

/**
 *  提交设备信息请求 updateDeviceApi 调用数据库update
 *
 *  @param eventResult : 0 为失败 1 为成功
 */
-(void)logEndEventUpdateDeviceApiWithEventResult:(int)eventResult
{
    [TimeUtil sharedTimeUtil].updateDeviceApiEndTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventEndParam= [self getEventCotegoryWithEventId:8];
    [eventEndParam setObject:@([TimeUtil sharedTimeUtil].updateDeviceApiStartTime) forKey:@"event_start_time"];
    [eventEndParam setObject:@([TimeUtil sharedTimeUtil].updateDeviceApiEndTime) forKey:@"event_end_time"];
    if (_MAC.length > 0 ) {
        [eventEndParam setObject:_MAC forKey:@"device_mac"];
    }
    [eventEndParam setObject:@(1) forKey:@"flag_upload"];
    [eventEndParam setObject:@(eventResult) forKey:@"event_result"];
    LogEventModel *logEventEndlog = [LogEventModel mj_objectWithKeyValues:
                                     eventEndParam];
    [[DataBaseLogEventManager shareDatabaseManager] updateData:logEventEndlog];
}


/**
 *  添加设备成功或者失败
 *  配网成功或失败更新日志文件
 *  需要更新4个日志事件
 *  1 setWiFi 输入Wifi信息
 *  2 SmartLink 成功与否
 *  3 configNetwork  设备配网成功与否
 *  4 addDevice  添加设备成功与否
 *
 *  @param eventResult : 0 为失败 1 为成功
 */
-(void)logAllEndEventAddDevicekWithEventResult:(int)eventResult
{
    //更新日志 -------added 2016-02-19 -- 配网失败 -- 则认为 添加设备 整个流程都失败了
    //输入WiFi信息
    [[DataBaseLogEventManager shareDatabaseManager] updateFlagUploadWithEventId:4 AndAfterTime:[TimeUtil sharedTimeUtil].addDeviceStartTime];
    //smartLink失败
    [self logEndEventSmartLinkWithEventResult:eventResult];
    //设备配网失败
    [self logEndEventConfigNetworkWithEventResult:eventResult];
    //添加设备失败
    [self logEndEventAddDeviceWithEventResult:eventResult];
}


/**
 *  开始smarkLink 日志  调用 insert方法
 */
-(void)logStartEventSmartLink
{
    [TimeUtil sharedTimeUtil].smartLinkStartTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventStartSmartLinkParam = [self getEventCotegoryWithEventId:5];
    [eventStartSmartLinkParam setObject:@([TimeUtil sharedTimeUtil].smartLinkStartTime) forKey:@"event_start_time"];
    [eventStartSmartLinkParam setObject:@(0) forKey:@"flag_upload"];
    LogEventModel *logSmartLinkStartlog = [LogEventModel mj_objectWithKeyValues:eventStartSmartLinkParam];
    [[DataBaseLogEventManager shareDatabaseManager] insertData:logSmartLinkStartlog];
    
}
/**
 *  smartLink 调用数据库 update 方法
 *
 *  @param eventResult  : 0 为失败 1为成功
 */
-(void)logEndEventSmartLinkWithEventResult:(int)eventResult
{
    [TimeUtil sharedTimeUtil].smartLinkEndTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventEndSmartLinkParam = [self getEventCotegoryWithEventId:5];
    [eventEndSmartLinkParam setObject:@([TimeUtil sharedTimeUtil].smartLinkStartTime) forKey:@"event_start_time"];
    [eventEndSmartLinkParam setObject:@([TimeUtil sharedTimeUtil].smartLinkEndTime) forKey:@"event_end_time"];
    if (_MAC.length > 0 ) {
        [eventEndSmartLinkParam setObject:_MAC forKey:@"device_mac"];
    }
    [eventEndSmartLinkParam setObject:@(1) forKey:@"flag_upload"];
    [eventEndSmartLinkParam setObject:@(eventResult) forKey:@"event_result"];
    LogEventModel *logEventEndlog = [LogEventModel mj_objectWithKeyValues:
                                     eventEndSmartLinkParam];
    [[DataBaseLogEventManager shareDatabaseManager] updateData:logEventEndlog];
}

/**
 *  配置网络 eventId = 2  调用 insert
 */
-(void)logStartEventConfigNetwork
{
    [TimeUtil sharedTimeUtil].configNetwokStartTime = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventConfigNetParam = [self getEventCotegoryWithEventId:2];
    [eventConfigNetParam setObject:@([TimeUtil sharedTimeUtil].configNetwokStartTime) forKey:@"event_start_time"];
    [eventConfigNetParam setObject:@(0) forKey:@"flag_upload"];
    LogEventModel *logEventConfigNet = [LogEventModel mj_objectWithKeyValues:eventConfigNetParam];
    [[DataBaseLogEventManager shareDatabaseManager] insertData:logEventConfigNet];
}
/**
 *  设备配网失败 configNetwork 调用数据库 update 方法
 *
 *  @param eventResult  : 0 为失败 1为成功
 */
-(void)logEndEventConfigNetworkWithEventResult:(int)eventResult
{
    [TimeUtil sharedTimeUtil].configNetwokEndTime = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventConfigNetEndParam = [self getEventCotegoryWithEventId:2];
    [eventConfigNetEndParam setObject:@([TimeUtil sharedTimeUtil].configNetwokStartTime) forKey:@"event_start_time"];
    [eventConfigNetEndParam setObject:@([TimeUtil sharedTimeUtil].configNetwokEndTime) forKey:@"event_end_time"];
    [eventConfigNetEndParam setObject:@(1) forKey:@"flag_upload"];
    [eventConfigNetEndParam setObject:@(eventResult) forKey:@"event_result"];
    LogEventModel *logEventConfigNetEndlog = [LogEventModel mj_objectWithKeyValues:
                                              eventConfigNetEndParam];
    [[DataBaseLogEventManager shareDatabaseManager] updateData:logEventConfigNetEndlog];
}


/**
 *  配网总时间开始  eventId = 1 , 调用 insert
 */
-(void)logStartEventAddDevice
{
    [TimeUtil sharedTimeUtil].addDeviceStartTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventStartParam = [self getEventCotegoryWithEventId:1];
    [eventStartParam setObject:@([TimeUtil sharedTimeUtil].addDeviceStartTime) forKey:@"event_start_time"];
    [eventStartParam setObject:@(0) forKey:@"flag_upload"];
    LogEventModel *logEventStartlog = [LogEventModel mj_objectWithKeyValues:eventStartParam];
    [[DataBaseLogEventManager shareDatabaseManager] insertData:logEventStartlog];
}

/**
 *  添加设备失败 addDevice 调用数据库 update方法
 *
 *  @param eventResult : 0 为失败 1为成功
 */
-(void)logEndEventAddDeviceWithEventResult:(int)eventResult
{
    [TimeUtil sharedTimeUtil].addDeviceEndTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventEndAddDevice= [self getEventCotegoryWithEventId:1];
    [eventEndAddDevice setObject:@([TimeUtil sharedTimeUtil].addDeviceStartTime) forKey:@"event_start_time"];
    [eventEndAddDevice setObject:@([TimeUtil sharedTimeUtil].addDeviceEndTime) forKey:@"event_end_time"];
    if (_MAC.length > 0 ) {
        [eventEndAddDevice setObject:_MAC forKey:@"device_mac"];
    }
    [eventEndAddDevice setObject:@(1) forKey:@"flag_upload"];
    [eventEndAddDevice setObject:@(eventResult) forKey:@"event_result"];
    LogEventModel *logEventEndAddDevice = [LogEventModel mj_objectWithKeyValues:
                                           eventEndAddDevice];
    [[DataBaseLogEventManager shareDatabaseManager] updateData:logEventEndAddDevice];
}

/**
 *  检查设备是否上线接口 eventId = 6 , 调用 insert
 */
-(void)logStartEventCheckOnlineApi{
    [TimeUtil sharedTimeUtil].checkOnlineApiStartTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventCheckOnLineApiParam = [self getEventCotegoryWithEventId:6];
    [eventCheckOnLineApiParam setObject:@([TimeUtil sharedTimeUtil].checkOnlineApiStartTime) forKey:@"event_start_time"];
    [eventCheckOnLineApiParam setObject:@(0) forKey:@"flag_upload"];
    LogEventModel *logEventCheckOnlieApi= [LogEventModel mj_objectWithKeyValues:
                                           eventCheckOnLineApiParam];
    [[DataBaseLogEventManager shareDatabaseManager] insertData:logEventCheckOnlieApi];
}
/**
 *  检查设备是否上线 checkOnlineApi  调用数据库 update 方法
 *
 *  @param eventResult : 0 为失败 1为成功
 */
-(void)logEndEventCheckOnlineApiEventResult:(int)eventResult
{
    [TimeUtil sharedTimeUtil].checkOnlineApiEndTime =  [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *eventEndCheckOnlineApiParam = [self getEventCotegoryWithEventId:6];
    [eventEndCheckOnlineApiParam setObject:@([TimeUtil sharedTimeUtil].checkOnlineApiStartTime) forKey:@"event_start_time"];
    [eventEndCheckOnlineApiParam setObject:@([TimeUtil sharedTimeUtil].checkOnlineApiEndTime) forKey:@"event_end_time"];
    if (_MAC.length > 0 ) {
        [eventEndCheckOnlineApiParam setObject:_MAC forKey:@"device_mac"];
    }
    [eventEndCheckOnlineApiParam setObject:@(1) forKey:@"flag_upload"];
    [eventEndCheckOnlineApiParam setObject:@(eventResult) forKey:@"event_result"];
    LogEventModel *logEventEndlog = [LogEventModel mj_objectWithKeyValues:
                                     eventEndCheckOnlineApiParam];
    [[DataBaseLogEventManager shareDatabaseManager] updateData:logEventEndlog];
}


-(void)NavBackBtnClick{
    [super NavBackBtnClick];
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
