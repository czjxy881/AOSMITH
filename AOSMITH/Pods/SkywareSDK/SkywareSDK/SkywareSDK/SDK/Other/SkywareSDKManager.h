//
//  SkywareSDKManager.h
//  SkywareSDK
//
//  Created by 李晓 on 15/12/1.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareDeviceInfoModel.h"
#import "SkywareSDKSingleton.h"
#import "UDPManager.h"
#import "TCPManager.h"

typedef enum {
    // 开发
    developer_new,
    developer_old,
    
    // 测试
    testing_new,
    testing_old,
    
    // 正式
    production_new,
    production_old,
} SkywareSDK_Service_Type;

@interface SkywareSDKManager : NSObject

SkywareSDKSingletonH(SkywareSDKManager)

/**
 *  选择服务器的类型 （开发，测试，正式）
 *  不填默认为 : developer_new
 */
@property (nonatomic,assign) SkywareSDK_Service_Type service_type;

/**
 *  MQTT 创建Session ClientId （必填）
 */
@property (nonatomic,assign) NSInteger app_id;

/**
 *  用户登陆以后保存用户Token
 */
@property (nonatomic,copy) NSString *token;

/**
 *  用户绑定的所有设备Array
 *  例子:
 *  @[SkywareDeviceInfoModel,SkywareDeviceInfoModel,...]
 */
@property (nonatomic,strong) NSMutableArray *bind_Devices_Array;

/**
 *  用户绑定的所有设备Dictionary
 *  例子:
 *  Key：device_Mac  Value: SkywareDeviceInfoModel
 */
@property (nonatomic,strong) NSMutableDictionary *bind_Devices_Dict;

/**
 *  局域网内发现的所有设备Dictionary
 *  例子:
 *  Key：device_Mac  Value: device_IP
 */
@property (nonatomic,strong) NSMutableDictionary *LAN_Devices_Dict;

/**
 *  用户当前正在操作的DeviceInfo
 */
@property (nonatomic,strong) SkywareDeviceInfoModel *currentDevice;

/**
 *  当前使用服务器地址
 *  只读属性
 */
@property (nonatomic,copy,readonly) NSString *service;

/**
 *  是否启动小循环
 */
@property (nonatomic,assign,getter = isOpenLan) BOOL openLAN;

#pragma mark ------ Method ------
/**
 *  从后台进入到前台，发送通知
 */
- (void) PostApplicationDidBecomeActive;

/**
 *  切换当前使用的设备
 *
 *  @param mac 要切换的设备的MAC
 */
- (void) changeCurrentDeviceWithMac:(NSString *) mac;

#pragma mark ---- V2.0

/**
 *  启动 SDK 率先调用
 */
- (void)startSkywareSDK;
/**
 *  发送 UDP 广播 Manager
 */
@property (nonatomic,strong) UDPManager *udp_Manager;
/**
 *  发送 指令 TCP Manager
 */
@property (nonatomic,strong) TCPManager *tcp_Manager;

@end
