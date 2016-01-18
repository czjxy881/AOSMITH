//
//  SkywareNotificationCenter.h
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient.h>
#import <LXSingleton.h>

@interface SkywareNotificationCenter : NSObject
LXSingletonH(SkywareNotificationCenter)

/**
 *  订阅设备
 *
 *  不传入qosLevel 默认位至多一次
 *
 *  @param mac      设备MAC地址
 *  @param qosLevel 传输定义
 *
 *  “至多一次”，消息发布完全依赖底层 TCP/IP 网络。会发生消息丢失或重复。这一级别可用于如下情况，环境传感器数据，丢失一次读记录无所谓，因为不久后还会有第二次发送。
 *  “至少一次”，确保消息到达，但消息重复可能会发生。
 *  “只有一次”，确保消息到达一次。这一级别可用于如下情况，在计费系统中，消息重复或丢失会导致不正确的结果。
 */
- (void) subscribeToTopicWithMAC:(NSString *)mac atLevel:(MQTTQosLevel)qosLevel;

/**
 *  停止订阅设备
 *
 *  @param mac 设备MAC地址
 */
- (void) unbscribeToTopicWithMAC:(NSString *)mac;

/**
 *  订阅当前用户下所有绑定的设备
 *  请先确定当前用户下绑定的的设备都已经查询到
 */
- (void) subscribeUserBindAllDevices;

/**
 *  停止订阅当前所有已经订阅的设备
 */
- (void) unbscribeAllAlreadyDevices;

@end