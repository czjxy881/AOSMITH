//
//  MQTT_Tool.h
//  WebIntegration
//
//  Created by 李晓 on 15/9/2.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient.h>
#import <LXSingleton.h>

@protocol MQTT_ToolDelegate <NSObject>
@optional

/**
 *  接收到 MQTT 推送消息Delegate
 *
 *  @param session          MQTT session
 *  @param skywareMqttData  转换后的Model
 *  @param topic            订阅的设备
 *  @param qos             传输协议
 */
- (void)MQTTnewMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos;

@end

@interface MQTT_Tool : NSObject

LXSingletonH(MQTT_Tool)

@property (nonatomic,weak) id<MQTT_ToolDelegate> delegate;

/**
 *  App 获取到焦点后重新订阅设备
 */
+ (void) CreateMQTTSection;

/**
 *  App 失去焦点后关闭订阅设备
 */
+ (void) CloseMQTTSecction;

/**
 *  订阅设备
 *
 *  @param mac      设备MAC地址
 *  @param qosLevel 传输定义
 *
 *  “至多一次”，消息发布完全依赖底层 TCP/IP 网络。会发生消息丢失或重复。这一级别可用于如下情况，环境传感器数据，丢失一次读记录无所谓，因为不久后还会有第二次发送。
 *  “至少一次”，确保消息到达，但消息重复可能会发生。
 *  “只有一次”，确保消息到达一次。这一级别可用于如下情况，在计费系统中，消息重复或丢失会导致不正确的结果。
 */
+ (void) subscribeToTopicWithMAC:(NSString *)mac atLevel:(MQTTQosLevel)qosLevel;

/**
 *  停止订阅设备
 *
 *  @param mac 设备MAC地址
 */
+ (void) unbscribeToTopicWithMAC:(NSString *)mac;

@end


