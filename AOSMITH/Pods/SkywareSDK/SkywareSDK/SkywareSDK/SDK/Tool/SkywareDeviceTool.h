//
//  SkywareDeviceTool.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/21.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareDeviceTool : NSObject

/**
 *  获取无线信息（SSID，MAC...）
 */
+ (instancetype) getWiFiInfo;

/**
 *  获取无线SSID
 */
+ (NSString *) getWiFiSSID;

@end
