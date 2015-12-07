//
//  SkywareMQTTModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/22.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareMQTTModel : NSObject

/***  心跳包序号 */
@property (nonatomic,assign) NSInteger sn;
/***  设备是否在线 */
@property (nonatomic,assign) NSInteger device_online;
/***  数据 */
@property (nonatomic,strong) NSArray *data;
/***  upload download 上报下达标识 */
@property (nonatomic,copy) NSString *cmd;
/***  MAC 地址 */
@property (nonatomic,copy) NSString *mac;
/***  转换完成后的Dictionary数据 */
@property (nonatomic,strong) NSDictionary *dataDictionary;

@end
