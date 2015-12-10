//
//  HomeCollectionViewCell.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/6.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()
{
    NSTimer *_timer;
    UILabel *_centerLabel;
    UILabel *_topLabel;
    UILabel *_bottomLabel;
    CGFloat progress;
}

/***  设备的名称 */
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
/***  温度 Lable */
@property (weak, nonatomic) IBOutlet UILabel *temp;
/***  开关机 Lable */
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
/***  度的image */
@property (weak, nonatomic) IBOutlet UIImageView *centigradeImg;
/***  温度计image */
@property (weak, nonatomic) IBOutlet UIImageView *thermometer;
/***  加热中 */
@property (weak, nonatomic) IBOutlet UILabel *hotUpLabel;

@end

@implementation HomeCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super initWithCoder:aDecoder];
    [kNotificationCenter addObserver:self selector:@selector(MQTTMessage:) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    return self;
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

#pragma mark - MQTT 消息推送
- (void)MQTTMessage:(NSNotification *)not
{
    SkywareMQTTModel *model = [not.userInfo objectForKey:kSkywareMQTTuserInfoKey];
    NSString *deCode_deviceData = [NSString decodeBase64String:[model.data firstObject]];
    DeviceDataModel *deviceM = [[DeviceDataModel alloc] initWithBase64String:deCode_deviceData];
    _deviceData = deviceM;
}

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
}

- (void)setSkywareInfo:(SkywareDeviceInfoModel *)skywareInfo
{
    _skywareInfo = skywareInfo;
    _deviceName.text = skywareInfo.device_name;
    _deviceData = skywareInfo.device_data;
}

- (void)setDeviceData:(DeviceDataModel *)deviceData
{
    _deviceData = deviceData;
    
    if (deviceData.power) {
        self.powerLabel.hidden = YES;
        self.temp.hidden = NO;
        self.centigradeImg.hidden = NO;
        self.thermometer.hidden = NO;
    }else{
        self.powerLabel.hidden = NO;
        self.temp.hidden = YES;
        self.centigradeImg.hidden = YES;
        self.thermometer.hidden = YES;
    }
    // 温度
    self.temp.text = [NSString stringWithFormat:@"%ld",deviceData.temp];
    
    // 设置温度计图片
    if (deviceData.hot) {
        self.thermometer.image = [UIImage imageNamed:@"thermometer_preservation"];
        self.hotUpLabel.hidden = NO;
    }else{
        self.thermometer.image = [UIImage imageNamed:@"thermometer"];
        self.hotUpLabel.hidden = YES;
    }
}


+ (void)load
{
    Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method new = class_getInstanceMethod(self, @selector(_autolayout_replacementLayoutSubviews));
    method_exchangeImplementations(existing, new);
}

@end
