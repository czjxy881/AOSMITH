//
//  SkywareNotificationCenter.m
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SkywareNotificationCenter.h"
#import "SkywareSDK.h"
#import <SystemDeviceTool.h>

@interface SkywareNotificationCenter ()<MQTTSessionDelegate>
@property (nonatomic,strong) MQTTSession *session;
@end

@implementation SkywareNotificationCenter

LXSingletonM(SkywareNotificationCenter)

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!self.session) {
            self.session = [[MQTTSession alloc] initWithClientId: [SystemDeviceTool getUUID]];
            [self.session setDelegate:self];
            [self connectionMQTT];
        }
    }
    return self;
}

/**
 *  创建MQTT 连接
 */
- (void) connectionMQTT
{
    NSString *serviceURL = [NSString stringWithFormat:kMQTTServerHost,[SkywareSDKManager sharedSkywareSDKManager].service];
    [self.session connectAndWaitToHost:serviceURL port:1883 usingSSL:NO];
}

#pragma mark - MQTT_ToolDelegate

- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
//    if ([topic rangeOfString:manager. currentDevice.device_mac].location != NSNotFound) {
        SkywareMQTTModel *model = [SkywareMQTTTool conversionMQTTResultWithData:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSkywareNotificationCenterCurrentDeviceMQTT object:nil userInfo:@{kSkywareMQTTuserInfoKey:model}];
//    }
}

- (void)connected:(MQTTSession *)session{
    NSLog(@"MQTT 连接成功!");
}

- (void)connectionClosed:(MQTTSession *)session
{
    [self connectionMQTT];
    [self subscribeUserBindAllDevices];
    NSLog(@"MQTT 连接断开");
}

- (void)connectionError:(MQTTSession *)session error:(NSError *)error
{
    NSLog(@"MQTT 连接错误 = [%@]",error);
}

#pragma mark - Method

- (void) subscribeToTopicWithMAC:(NSString *)mac atLevel:(MQTTQosLevel)qosLevel
{
    if (!self.session) return;
    if (!mac.length) return;
    
    if (self.session.status == MQTTSessionStatusDisconnecting || self.session.status == MQTTSessionStatusClosed || self.session.status == MQTTSessionStatusError) {
        [self.session close];
        [self connectionMQTT];
    }
    
    BOOL subscribeTure;
    if (qosLevel == 0) {
        subscribeTure = [self.session subscribeAndWaitToTopic:kTopic(mac) atLevel:MQTTQosLevelAtLeastOnce];
    }else{
        subscribeTure =  [self.session subscribeAndWaitToTopic:kTopic(mac) atLevel:qosLevel];
    }
}

- (void) unbscribeToTopicWithMAC:(NSString *)mac
{
    [self.session unsubscribeTopic:kTopic(mac)];
}

- (void)subscribeUserBindAllDevices
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSArray *devices =manager.bind_Devices_Array;
    [devices enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self subscribeToTopicWithMAC:obj.device_mac atLevel:MQTTQosLevelAtLeastOnce];
    }];
}

- (void)unbscribeAllAlreadyDevices
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSArray *devices =manager.bind_Devices_Array;
    [devices enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self unbscribeToTopicWithMAC:obj.device_mac];
    }];
}

@end