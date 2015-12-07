//
//  SkywareDeviceTool.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/21.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareDeviceTool.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation SkywareDeviceTool

+ (instancetype)getWiFiInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

+ (NSString *)getWiFiSSID
{
    NSDictionary *ifs = (NSDictionary *)[SkywareDeviceTool getWiFiInfo];
    NSString *SSID = [ifs objectForKey:@"SSID"];
    if (SSID.length) {
        return SSID;
    }
    return nil;
}

@end
