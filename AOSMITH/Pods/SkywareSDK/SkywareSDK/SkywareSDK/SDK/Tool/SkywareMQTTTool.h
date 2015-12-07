//
//  SkywareMQTTTool.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/22.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareMQTTModel.h"
#import <MJExtension.h>

@interface SkywareMQTTTool : NSObject

/**
 *  将 MQTT 推送过来的Data 转化为模型
 *
 *  @param data MQTT 推送的data
 *
 *  @return Model
 */
+ (SkywareMQTTModel *)conversionMQTTResultWithData:(NSData *) data;


/**
 *  获取 MQTT 推送后转化为的字典
 *
 *  @param data MQTT 推送的data
 *
 *  @return Dictionary
 */
+ (NSDictionary *)getMQTTStatusDataWithData:(NSData *) data;

@end
