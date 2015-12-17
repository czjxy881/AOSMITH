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
    tempArray = @[@0,@35,@40,@45,@50,@55,@60,@65,@70,@75];
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
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength)];
                self.power = [cmdValue removeStringFrontZero].length ? YES :NO;
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"21"]){ // 温度设定
                locationStar += kLength;
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength)];
                self.settingTemp = [[cmdValue removeStringFrontZero] integerValue];
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"22"]){ // 档位设置
                locationStar += kLength;
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength)];
                self.level = (level_type)[[cmdValue removeStringFrontZero]integerValue];
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"23"]){ // 实时温度
                locationStar += kLength;
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength)];
                self.temp = cmdValue;
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"24"]){ // 加热状态
                locationStar += kLength;
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength)];
                self.hot = [cmdValue removeStringFrontZero].length ? YES :NO;
                locationStar += kLength;
            }else if ([cmdKey isEqualToString:@"31"]){ // 定时开机
                locationStar += kLength;
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength*2)];
                self.openTime = cmdValue;
                locationStar += kLength *2;
            }else if ([cmdKey isEqualToString:@"32"]){ // 定时关机
                locationStar += kLength;
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength*2)];
                self.closeTime = cmdValue;
                locationStar += kLength *2;
            }else if ([cmdKey isEqualToString:@"41"]){ // 时间校准
                locationStar += kLength;
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength*3)];
                self.deviceTime = cmdValue;
                locationStar += kLength *3;
            }else if ([cmdKey isEqualToString:@"0f"]){  //故障状态
                locationStar += kLength;
                cmdValue = [self subString:base64String WithRange:NSMakeRange(locationStar, kLength)];
                //                self.deviceError = (device_error_type)[[cmdValue removeStringFrontZero] integerValue];
                self.deviceError = cmdValue;
                locationStar += kLength;
            }
        }
    }
    return self;
}

- (NSString *) subString:(NSString *)str WithRange:(NSRange) range
{
    NSInteger count = str.length;
    if (range.location + range.length < count){
        return [str substringWithRange:range];
    }
    return @"";
}

- (void)setSettingTemp:(NSInteger)settingTemp
{
    if (settingTemp <= tempArray.count) {
        _settingTemp =  [tempArray[settingTemp] integerValue];
    }
}

- (void)setTemp:(NSString *)temp
{
    _temp = [[NSString stringWithFormat:@"%ld",strtol([temp UTF8String], nil, 16)] removeStringFrontZero];
}

- (void)setOpenTime:(NSString *)openTime
{
    if ([openTime isEqualToString:@"ffff"] || [openTime isEqualToString:@"0000"]) {
        _openTime = @"--:--";
        _settingOpenTime = @"--:--";
    }else{
        NSString *h =[openTime substringToIndex:2];
        NSString *m = [openTime substringFromIndex:2];
        _settingOpenTime = [NSString stringWithFormat:@"%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16)];
        _openTime = [self getDiscreTimeWithSetting:[NSString stringWithFormat:@"%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16)] WithType:YES];
    }
}

- (void)setCloseTime:(NSString *)closeTime
{
    if ([closeTime isEqualToString:@"ffff"] ||[closeTime isEqualToString:@"0000"]) {
        _closeTime = @"--:--";
        _settingCloseTime = @"--:--";
    }else{
        NSString *h =[closeTime substringToIndex:2];
        NSString *m = [closeTime substringFromIndex:2];
        _settingCloseTime = [NSString stringWithFormat:@"%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16)];
        _closeTime = [self getDiscreTimeWithSetting:[NSString stringWithFormat:@"%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16)] WithType:NO];
    }
}

- (void)setDeviceTime:(NSString *)deviceTime
{
    if ([deviceTime isEqualToString:@"ffffff"]) {
        _deviceTime = @"--:--:--";
    }else{
        NSString *h =[deviceTime substringToIndex:2];
        NSString *m = [deviceTime substringWithRange:NSMakeRange(2, 2)];
        NSString *s = [deviceTime substringFromIndex:4];
        _deviceTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16),strtol([s UTF8String], nil, 16)];
    }
}

- (NSString *)settingCloseTime
{
    if ([_settingCloseTime rangeOfString:@"00:00"].location != NSNotFound) {
        return @"--:--";
    }
    return _settingCloseTime;
}

- (NSString *)settingOpenTime
{
    if ([_settingOpenTime rangeOfString:@"00:00"].location != NSNotFound) {
        return @"--:--";
    }
    return _settingOpenTime;
}

- (NSString *) getDiscreTimeWithSetting:(NSString *) setting WithType:(BOOL) type
{
    NSMutableString *ymdhms = [NSMutableString string];
    NSArray *timeArray = [[[NSDate date] FormatterYMDHMS] componentsSeparatedByString:@" "];
    if (timeArray.count) {
        [ymdhms appendString:[timeArray firstObject]];
        [ymdhms appendFormat:@" %@:00",setting];
    }
    
    NSDate *date = [ymdhms FormatterDateFromYMDHMS];
    NSInteger result =[NSDate compareData:[NSDate date] WithDate:date];
    if (result >= 1) { // 今天
        return [self getcomponentData:date WithType:type];
    }else{  // 明天
        NSDate *date2 = [NSDate dateWithTimeInterval:24 * 3600 sinceDate:date];
        return [self getcomponentData:date2 WithType:type];
    }
}

- (NSString *) getcomponentData:(NSDate*)date WithType:(BOOL) type
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents *compoents =   [calendar components:unit fromDate:[NSDate date] toDate:date options:0];
    // 获取秒数
    //    NSInteger sec = compoents.second;
    
    // 获取分钟
    NSInteger minute = compoents.minute;
    if (minute == 0) {
        minute = 1;
    }
    
    // 获取小时
    NSInteger hour = compoents.hour;
    
    NSMutableString *resultStr = [NSMutableString string];
    if (hour > 0) {
        [resultStr appendFormat:@"%ld小时",hour];
    }
    if (minute > 0) {
        [resultStr appendFormat:@"%ld分钟",minute];
    }
    if (type) {
        [resultStr appendString:@"后开启"];
    }else{
        [resultStr appendString:@"后关闭"];
    }
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
