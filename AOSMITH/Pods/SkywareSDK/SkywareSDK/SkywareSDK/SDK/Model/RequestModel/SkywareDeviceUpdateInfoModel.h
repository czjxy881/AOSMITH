//
//  SkywareDeviceUpdateInfoModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/22.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareDeviceUpdateInfoModel : NSObject

/***  省份 */
@property (nonatomic,copy) NSString *province ;
/***  城市 */
@property (nonatomic,copy) NSString *city ;
/*** 区域；地方；行政区 */
@property (nonatomic,copy) NSString *district ;
/*** 设备名称 */
@property (nonatomic,copy) NSString *device_name ;
/*** 设备_MAC */
@property (nonatomic,copy) NSString *device_mac ;
/*** 设备_SN */
@property (nonatomic,copy) NSString *device_sn ;
/*** 是否锁定 */
@property (nonatomic,copy) NSString *device_lock ;
/*** 经度*/
@property (nonatomic,copy) NSString *longitude ;
/*** 纬度*/
@property (nonatomic,copy) NSString *latitude ;
/*** 半径 */
@property (nonatomic,copy) NSString *radius ;
/*** 设备地址 */
@property (nonatomic,copy) NSString *device_address ;
/*** 区域_ID */
@property (nonatomic,copy) NSString *area_id ;
/*** 用户token */
@property (nonatomic,copy) NSString *token ;

@end
