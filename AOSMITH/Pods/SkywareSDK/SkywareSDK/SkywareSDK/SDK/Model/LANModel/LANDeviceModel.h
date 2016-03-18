//
//  LANDeviceModel.h
//  SkywareSDK
//
//  Created by 李晓 on 16/1/13.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LANDeviceModel : NSObject

/***  设备的 IP 地址 */
@property (nonatomic,copy) NSString *IP;
/***  设备的 MAC 地址 */
@property (nonatomic,copy) NSString *MAC;
/***  设备的 型号  */
@property (nonatomic,copy) NSString *device_code;


/**
 *  创建 LAN 范围内的DeviceModel
 *
 *  @param array Array
 *
 *  @return DeviceModel
 */
- (instancetype) initWithArray:(NSArray *) array;

@end
