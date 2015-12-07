//
//  SkywareAddressWeatherModel.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareAddressWeatherModel.h"
#import <UIColor+Extension.h>

@implementation SkywareAddressWeatherModel

- (NSString *) temperature
{
    return [NSString stringWithFormat:@"%@%@",_temperature,@"°"];
}

- (NSString *)humidity
{
    return [NSString stringWithFormat:@"%@%@",_humidity,@"%"];
}

-(NSString *)wind_direct
{
    NSInteger direct = [_wind_direct integerValue];
    switch (direct) {
        case 0:
            return @"无持续风向";
            break;
        case 1:
            return @"东北风";
            break;
        case 2:
            return @"东风";
            break;
        case 3:
            return @"东南风";
            break;
        case 4:
            return @"南风";
            break;
        case 5:
            return @"西南风";
            break;
        case 6:
            return @"西风";
            break;
        case 7:
            return @"西北风";
            break;
        case 8:
            return @"北风";
            break;
        case 9:
            return @"旋转风";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)wind_power
{
    NSInteger direct = [_wind_direct integerValue];
    switch (direct) {
        case 0:
            return @"微风";
            break;
        case 1:
            return @"3～4级";
            break;
        case 2:
            return @"4～5级";
            break;
        case 3:
            return @"5～6级";
            break;
        case 4:
            return @"6～7级";
            break;
        case 5:
            return @"7～8级";
            break;
        case 6:
            return @"8～9级";
            break;
        case 7:
            return @"9～10级";
            break;
        case 8:
            return @"10～11级";
            break;
        case 9:
            return @"11～12级";
            break;
        default:
            return @"";
            break;
    }
}


- (NSString *)aqiQuality
{
    NSInteger aqi = [_aqi integerValue];
    if (0 <= aqi && aqi <= 50) {
        return @"空气质量优";
    }else if (51 <= aqi && aqi <= 100){
        return @"空气良好";
    }else if (101 <= aqi && aqi <= 150){
        return @"轻度污染";
    }else if (151 <= aqi && aqi <= 200){
        return @"中度污染";
    }else if (201 <= aqi && aqi <= 300){
        return @"重度污染";
    }else if (301 <= aqi && aqi <= 400){
        return @"严重污染";
    }else if (401 <= aqi){
        return @"污染爆表";
    }
    return nil;
}

- (NSString *)PM25Quality
{
    NSInteger pm = [_pm integerValue];
    if (0 <= pm && pm <= 35) {
        return @"空气质量优";
    }else if (35 <= pm && pm <= 75){
        return @"空气良好";
    }else if (75 <= pm && pm <= 115){
        return @"轻度污染";
    }else if (115 <= pm && pm <= 150){
        return @"中度污染";
    }else if (150 <= pm && pm <= 250){
        return @"重度污染";
    }else if (250 <= pm && pm <= 350){
        return @"严重污染";
    }else if (350 <= pm){
        return @"污染爆表";
    }
    return nil;
    
}

- (UIColor *)aqiBgColor
{
    NSInteger aqi = [_aqi integerValue];
    if (0 <= aqi && aqi <= 50) {
        return[UIColor colorWithHexString:@"#4fa8ea"];
    }else if (51 <= aqi && aqi <= 100){
        return[UIColor colorWithHexString:@"#4fa8ea"];
    }else if (101 <= aqi && aqi <= 150){
        return[UIColor colorWithHexString:@"#64d114"];
    }else if (151 <= aqi && aqi <= 200){
        return[UIColor colorWithHexString:@"#d59823"];
    }else if (201 <= aqi && aqi <= 300){
        return[UIColor colorWithHexString:@"#847e7e"];
    }else if (301 <= aqi && aqi <= 400){
        return[UIColor colorWithHexString:@"#696978"];
    }else if (401 <= aqi){
        return[UIColor colorWithHexString:@"#696978"];
    }
    return [UIColor whiteColor];
}



@end
