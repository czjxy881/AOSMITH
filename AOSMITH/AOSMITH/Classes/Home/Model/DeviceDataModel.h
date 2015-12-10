//
//  DeviceDataModel.h
//  AOSMITH
//
//  Created by 李晓 on 15/12/8.
//  Copyright © 2015年 aosmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceDataModel : NSObject

-(instancetype)initWithBase64String:(NSString *)base64String;

/**
 *  是否开机
 */
@property (nonatomic,assign) BOOL power;
/**
 *  温度设置
 */
@property (nonatomic,assign) NSInteger settingTemp;
/**
 *  实时温度
 */
@property (nonatomic,assign) NSInteger temp;
/**
 *  加热状态
 */
@property (nonatomic,assign) BOOL hot;
/**
 *  档位
 */
@property (nonatomic,assign) level_type level;
/**
 * 开机时间
 */
@property (nonatomic,copy) NSString *openTime;
/**
 * 关机时间
 */
@property (nonatomic,copy) NSString *closeTime;
/**
 * 当前机器系统时间
 */
@property (nonatomic,copy) NSString *deviceTime;
/**
 *  机器故障
 */
//@property (nonatomic,assign) device_error_type deviceError;

@property (nonatomic,copy) NSString *deviceError;


@end
