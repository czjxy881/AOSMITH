//
//  BaseNetworkTool.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/21.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseNetworkTool : NSObject

/**
 *  开始监控网络连接方式改变
 *
 *  @param url 传入监控的URL
 */
+ (void) startNetWrokWithURL:(NSString *) url;

/**
 *  是否WIFI
 */
+ (BOOL)isConnectWIFI;

/**
 *  是否3G/4G
 */
+ (BOOL)isConnect3G4G;


@end
