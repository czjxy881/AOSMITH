//
//  DeviceDataModel.m
//  AOSMITH
//
//  Created by 李晓 on 15/12/8.
//  Copyright © 2015年 aosmith. All rights reserved.
//

#import "DeviceDataModel.h"

@implementation DeviceDataModel

static const NSArray *tempArray;

static const long kLength = 2; // 占16进制2位

+(void)initialize
{
    tempArray = @[@35,@40,@45,@50,@55,@60,@65,@70,@75];
}

-(instancetype)initWithBase64String:(NSString *)base64String
{
    self = [super init];
    if (self) {
        NSString *cmdValue;
        for (long locationStar = 0;locationStar < base64String.length;) {
            NSString *cmdKey = [base64String substringWithRange:NSMakeRange(locationStar, kLength)];
            if ([cmdKey isEqualToString:@"10"]) { // 开关机
                locationStar += kLength;
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength)];
                self.power = [cmdValue removeStringFrontZero].length ? YES :NO;
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"21"]){ // 温度设定
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength)];
                self.settingTemp = [[cmdValue removeStringFrontZero] integerValue];
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"22"]){ // 档位设置
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength)];
                self.level = (level_type)[[cmdValue removeStringFrontZero]integerValue];
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"23"]){ // 实时温度
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength)];
                self.temp = [cmdValue integerValue];
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"24"]){ // 加热状态
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength)];
                self.hot = [cmdValue removeStringFrontZero].length ? YES :NO;
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"31"]){ // 定时开机
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength *2)];
                self.openTime = cmdValue;
                locationStar += kLength *2;
            }else if ([cmdKey isEqualToString:@"32"]){ // 定时关机
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength *2)];
                self.closeTime = cmdValue;
                locationStar += kLength *2;
            }else if ([cmdKey isEqualToString:@"41"]){ // 时间校准
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength *3)];
                self.deviceTime = cmdValue;
                locationStar += kLength *3;
            }else if ([cmdKey isEqualToString:@"0f"]){  //故障状态
                cmdValue = [base64String substringWithRange:NSMakeRange(locationStar, kLength)];
                //                self.deviceError = (device_error_type)[[cmdValue removeStringFrontZero] integerValue];
                self.deviceError = cmdValue;
                locationStar += kLength;
            }
        }
    }
    return self;
}

- (void)setSettingTemp:(NSInteger)settingTemp
{
    if (settingTemp <= tempArray.count) {
        _settingTemp =  [tempArray[settingTemp] integerValue];
    }
}

- (void)setTemp:(NSInteger)temp
{
    _temp = temp;
}

- (void)setOpenTime:(NSString *)openTime
{
    if ([openTime isEqualToString:@"ffff"]) {
        _openTime = @"--:--";
    }else{
        NSString *h =[openTime substringToIndex:2];
        NSString *m = [openTime substringFromIndex:2];
        _openTime = [self getDiscreTimeWithSetting:[NSString stringWithFormat:@"%@:%@",h,m]];
        
    }
}

- (void)setCloseTime:(NSString *)closeTime
{
    if ([closeTime isEqualToString:@"ffff"]) {
        _closeTime = @"--:--";
    }else{
        NSString *h =[closeTime substringToIndex:2];
        NSString *m = [closeTime substringFromIndex:2];
        _closeTime = [self getDiscreTimeWithSetting:[NSString stringWithFormat:@"%@:%@",h,m]];
    }
}

- (void)setDeviceTime:(NSString *)deviceTime
{
    if ([deviceTime isEqualToString:@"ffffff"]) {
        _deviceTime = @"--:--:--";
    }else{
        NSString *h =[deviceTime substringToIndex:2];
        NSString *m = [deviceTime substringWithRange:NSMakeRange(2, 3)];
        NSString *s = [deviceTime substringFromIndex:4];
        _closeTime = [NSString stringWithFormat:@"%@:%@:%@",h,m,s];
    }
}

- (NSString *) getDiscreTimeWithSetting:(NSString *) setting
{
    NSMutableString *ymdhms = [NSMutableString string];
    NSArray *timeArray = [[[NSDate date] FormatterYMDHMS] componentsSeparatedByString:@" "];
    if (timeArray.count) {
        [ymdhms appendString:[[timeArray firstObject] stringValue]];
        [ymdhms appendFormat:@" %@:00",setting];
    }
    
    NSDate *date = [ymdhms FormatterDateFromYMDHMS];
    NSInteger result =[NSDate compareData:[NSDate date] WithDate:date];
    NSTimeInterval timer = 0;
    if (result >= 1) { // 今天
        timer = [NSDate getDiscrepancyData:[NSDate date] WithDate:date];
    }else{  // 明天
        timer =  [NSDate getDiscrepancyData: date WithDate:[NSDate date]];
        timer += 24 * 360;
    }
    NSDate *discreTime = [NSDate dateWithTimeIntervalSince1970:timer];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compoents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:discreTime];
    
    // 获取秒数
    //    CGFloat sec = compoents.second;
    
    // 获取分钟
    CGFloat minute = compoents.minute;
    
    // 获取小时
    CGFloat hour = compoents.hour;
    
    NSMutableString *resultStr = [NSMutableString string];
    if (hour > 0) {
        [resultStr appendFormat:@"%f小时",hour];
    }
    if (minute > 0) {
        [resultStr appendFormat:@"%f分钟",minute];
    }
    [resultStr appendString:@"后执行"];
    return resultStr;
}

- (void)setDeviceError:(NSString *)deviceError
{
    if ([deviceError isEqualToString:@"00"]) {
        _deviceError = @"";
    }else if ([deviceError isEqualToString:@"01"]){
        _deviceError = @"您的设备传感器开路报警，请断电检查设备，或查看说明书";
    }else if ([deviceError isEqualToString:@"02"]){
        _deviceError = @"您的设备传感器短路报警，请断电检查设备，或查看说明书";
    }else if ([deviceError isEqualToString:@"03"]){
        _deviceError = @"您的设备传感器超温报警，请断电检查设备，或查看说明书";
    }else if ([deviceError isEqualToString:@"04"]){
        _deviceError = @"您的设备漏电报警，请断电检查设备，或查看说明书";
    }else if ([deviceError isEqualToString:@"ff"]){
        _deviceError = @"";
    }
}

@end
