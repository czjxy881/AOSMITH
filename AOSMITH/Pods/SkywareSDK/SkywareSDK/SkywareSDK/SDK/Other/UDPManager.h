//
//  UDPManager.h
//  SkywareSDK
//
//  Created by 李晓 on 16/1/13.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncUdpSocket.h>
#import <GCDAsyncSocket.h>

@interface UDPManager : NSObject

/***  可以发送 UDP Socket */
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;

/**
 *  开启 UDP 广播
 */
-(void)startBroadcast;

/**
 *  关闭 UDP 广播
 */
-(void)stopBroadcast;

@end
