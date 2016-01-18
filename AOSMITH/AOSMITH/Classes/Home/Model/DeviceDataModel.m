//
//  DeviceDataModel.m
//  AOSMITH
//
//  Created by 李晓 on 15/12/8.
//  Copyright © 2015年 aosmith. All rights reserved.
//

#import "DeviceDataModel.h"

@interface DeviceDataModel()
{
    NSTimer *_settingCalculateTimer; //校准时间定时器
    NSTimer *_settingOpenTimer;//定时开启定时器
    NSTimer *_settingCloseTimer;//定时关闭定时器

    NSString *_tempCalculateTimeStr;
}
@end
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
    if (range.location + range.length <= count){
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
        if (_settingOpenTimer) { //停止定时器
            [_settingOpenTimer invalidate];
            _settingOpenTimer = nil;
        }
    }else{
        NSString *h =[openTime substringToIndex:2];
        NSString *m = [openTime substringFromIndex:2];
        _settingOpenTime = [NSString stringWithFormat:@"%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16)];
        _openTime = [self getDiscreTimeWithSetting:[NSString stringWithFormat:@"%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16)] WithType:YES];
        [self startOpenTimer];
    }
    
}

- (void)setCloseTime:(NSString *)closeTime
{
    if ([closeTime isEqualToString:@"ffff"] ||[closeTime isEqualToString:@"0000"]) {
        _closeTime = @"--:--";
        _settingCloseTime = @"--:--";
        if (_settingCloseTimer) { //停止定时器
            [_settingCloseTimer invalidate];
            _settingCloseTimer = nil;
        }
    }else{
        NSString *h =[closeTime substringToIndex:2];
        NSString *m = [closeTime substringFromIndex:2];
        _settingCloseTime = [NSString stringWithFormat:@"%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16)];
        _closeTime = [self getDiscreTimeWithSetting:[NSString stringWithFormat:@"%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16)] WithType:NO];
        [self startCloseTimer];
    }
}

- (void)setDeviceTime:(NSString *)deviceTime
{
    if ([deviceTime isEqualToString:@"ffffff"]) {
        _deviceTime = @"--:--:--";
        if (_settingCalculateTimer) {
            [_settingCloseTimer invalidate];
            _settingCloseTimer = nil;
        }
    }else{
        NSString *h =[deviceTime substringToIndex:2];
        NSString *m = [deviceTime substringWithRange:NSMakeRange(2, 2)];
        NSString *s = [deviceTime substringFromIndex:4];
        _deviceTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",strtol([h UTF8String], nil, 16),strtol([m UTF8String], nil, 16),strtol([s UTF8String], nil, 16)];
        _tempCalculateTimeStr = _deviceTime;
        [self startCalculateTimer];
    }
}


//添加校准定时器，时时更新设备的当前时间
-(void)startCalculateTimer
{
    if (_settingCalculateTimer == nil) {
        _settingCalculateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateDeviceTime) userInfo:nil repeats:YES];
    }
}
-(void)updateDeviceTime
{
    if ([_deviceTime isEqualToString:@"--:--:--"]) {
        return;
    }else{
        //时间转秒再加1转成 时分秒
//        _deviceTime  = @"测试0000";
        //手机时间-服务器获取的SkywareDeviceInfoModel里面的更新时间
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (_serverUpdateTime!=0) {
            NSTimeInterval cha = (now - _serverUpdateTime);
            _deviceTime = [self getDeviceCalulateTime:_tempCalculateTimeStr withTimeInterval:cha];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifactionUpdateCaculateTime object:nil];
        }
    }
}


-(NSString *)getDeviceCalulateTime:(NSString *)time withTimeInterval:(NSTimeInterval )interval
{
    //将_deviceTime 转成NSDate(NSString 转NSDate )加上 时间差 再转成 @“xx:xx:xx”格式
    //1---- NSString 转成NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *deviceDate = [dateFormatter dateFromString:_tempCalculateTimeStr];
    //2---NDDate + NSTimeInterval
    NSDate *deviceCurrentDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:deviceDate];
    //3---NSDate转NSString
    NSString *strDate = [dateFormatter stringFromDate:deviceCurrentDate];
    return strDate;
}


/**
 *  定时开启功能的定时器
 */
-(void)startOpenTimer
{
    if (_settingOpenTimer == nil) {
        _settingOpenTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(updateOpenSettingTime) userInfo:nil repeats:YES];
    }
}

-(void)updateOpenSettingTime
{
    if ([_settingOpenTime isEqualToString:@"--:--"]) {
        return;
    }else{
        _openTime = [self getDiscreTimeWithSetting:_settingOpenTime WithType:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifactionUpdateOpenCloseTime object:nil];
    }
}
/**
 *  定时关闭功能的定时器
 */
-(void)startCloseTimer
{
    if (_settingCloseTimer == nil) {
        _settingCloseTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(updateCloseSettingTime) userInfo:nil repeats:YES];
    }
}


-(void)updateCloseSettingTime
{
    if ([_settingCloseTime isEqualToString:@"--:--"]) {
        return;
    }else{
        _closeTime = [self getDiscreTimeWithSetting:_settingCloseTime WithType:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifactionUpdateOpenCloseTime object:nil];
    }
}



/**
 *
 * 计算定时倒计时时间
 *  @param timeStr timeStr = @"hh:mm"
 */
//-(NSString *)caculateCountTimeWithTime:(NSString *)timeStr
//{
//    NSArray *HourMinute = [timeStr componentsSeparatedByString:@":"];
//    long hour,minute;
//    if (HourMinute.count == 2) {
//        long preHour = [[HourMinute objectAtIndex:0] integerValue];
//        long preMinute = [[HourMinute objectAtIndex:1] integerValue];
//        if (preMinute > 0) {
//            minute = preMinute -1;
//            hour = preHour;
//        }else{
//            hour = preHour -1;
//            minute = 59;
//        }
//        if (hour<0) {
//            hour = 0;
//        }
//        if (minute<0) {
//            minute = 0;
//        }
//        [NSString stringWithFormat:@"%ld:%ld",hour,minute];
//    }
//        return timeStr;
//}

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
        _deviceError = @"未知故障";
    }else{
        _deviceError = @"";
    }
//    if (![_deviceError isEqualToString:@""]) {
//        [self showErrorAlertView];
//    }
}

//-(void)showErrorAlertView
//{
//    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"" message:_deviceError delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [view show];
//}


@end
