//
//  SkywareWeatherModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareWeatherModel : NSObject

/**
 *  省份
 */
@property (nonatomic,copy) NSString *province;
/**
 *  市
 */
@property (nonatomic,copy) NSString *city;
/**
 *  地区（非必填）
 */
@property (nonatomic,copy) NSString *district;

@end
