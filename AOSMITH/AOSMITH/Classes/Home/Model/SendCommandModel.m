//
//  SendCommandModel.m
//  AOSMITH
//
//  Created by 李晓 on 15/12/9.
//  Copyright © 2015年 aosmith. All rights reserved.
//

#import "SendCommandModel.h"

@implementation SendCommandModel


- (void)setPower:(BOOL)power
{
    _power = power;
    NSString *powcmd;
    if (power) { // 开机
        powcmd = @"1001";
    }else{ //关机
        powcmd = @"1000";
    }
    [SkywareDeviceManager DevicePushCMDWithEncodeData:powcmd];
}


- (void)setSettingTemp:(NSInteger)settingTemp
{
    if (_settingTemp == settingTemp)return;
    NSString *tempcmd;
    switch (settingTemp) {
        case 35:
            tempcmd = @"01";
            break;
        case 40:
            tempcmd = @"02";
            break;
        case 45:
            tempcmd = @"03";
            break;
        case 50:
            tempcmd = @"04";
            break;
        case 55:
            tempcmd = @"05";
            break;
        case 60:
            tempcmd = @"06";
            break;
        case 65:
            tempcmd = @"07";
            break;
        case 70:
            tempcmd = @"08";
            break;
        case 75:
            tempcmd = @"09";
            break;
        default:
            break;
    }
    [SkywareDeviceManager DevicePushCMDWithEncodeData:[NSString stringWithFormat:@"%@%@",@"21",tempcmd]];
}

- (void)setLevel:(level_type)level
{
    _level = level;
    NSString *levelcmd;
    if (level == one_level) {
        levelcmd = @"01";
    }else if(level == tow_level){
        levelcmd = @"02";
    }else if(level == three_level){
        levelcmd = @"03";
    }
    [SkywareDeviceManager DevicePushCMDWithEncodeData:[NSString stringWithFormat:@"%@%@",@"22",levelcmd]];
}

- (void)setOpenTime:(NSString *)openTime
{
    _openTime = openTime;
    [SkywareDeviceManager DevicePushCMDWithEncodeData:[NSString stringWithFormat:@"%@%@",@"31",openTime]];
}

- (void)setCloseTime:(NSString *)closeTime
{
    _closeTime = closeTime;
    [SkywareDeviceManager DevicePushCMDWithEncodeData:[NSString stringWithFormat:@"%@%@",@"32",closeTime]];
}

- (void)setDeviceTime:(NSString *)deviceTime
{
    _deviceTime = deviceTime;
    [SkywareDeviceManager DevicePushCMDWithEncodeData:[NSString stringWithFormat:@"%@%@",@"41",deviceTime]];
}



@end
