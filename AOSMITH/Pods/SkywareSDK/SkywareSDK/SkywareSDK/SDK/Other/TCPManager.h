//
//  TCPManager.h
//  SkywareSDK
//
//  Created by 李晓 on 16/1/13.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
typedef void(^ChangeHttpSend)();
@interface TCPManager : NSObject

@property (nonatomic,strong) GCDAsyncSocket *tcpSocket;

@property (nonatomic, copy) ChangeHttpSend option;

/**
 *  TCP 发送消息给设备
 *
 *  @param mac     发送设备的 MAC
 *  @param command 指令
 *
 *  @return 是否连接成功
 */
- (BOOL) sendToDeviceMAC:(NSString *)mac WithCommand:(NSString *) command;

/**
 *  断开 TCP 连接
 */
-(void)disConnect;

@end
