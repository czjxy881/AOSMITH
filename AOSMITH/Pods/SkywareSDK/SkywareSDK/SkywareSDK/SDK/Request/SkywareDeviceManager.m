//
//  SkywareDeviceManager.m
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SkywareDeviceManager.h"
#import "SkywareDeviceManager.h"
#import <NSString+Extension.h>
#import <MJExtension.h>
#import <objc/runtime.h>

#define cmd_sn arc4random_uniform(65535)
#define cmd @"download"

@implementation SkywareDeviceManager

+ (void)DeviceVerifySN:(NSString *)sn Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSMutableArray *param = [NSMutableArray array];
    [param addObject:@(manager.app_id)];
    [param addObject:sn];
    [SkywareHttpTool HttpToolGetWithUrl:DeviceCheckSN paramesers:param requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DeviceUpdateDeviceInfo:(SkywareDeviceUpdateInfoModel *)updateModel Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSString *url = [NSString stringWithFormat:@"%@/%@",DeviceUpdateInfo,updateModel.device_mac];
    [SkywareHttpTool HttpToolPutWithUrl:url paramesers:updateModel.mj_keyValues requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
        [self DeviceGetAllDevicesSuccess:nil failure:nil];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DeviceQueryInfo:(SkywareDeviceQueryInfoModel *)queryModel Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    NSMutableArray *parameser = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([SkywareDeviceQueryInfoModel class], &count);
    for (int i= 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        id propertyVal =  [queryModel valueForKeyPath:[NSString stringWithUTF8String:name]];
        if (propertyVal) {
            [parameser addObject:[NSString stringWithFormat:@"%@/%@",[[NSString stringWithUTF8String:name] substringFromIndex:1] ,propertyVal]];
            continue;
        }
    }
    if (!parameser.count) return;
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolGetWithUrl:DeviceQueryInfo paramesers: parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
    
}

+ (void)DeviceBindUser:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPostWithUrl:DeviceBindUser paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
        [self DeviceGetAllDevicesSuccess:nil failure:nil];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DeviceReleaseUser:(NSArray *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolDeleteWithUrl:DeviceReleaseUser paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
        [self DeviceGetAllDevicesSuccess:nil failure:nil];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DeviceGetAllDevicesSuccess:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolGetWithUrl:DeviceGetAllDevices paramesers:nil requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult mj_objectWithKeyValues:json];
        NSInteger message = [result.message integerValue];
        if (message == request_success) {
            manager.bind_Devices_Array = [SkywareDeviceInfoModel mj_objectArrayWithKeyValuesArray:result.result];
            [manager.bind_Devices_Dict removeAllObjects];
            [manager.bind_Devices_Array enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel *dev, NSUInteger idx, BOOL *stop) {
                [manager.bind_Devices_Dict setObject:dev forKey:dev.device_mac];
            }];
            if (manager.bind_Devices_Array.count) {
                if (!manager.currentDevice) {
                    manager.currentDevice = [manager.bind_Devices_Array firstObject];
                }
            }
            [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
        }
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DevicePushCMD:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPostWithUrl:DevicePushCMD paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)ChangeCurrentDeviceWithMac:(NSString *)mac
{
    if (!mac.length)return;
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    manager.currentDevice =  [manager.bind_Devices_Dict objectForKey:mac];
}

/**
 *  发送指令 json
 */
+(void)DevicePushCMDWithData:(NSArray *)data
{
    SkywareDeviceInfoModel *info = [SkywareSDKManager sharedSkywareSDKManager].currentDevice;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!info) return;
    [params setObject: info.device_id forKey:@"device_id"];
    [params setObject:[SkywareDeviceManager controlCommandvWithArray:data] forKey:@"commandv"];
    [SkywareDeviceManager DevicePushCMD:params Success:^(SkywareResult *result) {
        NSLog(@"指令发送成功---%@",params);
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        NSLog(@"指令发送失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 *  发送指令 二进制指令
 */
+(void) DevicePushCMDWithEncodeData:(NSString *)data
{
    SkywareDeviceInfoModel *info = [SkywareSDKManager sharedSkywareSDKManager].currentDevice;
    NSData *sampleData = [data stringHexToBytes];
    NSString * encodeStr = [sampleData base64EncodedStringWithOptions:0]; //进行base64位编码
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!info) return;
    [params setObject: info.device_id forKey:@"device_id"];
    [params setObject:[SkywareDeviceManager controlCommandvWithEncodedString:encodeStr] forKey:@"commandv"];
    [SkywareDeviceManager DevicePushCMD:params Success:^(SkywareResult *result) {
        NSLog(@"指令发送成功---%@",params);
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        NSLog(@"指令发送失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 *  拼接指令串 json 格式发送
 */
+(NSMutableString *)controlCommandvWithArray:(NSArray *)data
{
    NSMutableString  *commandv ;
    commandv= [NSMutableString stringWithString:@"{\"sn\":"];
    [commandv appendFormat: @"%u",cmd_sn];
    [commandv appendFormat:@",\"cmd\":\"%@\",\"data\":[",cmd];
    for (int i = 0; i<data.count; i++) {
        [commandv appendFormat:@"\"%@\"",data[i]];
        if (i != data.count - 1) {
            [commandv appendString:@","];
        }
    }
    [commandv appendString:@"]}\n"];
    return commandv;
}

/**
 *  拼接指令串  二进制指令
 */
+(NSMutableString *)controlCommandvWithEncodedString:(NSString *)encodeData
{
    NSMutableString  *commandv ;
    commandv= [NSMutableString stringWithString:@"{\"sn\":"];
    [commandv appendFormat: @"%u",cmd_sn];
    [commandv appendString:@",\"cmd\":\"download\",\"data\":[\""];
    [commandv appendString:encodeData];
    [commandv appendString:@"\"]}\n"];
    return commandv;
}

@end
