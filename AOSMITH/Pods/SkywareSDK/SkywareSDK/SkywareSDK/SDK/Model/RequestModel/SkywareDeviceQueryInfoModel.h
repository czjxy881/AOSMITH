//
//  SkywareDeviceQueryInfoModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/14.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  查询设备使用的 Model 可以根据以下参数查询
 *  只能选择一种查询方式
 */
@interface SkywareDeviceQueryInfoModel : NSObject
/**
 *  根据 SN 查询
 */
@property (nonatomic,copy) NSString *sn;
/**
 *  MAC地址 查询
 */
@property (nonatomic,copy) NSString *mac;
/**
 *  ID 查询
 */
@property (nonatomic,copy) NSString *id;
/**
 *  Link查询 (P.S.:link为ssid+key的MD5加密串)
 */
@property (nonatomic,copy) NSString *link;

@end
