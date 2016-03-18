//
//  UDPManager.m
//  SkywareSDK
//
//  Created by 李晓 on 16/1/13.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import "UDPManager.h"
#import "SkywareConst.h"
#import "LANDeviceModel.h"
#import "SkywareSDKManager.h"
#import <BaseNetworkTool.h>
#import "SkywareDeviceTool.h"
#import <LXFrameWorkConst.h>

@implementation UDPManager
{
    NSTimer *_timer;
    NSString *_wifiName;
}
- (instancetype)init
{
    if (self = [super init]) {
        dispatch_queue_t udpSocketQueue = dispatch_queue_create("com.skywareSDK.updSocketQueue", DISPATCH_QUEUE_CONCURRENT);
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self  delegateQueue:udpSocketQueue];
        NSError *error;
        if (![self.udpSocket enableBroadcast:YES error:&error]) {
            NSLog(@"UDP_Error enableBroadcast = [%@]",error);
        }
        if (![self.udpSocket bindToPort:PORT_UDP_LOCAL error:&error])
        {
            NSLog(@"UDP_Error bindToPort = [%@]", error);
        }
        if (![self.udpSocket beginReceiving:&error])
        {
            NSLog(@"UDP_Error beginReceiving = [%@]", error);
        }
        if (_timer) {
            [_timer invalidate];
        }
        [self startBroadcast];
        _wifiName = [SkywareDeviceTool getWiFiSSID];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ConnectNetWorkChange) name:kUseWiFiConnectInternet object:nil];
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(startBroadcast) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)startBroadcast
{
    if ([BaseNetworkTool isConnectWIFI]) {
        NSData *data = [NSData dataWithData:[UDP_MASK_CODE dataUsingEncoding:NSASCIIStringEncoding]];
        [self.udpSocket sendData:data toHost:UDP_MASK_HOST port:PORT_UDP_REMOTE withTimeout:3.0 tag:1];
    }
}

- (void)stopBroadcast
{
    [_timer invalidate];
    [self.udpSocket close];
}

- (void)ConnectNetWorkChange
{
    NSString *Wifi = [SkywareDeviceTool getWiFiSSID];
    if (!Wifi.length) return;
    [[SkywareSDKManager sharedSkywareSDKManager].LAN_Devices_Dict removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkywareSDKChangeWIFI object:nil];
    _wifiName = Wifi;
}

#pragma mark -GCDAsyncUdpsocket Delegate

/**
 *  收到 UDP 返回的数据
 *
 *  @param sock          UDPSocket
 *  @param data          返回的数据
 *  @param address       发送端地址
 *  @param filterContext 过滤连接
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSArray *devices = [result componentsSeparatedByString:@";"];
    if (![devices count]) return;
    [devices enumerateObjectsUsingBlock:^(NSString  *str, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *device = [result componentsSeparatedByString:@","];
        LANDeviceModel *model = [[LANDeviceModel alloc] initWithArray:device];
        [self skywareSDKManagerAddLANDevice:model];
    }];
    NSLog(@"UDP 返回的数据 Data =[%@]",result);
}

/**
 *  UDP 关闭
 *
 *  @param sock  UDPSocket
 *  @param error 错误
 */
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"UDP 广播关闭 Error =[%@]",[error description]);
}

/**
 *  将 UDP 发现的设备保存起来
 *
 *  @param lan_Device 发现的DevcieModel
 */
- (void) skywareSDKManagerAddLANDevice:(LANDeviceModel *) lan_Device
{
    SkywareSDKManager *SDKManager = [SkywareSDKManager sharedSkywareSDKManager];
    LANDeviceModel *lan_model = [SDKManager.LAN_Devices_Dict objectForKey:lan_Device.MAC];
    if (lan_model) {
        [SDKManager.LAN_Devices_Dict removeObjectForKey:lan_Device.MAC];
    }
    [SDKManager.LAN_Devices_Dict setObject:lan_Device forKey:lan_Device.MAC];
}

@end
