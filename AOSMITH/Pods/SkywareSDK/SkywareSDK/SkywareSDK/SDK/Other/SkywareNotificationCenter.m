//
//  SkywareNotificationCenter.m
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SkywareNotificationCenter.h"
#import "SkywareSDK.h"

@interface SkywareNotificationCenter ()<MQTTSessionDelegate>

@end


@implementation SkywareNotificationCenter

LXSingletonM(SkywareNotificationCenter)

static MQTTSession *_secction;
static NSMutableDictionary *_subscribeDic;

+ (void)initialize
{
    _subscribeDic = [NSMutableDictionary dictionary];
    // 创建 MQTT
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSString *clintId = [NSString stringWithFormat:@"%ld",manager.app_id];
    _secction = [[MQTTSession alloc] initWithClientId: clintId];
    [_secction setDelegate:[SkywareNotificationCenter sharedSkywareNotificationCenter]];
    NSString *serviceURL = [NSString stringWithFormat:kMQTTServerHost,[SkywareSDKManager sharedSkywareSDKManager].service];
    [_secction connectAndWaitToHost:serviceURL port:1883 usingSSL:NO];
    
    if (_subscribeDic.count) {
        [_subscribeDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
            [_secction subscribeAndWaitToTopic:value atLevel:MQTTQosLevelAtLeastOnce];
        }];
    }
}

#pragma mark - MQTT_ToolDelegate

- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    if ([topic rangeOfString:manager.currentDevice.device_mac].location != NSNotFound) {
        SkywareMQTTModel *model = [SkywareMQTTTool conversionMQTTResultWithData:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSkywareNotificationCenterCurrentDeviceMQTT object:nil userInfo:@{kSkywareMQTTuserInfoKey:model}];
    }
}

#pragma mark - Method

+ (void) subscribeToTopicWithMAC:(NSString *)mac atLevel:(MQTTQosLevel)qosLevel
{
    if (!_secction) {
        return;
    }
    BOOL subscribeTure;
    if (qosLevel == 0) {
        subscribeTure = [_secction subscribeAndWaitToTopic:kTopic(mac) atLevel:MQTTQosLevelAtLeastOnce];
    }else{
        subscribeTure =  [_secction subscribeAndWaitToTopic:kTopic(mac) atLevel:qosLevel];
    }
    if (subscribeTure) {
        [_subscribeDic setValue:kTopic(mac) forKey:mac];
    }
}

+ (void) unbscribeToTopicWithMAC:(NSString *)mac
{
    BOOL subscribeTure = [_secction unsubscribeTopic:mac];
    if (subscribeTure) {
        [_subscribeDic removeObjectForKey:mac];
    }
}

+ (void)subscribeUserBindDevices
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSArray *devices =manager.bind_Devices_Array;
    [devices enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self subscribeToTopicWithMAC:obj.device_mac atLevel:MQTTQosLevelAtLeastOnce];
    }];
}

+ (void)unbscribeAllAlreadyDevices
{
    [_subscribeDic enumerateKeysAndObjectsUsingBlock:^(NSString  *mac, id obj, BOOL * _Nonnull stop) {
        [self unbscribeToTopicWithMAC:mac];
    }];
}

@end
