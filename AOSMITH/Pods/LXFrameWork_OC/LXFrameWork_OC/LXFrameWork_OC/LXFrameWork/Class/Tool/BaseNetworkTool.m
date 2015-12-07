//
//  BaseNetworkTool.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/21.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "BaseNetworkTool.h"
#import <Reachability.h>

@interface BaseNetworkTool ()

@end

@implementation BaseNetworkTool

+(void)startNetWrokWithURL:(NSString *)url
{
    Reachability *reach = [Reachability reachabilityWithHostname:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
}

+ (void) reachabilityChanged: (NSNotification*)note {
    Reachability * reach = [note object];
    
    if(![reach isReachable])
    {
        //        [SVProgressHUD showInfoWithStatus:@"网络不可用,请检查设置"];
        return;
    }
    
    if (reach.isReachableViaWiFi) {
        //        [SVProgressHUD showInfoWithStatus:@"通过wifi连接"];
        return;
    }
    
    if (reach.isReachableViaWWAN) {
        //        [SVProgressHUD showInfoWithStatus:@"使用的流量数据"];
        return;
    }
}

// 是否WIFI
+ (BOOL)isConnectWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi);
}

// 是否3G
+ (BOOL)isConnect3G4G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
