//
//  SkywareAddressWeatherModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SkywareAddressWeatherModel : NSObject

/**
 *  温度
 */
@property (nonatomic,copy) NSString *temperature;
/**
 *  湿度
 */
@property (nonatomic,copy) NSString *humidity;
/**
 *  PM 值
 */
@property (nonatomic,copy) NSString *pm;
/**
 *  空气质量指数
 */
@property (nonatomic,copy) NSString *aqi;
/**
 *  风向
 */
@property (nonatomic,copy) NSString *wind_direct;

/**
 *  风速
 */
@property (nonatomic,copy) NSString *wind_power;

/**
 *  城市名称
 */
@property (nonatomic,copy) NSString *area_name;


// ------------------服务器不返回，只是自己转换------------------------
/**
 *  aqi空气质量
 */
@property (nonatomic,copy) NSString *aqiQuality;
/**
 *  PM2.5空气质量
 */
@property (nonatomic,copy) NSString *PM25Quality;
/**
 *  aqi 北京颜色Color
 */
@property (nonatomic,strong) UIColor *aqiBgColor;

@end
