//
//  TCPManager.m
//  SkywareSDK
//
//  Created by 李晓 on 16/1/13.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import "TCPManager.h"
#import "SkywareConst.h"
#import "SkywareSDKManager.h"
#import "LANDeviceModel.h"
#import "SkywareMQTTModel.h"
#import "SkywareMQTTTool.h"
#import <BaseNetworkTool.h>

@implementation TCPManager
{
    LANDeviceModel *_device;
    NSTimer *_timer;
}

// 心跳包指令
static NSString *command = @"{\"sn\":1022,\"cmd\":\"heartbeat\"}";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tcpSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        if (_timer) {
            [_timer invalidate];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeWIFI) name:kSkywareSDKChangeWIFI object:nil];
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(sendHeartbeat) userInfo:nil repeats:YES];
    }
    return self;
}

- (void) ChangeWIFI
{
    _device = nil;
}

- (BOOL) sendToDeviceMAC:(NSString *)mac WithCommand:(NSString *) command
{
    // UDP 是否发现了局域网中的设备
    SkywareSDKManager *skywareSDK = [SkywareSDKManager sharedSkywareSDKManager];
    LANDeviceModel *model = [skywareSDK.LAN_Devices_Dict objectForKey:mac];
    if (model){
        _device = model;
        return [self sendDataWithCommand:command];
    }else{
        [self changeHTTPSendCommand];
    }
    return NO;
}

/**
 *  连接 TCP 连接
 *
 *  @return 连接过程是否成功
 */
- (BOOL) tcpConnect
{
    NSError *error;
    if ([self.tcpSocket connectToHost:_device.IP onPort:PORT_TCP_REMOTE error:&error]) {
        return YES;
    }else{
        NSLog(@"TCP 连接失败 = [%@]",error);
        [self disConnect];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tcpSocket connectToHost:_device.IP onPort:PORT_TCP_REMOTE error:nil];
        });
        return NO;
    }
}

/**
 *  TCP 发送指令
 *  请先保证 TCP 已经连接成功
 *
 *  @param command 指令
 */
- (BOOL) sendDataWithCommand:(NSString *) command
{
    if (!self.tcpSocket.isConnected) {
        if ([self tcpConnect]) {
            [self.tcpSocket writeData:[command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:2.0 tag:100];
            return YES;
        }
    }else{
        [self.tcpSocket writeData:[command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:2.0 tag:100];
        return YES;
    }
    return NO;
}

/**
 *  断开 TCP 连接
 */
-(void)disConnect{
    [self.tcpSocket disconnect];
}

/**
 *  定时发送心跳包
 */
- (void)sendHeartbeat
{
    if (!_device) return;
    if (![BaseNetworkTool isConnectWIFI])return;
    [self sendDataWithCommand:command];
}

/**
 *  小循环发生错误，切换为大循环发送
 */
- (void) changeHTTPSendCommand
{
    if (self.option) {
        self.option();
    }
    self.option = nil;
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(uint16_t)port {
    //    NSLog(@"连接成功---%@----%d",host,port);
    [sock readDataWithTimeout:-1 tag:100];
}

/**
 *  TCP 对象关闭会调用
 *
 *  @param sock TCPSocket
 *  @param err  错误信息
 */
- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    
    NSLog(@"TCP 断开连接 = [%@]",err);
    [self changeHTTPSendCommand];
    if (![BaseNetworkTool isConnectWIFI])return;
    // 断线后延时3秒后重连
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tcpSocket connectToHost:_device.IP onPort:PORT_TCP_REMOTE error:nil];
    });
}

/**
 *  数据发送成功
 *
 *  @param sock TCPSocket
 *  @param tag  Tag
 */
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
    self.option = nil;
    //    NSLog(@"发送数据的sock=%@ tag=%ld",sock,tag);
}

/**
 *  数据发送失败或超时
 *
 *  @param sock    TCPSocket
 *  @param tag     Tag
 *  @param elapsed 设定等待时间
 *  @param length  字节长度
 *
 *  @return 是否继续等待  0 ：不继续  大于0 要等待的秒数
 */
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    NSLog(@"TCP 发送数据超时 sock = [%@] tag = [%ld]",sock,tag);
    [self changeHTTPSendCommand];
    return 0;
}

/**
 *  接收到TCP 返回的消息
 *
 *  @param sock TCPSocket
 *  @param data 返回的数据
 *  @param tag  Tag
 */
- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag {
    
    NSString*ip = [sock connectedHost];
    
    uint16_t port = [sock connectedPort];
    
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    
    NSLog(@"CTP 接收到设备返回数据 Ip = [%@] ; Port = [%d] ; Data = [%@]", ip, port,result);
    
    [sock readDataWithTimeout:-1 tag:tag];//持续接收服务端放回的数据
    SkywareMQTTModel *model = [SkywareMQTTTool conversionMQTTResultWithData:data];
    if (model == nil) return;
    if ([model.cmd isEqualToString:@"download"] || [model.cmd isEqualToString:@"heartbeat"]) return;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSkywareNotificationCenterCurrentDeviceLAN object:nil userInfo:@{kSkywareMQTTuserInfoKey:model}];
}

@end
