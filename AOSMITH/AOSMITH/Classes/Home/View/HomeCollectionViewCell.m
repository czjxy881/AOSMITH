//
//  HomeCollectionViewCell.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/6.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "CoverView.h"
@interface HomeCollectionViewCell ()
{
    NSTimer *_timer;
    UILabel *_centerLabel;
    UILabel *_topLabel;
    UILabel *_bottomLabel;
    CGFloat progress;
}


@property (nonatomic,strong) UIAlertView *errorAlertView;

@end

@implementation HomeCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super initWithCoder:aDecoder];
//    [kNotificationCenter addObserver:self selector:@selector(MQTTMessage:) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    return self;
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

#pragma mark - MQTT 消息推送
//- (void)MQTTMessage:(NSNotification *)not
//{
//    SkywareMQTTModel *model = [not.userInfo objectForKey:kSkywareMQTTuserInfoKey];
//    DeviceDataModel *deviceM = [[DeviceDataModel alloc] initWithBase64String:[[model.data firstObject] toHexStringFromBase64String]];
//    
//    self.deviceData = deviceM;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (IS_IPHONE_4_OR_LESS) {
        self.temp.font = [UIFont systemFontOfSize:HomeiPhone4s_T_Font];
    }else if (IS_IPHONE_5_OR_5S) {
        //        self.temp.font = [UIFont fontWithName:@"STHeitiK-Medium" size:HomeiPhone5s_or_less_T_Font];
        self.temp.font = [UIFont systemFontOfSize:HomeiPhone5s_T_Font];
    
    }else if (IS_IPHONE_6_OR_6S){
        
    }else if (IS_IPHONE_6P_OR_6PS){
        self.temp.font = [UIFont systemFontOfSize:HomeiPhone6plus_T_Font];
    }

    if (IS_IPHONE_5_OR_LESS) {
        self.powerLabel.font = [UIFont systemFontOfSize:24];
    }
}

- (void)setSkywareInfo:(SkywareDeviceInfoModel *)skywareInfo
{
    _skywareInfo = skywareInfo;
    if ([_skywareInfo.device_online boolValue]) { //设备在线
        [CoverView removeCoverView];
        _deviceName.text = skywareInfo.device_name;
        _deviceData = skywareInfo.device_data;
        if (_deviceData.power) {
            self.powerLabel.hidden = YES;
            self.temp.hidden = NO;
            self.centigradeImg.hidden = NO;
            self.thermometer.hidden = NO;
        }else{
            self.powerLabel.text = @"已关机";
            self.powerLabel.hidden = NO;
            self.hotUpLabel.hidden = YES;
            self.temp.hidden = YES;
            self.centigradeImg.hidden = YES;
            self.thermometer.hidden = YES;
        }
        // 温度
        self.temp.text = _deviceData.temp;
        // 设置温度计图片
        if (_deviceData.hot) {
            self.thermometer.image = [UIImage imageNamed:@"thermometer_preservation"];
            self.hotUpLabel.hidden = NO;
            self.hotUpLabel.text = @"加热中";
        }else{
            self.thermometer.image = [UIImage imageNamed:@"thermometer"];
            if (_deviceData.power) {
                self.hotUpLabel.hidden = NO;
                self.hotUpLabel.text = @"保温中";
            }
        }
        if (_deviceData.deviceError.length) { //设备故障
            _deviceName.text = skywareInfo.device_name;
            self.powerLabel.text = @"故障中";
            self.powerLabel.hidden = NO;
            self.hotUpLabel.hidden = YES;
            self.temp.hidden = YES;
            self.centigradeImg.hidden = YES;
            self.thermometer.hidden = YES;
            [CoverView addCoverErrorViewWithHeight:self.frame.size.height];
            if (_errorAlertView==nil) {
                _errorAlertView= [[UIAlertView alloc] initWithTitle:@"提示" message:_deviceData.deviceError delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [_errorAlertView show];
            }
        }else{
            _errorAlertView = nil;
        }
    }else{ //设备不在线
        //添加蒙版
        [CoverView addCoverViewWithHeight:self.frame.size.height];
        _deviceName.text = skywareInfo.device_name;
        self.powerLabel.text = @"已离线";
        self.powerLabel.hidden = NO;
        self.hotUpLabel.hidden = YES;
        self.temp.hidden = YES;
        self.centigradeImg.hidden = YES;
        self.thermometer.hidden = YES;
    }
    
}

//- (void)setDeviceData:(DeviceDataModel *)deviceData
//{
//    _deviceData = deviceData;
//    
//    if (deviceData.power) {
//        self.powerLabel.hidden = YES;
//        self.temp.hidden = NO;
//        self.centigradeImg.hidden = NO;
//        self.thermometer.hidden = NO;
//    }else{
//        self.powerLabel.text = @"已关机";
//        self.powerLabel.hidden = NO;
//        self.hotUpLabel.hidden = YES;
//        self.temp.hidden = YES;
//        self.centigradeImg.hidden = YES;
//        self.thermometer.hidden = YES;
//    }
//    // 温度
//    self.temp.text = deviceData.temp;
//    
//    // 设置温度计图片
//    if (deviceData.hot) {
//        self.thermometer.image = [UIImage imageNamed:@"thermometer_preservation"];
//        self.hotUpLabel.hidden = NO;
//        self.hotUpLabel.text = @"加热中";
//    }else{
//        self.thermometer.image = [UIImage imageNamed:@"thermometer"];
//        if (deviceData.power) {
//            self.hotUpLabel.hidden = NO;
//            self.hotUpLabel.text = @"保温中";
//        }
//    } 
//    
//}


@end
