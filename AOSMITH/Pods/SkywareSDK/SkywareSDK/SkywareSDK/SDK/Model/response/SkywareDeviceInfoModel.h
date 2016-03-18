//
//  SkywareDeviceInfoModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/20.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareDeviceInfoModel : NSObject

/** 设备的ID  */
@property (nonatomic,copy) NSString *device_id ;
/** 设备的MAC  */
@property (nonatomic,copy) NSString *device_mac ;
/** 设备的SN  */
@property (nonatomic,copy) NSString *device_sn ;
/** 设备的名字  */
@property (nonatomic,copy) NSString *device_name ;
/** 产品ID  */
@property (nonatomic,copy) NSString *product_id ;
/** 协议版本号  */
@property (nonatomic,copy) NSString *device_protocol_ver ;
/** wifi版本号  */
@property (nonatomic,copy) NSString *device_wifi_version ;
/** 是否锁定  */
@property (nonatomic,copy) NSString *device_lock ;
/** 是否在线  */
@property (nonatomic,copy) NSString *device_online ;
/** 创建时间  */
@property (nonatomic,copy) NSString *add_time ;
/** 更新时间  */
@property (nonatomic,copy) NSString *update_time ;
/** 设备地址  */
@property (nonatomic,copy) NSString *device_address;
/*** 主用户 被分享用户*/
@property (nonatomic,copy) NSString *user_state; //主用户0，分享用户1
/** 设备当前状态代码  */
@property (nonatomic,strong) id device_data ;

@end
