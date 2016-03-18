//
//  SkywareDeviceManager.h
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareHttpTool.h"
#import "SkywareDeviceInfoModel.h"

@interface SkywareDeviceManager : NSObject
/**
 *  检测输入的 SN 码是否合法
 *
 *  [SkywareDeviceManagement DeviceVerifySN:self.codeTextField.text Success:^(SkywareResult *result) {
 *      [self queryDeviceMessage];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD showErrorWithStatus:@"未找到该SN码 请重试"];
 *  }];
 *
 */
+ (void) DeviceVerifySN:(NSString *)sn Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  查询设备信息
 *
 *  SkywareDeviceQueryInfoModel *queryInfo = [[SkywareDeviceQueryInfoModel alloc] init];
 *  queryInfo.mac = _MAC;  * sn|mac|id|link 均可以，以键值对形式请求
 *  [SkywareDeviceManagement DeviceQueryInfo:queryInfo Success:^(SkywareResult *result) {
 *     deviceInfo = [SkywareDeviceInfoModel objectWithKeyValues:result.result];
 *  } failure:^(SkywareResult *result) {
 *      if ([result.status isEqualToString:@"404"]) {
 *      NSLog(@"没有找到设备");
 *      }
 *  }];
 */
+ (void) DeviceQueryInfo:(SkywareDeviceQueryInfoModel *)queryModel Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  更新设备信息
 *
 *  SkywareDeviceUpdateInfoModel *update = [[SkywareDeviceUpdateInfoModel alloc] init];
 *  update.device_mac = _DeviceInfo.device_mac;
 *  update.device_name = self.device_name.text;
 *  update.device_lock = [NSString stringWithFormat:@"%d",!self.switchBtn.isOn];
 *  ......
 *  [SkywareDeviceManagement DeviceUpdateDeviceInfo:update Success:^(SkywareResult *result) {
 *      [self.navigationController popViewControllerAnimated:YES];
 *      [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceRelseaseUserRefreshTableView object:nil];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD showErrorWithStatus:@"修改失败，请稍后重试"];
 *  }];
 */
+ (void)DeviceUpdateDeviceInfo:(SkywareDeviceUpdateInfoModel *)updateModel Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  绑定设备（建立用户与设备的绑定关系）
 *
 *  NSMutableDictionary *params = [NSMutableDictionary dictionary];
 *  [params setObject:_deviceInfo.device_mac forKey:@"device_mac"];
 *  [SkywareDeviceManagement DeviceBindUser:params Success:^(SkywareResult *result) {
 *      [SVProgressHUD showSuccessWithStatus:@"恭喜您，绑定成功"];
 *      [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceRelseaseUserRefreshTableView object:nil];
 *      [self.navigationController popToRootViewControllerAnimated:YES];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD showErrorWithStatus:@"绑定失败，请稍后重试"];
 *  }];
 *
 */
+ (void) DeviceBindUser:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  解除绑定（解除用户与设备的绑定关系）
 *
 *  [SkywareDeviceManagement DeviceReleaseUser:@[_deviceInfo.device_id] Success:^(SkywareResult *result) {
 *      [SVProgressHUD dismiss];
 *      [self.navigationController popViewControllerAnimated:YES];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD showErrorWithStatus:@"解绑失败,请稍后重试"];
 *  }];
 *
 */
+ (void) DeviceReleaseUser:(NSArray *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  获取用户下设备清单
 *
 *  [SkywareDeviceManagement DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
 *      NSArray *deviceArray = [SkywareDeviceInfoModel objectArrayWithKeyValuesArray:result.result];
 *  } failure:^(SkywareResult *result) {
 *
 *  }];
 */
+ (void) DeviceGetAllDevicesSuccess:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;
/**
 *  没有SN码之后新加接口
 *  分享的设备，被分享者确认要绑定该设备
 *  需要token  params device_id
 */

+ (void)DeviceShareTrueBindDevice:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  没有SN码之后新加接口（改动，增加参数  userstate(主用户0，分享用户1)
 *  parameser:  @"devicemac":设备mac地址
 *  @"userstate": 主用户还是分享用户添加 (主用户0，分享用户1)
 *  [SkywareDeviceManager DeviceBindUserNew:@{@"devicemac":_deviceInfo.device_mac,@"userstate":@"0"} Success:^(SkywareResult *result) {
 *      [SVProgressHUD showSuccessWithStatus:kMessageDeviceBindDeviceSuccess];
 *  } failure:^(SkywareResult *result) {
 *      if ([result.message intValue] == 403 ) {
 *          dispatch_async(dispatch_get_main_queue(), ^{
 *          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"该设备您已绑定" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
 *          [alertView show];
 *      });
 *  }else{
 *      [SVProgressHUD showErrorWithStatus:kMessageDeviceBindDeviceError];
 *  }
 *  }];
 *
 */

+ (void) DeviceBindUserNew:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  获取分享的设备列表 SN码
 *  parameser:被分享的设备的deviceid 组成的数组
 *  [SkywareDeviceManager DeviceGetShareListNew:[NSArray arrayWithObject:_currentDeviceId] Success:^(SkywareResult *result) {
 *      if ([result.message intValue] == 200) {
 *      [self.dataList removeAllObjects];
 *      self.dataList = [SkywareUserDeviceBind mj_objectArrayWithKeyValuesArray:result.result];
 *      [self.tableView reloadData];
 *      }
 *      [SVProgressHUD dismiss];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD dismiss];
 *  }];
 */
+ (void) DeviceGetShareListNew:(NSArray *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  主用户解除分享用户与设备之间的绑定关系。 SN码
 *  parameser: @"deviceid":_deviceid,
 *  @"shareid" : 主用户的id
 *  [SkywareDeviceManager DeviceReleaseShareUser:@{@"deviceid":_currentDeviceId,@"shareid":mode.user_id} Success:^(SkywareResult *result) {
 *      if ([result.message intValue] == 200) {
 *      }
 *      [SVProgressHUD dismiss];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD showErrorWithStatus:@"解绑失败"];
 *  }];
 */
+ (void) DeviceReleaseShareUser:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  主用户锁定该设备时，所有分享用户不可操作该设备，不可绑定该设备。SN码
 *
 *  [SkywareDeviceManager Devicelock:@{@"deviceid":self.deviceModel.device_id} Success:^(SkywareResult *result) {
 *      [SVProgressHUD showSuccessWithStatus:@"锁定设备成功"];
 *      [self getUserAllBindDevices];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD showErrorWithStatus:@"锁定设备失败"];
 *  }];
 */
+ (void)Devicelock:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;
/**
 *  主用户解锁该设备，所有分享用户可以操作以及绑定该设备   SN码
 *
 *  [SkywareDeviceManager DeviceUnlock:@{@"deviceid":self.deviceModel.device_id} Success:^(SkywareResult *result) {
 *      [SVProgressHUD showSuccessWithStatus:@"解锁成功"];
 *      [self getUserAllBindDevices];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD showErrorWithStatus:@"解锁失败"];
 *  }];
 */
+ (void)DeviceUnlock:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  获取分享用户的未未确认绑定设备   SN码
 *
 */
+ (void)DeviceGetUndefinedDevicesSuccess:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  分享用户确认绑定设备  SN码
 *
 *  @param parameser <#parameser description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)DeviceTrueUndefinedDevice:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  分享用户取消绑定设备 或 主用户重置设备(主用户解绑） SN码
 *
 *  parameser: 被主用户解绑的设备 device_id 组成的数组
 *  [SkywareDeviceManager DeviceCancelUndefinedDevice:[device_id] Success:^(SkywareResult *result) {
 *      NSLog(@"重置列表成功");
 *  }];
 */
+ (void)DeviceCancelUndefinedDevice:(NSArray *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 * 主用户解绑确认
 *
 *  parameser: 设备device_id
 *  [SkywareDeviceManager DeviceReleaseMasterUser:@[self.deviceModel.device_id] Success:^(SkywareResult *result) {
 *      [SkywareDeviceManager DeviceReleaseUser:@[self.deviceModel.device_id] Success:^(SkywareResult *result) {
 *      [SVProgressHUD showSuccessWithStatus:@"设备解绑成功"];
 *      [self getUserAllBindDevices];
 *  } failure:^(SkywareResult *result) {
 *      [SVProgressHUD showErrorWithStatus:@"解绑失败,请稍后重试"];
 *  }];
 *
 */

+ (void)DeviceReleaseMasterUser:(NSArray *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure;

/**
 *  改变当前正在操作的Device
 *
 *  @param mac 设备的MAC
 */
+ (void) ChangeCurrentDeviceWithMac:(NSString *)mac ;

#pragma mark ----------- 大循环操作

/**
 *  大循环 HTTP 发送指令
 *  App 通过 http post 方式向设备发送指令，控制设备
 */
+ (void) DevicePushCMD:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  大循环中发送指令控制设备 json 数组格式发送
 *  array  = [pw::1,td::2] ;   可能是更多个。
 */
+ (void) DeviceHttpPushCMDWithArray:(NSArray *)array;

/**
 *  大循环中发送指令控制设备  二进制指令
 *  encodeData = @"IgI=";
 *
 *  @param data base64编码前的原始NSString指令
 */
+ (void) DeviceHttpPushCMDWithEncodeData:(NSString *)encodeString;

/**
 *  大循环中发送指令控制设备 json 格式发送
 *  string  = @"pw::1" ;
 */
+ (void) DeviceHttpPushCMDWithString:(NSString *)string;


#pragma mark ----------- 小循环操作

/**
 *  小循环中发送指令控制设备 json 数组格式发送
 *  array  = [pw::1,td::2] ;   可能是更多个。
 */
+ (BOOL) DeviceLANPushCMDWithArray:(NSArray *)array;

/**
 *  小循环中发送指令控制设备 json 格式发送
 *  string  = @"pw::1" ;
 */
+ (BOOL) DeviceLANPushCMDWithString:(NSString *)string;

/**
 *  小循环中发送指令控制设备  二进制指令
 *  encodeData = @"IgI=";
 *
 *  @param data base64编码前的原始NSString指令
 */
+ (BOOL) DeviceLANPushCMDWithEncodeData:(NSString *)encodeString;


#pragma mark ----------- 自动处理大小循环请求

/**
 *  统一发送接口，会自动判断大循环还是小循环
 *
 *  @param data =  Array（["pw::1","sp"::3]） / ("pw::1") /  NSString (@"IgKO=Ybs")
 */
+ (void) DeviceAutoPushCMDWithData:(id) data;


@end
