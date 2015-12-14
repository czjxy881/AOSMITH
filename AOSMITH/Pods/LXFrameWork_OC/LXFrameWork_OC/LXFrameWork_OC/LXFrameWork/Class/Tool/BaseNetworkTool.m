//
//  BaseNetworkTool.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/21.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "BaseNetworkTool.h"
#import <Reachability.h>
#import "LXFrameWorkConst.h"

@interface BaseNetworkTool ()

@end

@implementation BaseNetworkTool

+(void)startNetWrokWithURL:(NSString *)url
{
    Reachability *reach = [Reachability reachabilityWithHostname:url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [reach startNotifier];
}

+ (void) reachabilityChanged: (NSNotification*)note {
    Reachability * reach = [note object];
    
    if(![reach isReachable])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kUseDisconnectInternet object:nil];
        return;
    }
    
    if (reach.isReachableViaWiFi) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kUseWiFiConnectInternet object:nil];
        return;
    }
    
    if (reach.isReachableViaWWAN) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kUseMobileNetworkConnectInternet object:nil];
        return;
    }
}

+ (BOOL)isConnectNetWork{
    return (![[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable);
}

+ (BOOL)isConnectWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi);
}

+ (BOOL)isConnect3G4G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
