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
#import <BaseNetworkTool.h>

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

+ (void)DeviceShareTrueBindDevice:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPostWithUrl:DeviceShareUserBind paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
    
}

+ (void) DeviceBindUserNew:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPostWithUrl:DeviceBindUserNew paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
        [self DeviceGetAllDevicesSuccess:nil failure:nil];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void) DeviceGetShareListNew:(NSArray *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolGetWithUrl:DeviceShareListBind paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}


+ (void)Devicelock:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPostWithUrl:DeviceUserLock paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
        [self DeviceGetAllDevicesSuccess:nil failure:nil];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DeviceUnlock:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPostWithUrl:DeviceUnlock paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
        [self DeviceGetAllDevicesSuccess:nil failure:nil];
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

+ (void) DeviceReleaseShareUser:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPostWithUrl:DeviceReleaseShareUser paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void) DeviceGetUndefinedDevicesSuccess:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolGetWithUrl:DeviceGetUndefinedDevices paramesers:nil requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}


+ (void)DeviceTrueUndefinedDevice:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPostWithUrl:DeviceTrueUndefinedDevices paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DeviceCancelUndefinedDevice:(NSArray *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolDeleteWithUrl:DeviceCancelUndefinedDevices paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DeviceReleaseMasterUser:(NSArray *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolDeleteWithUrl:DeviceReleaseMasterUser paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:kSkywareFindBindUserAllDeviceSuccess object:nil];
                if (!manager.currentDevice) {
                    manager.currentDevice = [manager.bind_Devices_Array firstObject];
                }
            }
        }
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)DevicePushCMD:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [[SkywareNotificationCenter sharedSkywareNotificationCenter] checkMqttConnection];
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

+ (void)DeviceAutoPushCMDWithData:(id) data;
{
    SkywareSDKManager *sdkManager = [SkywareSDKManager sharedSkywareSDKManager];
    if ([data isKindOfClass:[NSArray class]]) {
        if (sdkManager.tcp_Manager && [BaseNetworkTool isConnectWIFI] && sdkManager.LAN_Devices_Dict.count && sdkManager.openLAN) {
            sdkManager.tcp_Manager.option = ^{
                [SkywareDeviceManager DeviceHttpPushCMDWithArray:data];
            };
            if ([SkywareDeviceManager DeviceLANPushCMDWithArray:data]) return;
        }else{
            [SkywareDeviceManager DeviceHttpPushCMDWithArray:data];
        }
    }else if ([data isKindOfClass:[NSString class]]){
        NSString *cmdStr = (NSString *) data;
        if ([cmdStr rangeOfString:@"::"].location != NSNotFound) {
            if (sdkManager.tcp_Manager && [BaseNetworkTool isConnectWIFI] && sdkManager.LAN_Devices_Dict.count && sdkManager.openLAN) {
                sdkManager.tcp_Manager.option = ^{
                    [SkywareDeviceManager DeviceHttpPushCMDWithString:data];
                };
                if ([SkywareDeviceManager DeviceLANPushCMDWithString:data]) return;
            }else{
                [SkywareDeviceManager DeviceHttpPushCMDWithString:data];
            }
        }else{
            if (sdkManager.tcp_Manager && [BaseNetworkTool isConnectWIFI] && sdkManager.LAN_Devices_Dict.count && sdkManager.openLAN) {
                sdkManager.tcp_Manager.option = ^{
                    [SkywareDeviceManager DeviceHttpPushCMDWithEncodeData:data];
                };
                if ([SkywareDeviceManager DeviceLANPushCMDWithEncodeData:data]) return;
            }else{
                [SkywareDeviceManager DeviceHttpPushCMDWithEncodeData:data];
            }
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"未识别的指令"];
    }
    sdkManager.tcp_Manager.option = nil;
}

/**
 *  大循环中发送指令控制设备 json 格式发送
 */
+(void)DeviceHttpPushCMDWithArray:(NSArray *)array
{
    SkywareDeviceInfoModel *info = [SkywareSDKManager sharedSkywareSDKManager].currentDevice;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!info) return;
    [params setObject: info.device_id forKey:@"device_id"];
    [params setObject:[SkywareDeviceManager controlCommandvWithArray:array] forKey:@"commandv"];
    [SkywareDeviceManager DevicePushCMD:params Success:^(SkywareResult *result) {
        NSLog(@"WAN 指令发送成功---%@",params);
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        NSLog(@"WAN 指令发送失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 *  大循环中发送指令控制设备  二进制指令
 */
+(void) DeviceHttpPushCMDWithEncodeData:(NSString *)encodeString
{
    SkywareDeviceInfoModel *info = [SkywareSDKManager sharedSkywareSDKManager].currentDevice;
    NSData *sampleData = [encodeString stringHexToBytes];
    NSString * encodeStr = [sampleData base64EncodedStringWithOptions:0]; //进行base64位编码
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!info) return;
    [params setObject: info.device_id forKey:@"device_id"];
    [params setObject:[SkywareDeviceManager controlCommandvWithEncodedString:encodeStr] forKey:@"commandv"];
    [SkywareDeviceManager DevicePushCMD:params Success:^(SkywareResult *result) {
        NSLog(@"WAN 指令发送成功---%@",params);
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        NSLog(@"WAN 指令发送失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 *  大循环中发送指令控制设备 json 格式发送
 *  array  = @"pw::1" ;   可能是多个。
 */
+ (void) DeviceHttpPushCMDWithString:(NSString *)string
{
    SkywareDeviceInfoModel *info = [SkywareSDKManager sharedSkywareSDKManager].currentDevice;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!info) return;
    [params setObject: info.device_id forKey:@"device_id"];
    [params setObject:[SkywareDeviceManager controlCommandvWithString:string] forKey:@"commandv"];
    [SkywareDeviceManager DevicePushCMD:params Success:^(SkywareResult *result) {
        NSLog(@"WAN 指令发送成功---%@",params);
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        NSLog(@"WAN 指令发送失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 *  小循环中发送指令控制设备 json 格式发送
 */
+ (BOOL)DeviceLANPushCMDWithArray:(NSArray *)array
{
    SkywareSDKManager *sdkManager = [SkywareSDKManager sharedSkywareSDKManager];
    SkywareDeviceInfoModel *info = sdkManager.currentDevice;
    return [sdkManager.tcp_Manager sendToDeviceMAC:info.device_mac WithCommand:[SkywareDeviceManager controlCommandvWithArray:array]];
}

/**
 *  小循环中发送指令控制设备 json 格式发送
 *  string  = @"pw::1" ;
 */
+ (BOOL) DeviceLANPushCMDWithString:(NSString *)string
{
    SkywareSDKManager *sdkManager = [SkywareSDKManager sharedSkywareSDKManager];
    SkywareDeviceInfoModel *info = sdkManager.currentDevice;
    return [sdkManager.tcp_Manager sendToDeviceMAC:info.device_mac WithCommand:[SkywareDeviceManager controlCommandvWithString:string]];
}

/**
 *  小循环中发送指令控制设备  二进制指令
 */
+ (BOOL)DeviceLANPushCMDWithEncodeData:(NSString *)encodeString
{
    SkywareSDKManager *sdkManager = [SkywareSDKManager sharedSkywareSDKManager];
    SkywareDeviceInfoModel *info = sdkManager.currentDevice;
    NSData *sampleData = [encodeString stringHexToBytes];
    NSString * encodeStr = [sampleData base64EncodedStringWithOptions:0]; //进行base64位编码
    return [sdkManager.tcp_Manager sendToDeviceMAC:info.device_mac WithCommand:[SkywareDeviceManager controlCommandvWithEncodedString:encodeStr]];
}

/**
 *  拼接指令串 json 数组格式发送
 *  data  = [pw::1,td::2]
 *  拼接后 {"sn":6958,"cmd":"upload","mac":"ACCF232C6F26","data":[pw::1,td::2]}
 */
+(NSMutableString *)controlCommandvWithArray:(NSArray *)array
{
    NSMutableString  *commandv ;
    commandv= [NSMutableString stringWithString:@"{\"sn\":"];
    [commandv appendFormat: @"%u",cmd_sn];
    [commandv appendFormat:@",\"cmd\":\"%@\",\"data\":[",cmd];
    for (int i = 0; i<array.count; i++) {
        [commandv appendFormat:@"\"%@\"",array[i]];
        if (i != array.count - 1) {
            [commandv appendString:@","];
        }
    }
    [commandv appendString:@"]}\n"];
    return commandv;
}

/**
 *  拼接指令串 json 格式发送
 *  data  = "pw::1" ;
 *  拼接后 {"sn":6958,"cmd":"upload","mac":"ACCF232C6F26","data":["pw::1"]}
 */
+(NSMutableString *)controlCommandvWithString:(NSString *)string
{
    NSMutableString  *commandv ;
    commandv= [NSMutableString stringWithString:@"{\"sn\":"];
    [commandv appendFormat: @"%u",cmd_sn];
    [commandv appendFormat:@",\"cmd\":\"%@\",\"data\":[",cmd];
    [commandv appendFormat:@"\"%@\"",string];
    [commandv appendString:@"]}\n"];
    return commandv;
}

/**
 *  拼接指令串  二进制指令
 *  encodeData = @"IgI=";
 *  拼接后    {"sn":1135,"cmd":"download","data":["IgI="]}
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
