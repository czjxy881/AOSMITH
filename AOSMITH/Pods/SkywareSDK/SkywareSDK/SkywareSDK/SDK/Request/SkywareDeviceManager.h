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
 *  改变当前正在操作的Device
 *
 *  @param mac 设备的MAC
 */
+ (void) ChangeCurrentDeviceWithMac:(NSString *)mac ;

/**
 *  App 通过 http post 方式向设备发送指令，控制设备
 */
+ (void) DevicePushCMD:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  大循环中发送指令控制设备 json 格式发送
 */
+ (void) DevicePushCMDWithData:(NSArray *)data;

/**
 *  大循环中发送指令控制设备  二进制指令
 *
 *  @param data base64编码前的原始NSString指令
 */
+(void) DevicePushCMDWithEncodeData:(NSString *)data;
@end
