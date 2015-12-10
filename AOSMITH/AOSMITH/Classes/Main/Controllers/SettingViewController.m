//
//  SettingViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/14.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "SettingViewController.h"
#import "DeviceDataModel.h"
#import "SendCommandModel.h"

@interface SettingViewController ()<UIAlertViewDelegate>
{
    NSString *_sendTime;
}
@end

@implementation SettingViewController

static const SendCommandModel *sendCmdModel;

+ (void)initialize
{
    sendCmdModel = [[SendCommandModel alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设置"];
    [self addDataList];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

- (void) addDataList
{
    //    BaseArrowCellItem *item1 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"设备复位" SubTitle:nil ClickOption:^{
    //        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
    //    }];
    //    BaseArrowCellItem *item2 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"位置校准" SubTitle:nil ClickOption:^{
    //        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
    //    }];
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    DeviceDataModel *model = manager.currentDevice.device_data;
    BaseSubtitleCellItem *item1 = [BaseSubtitleCellItem createBaseCellItemWithIcon:nil AndTitle:@"时间校准" SubTitle:model.deviceTime ClickOption:^{
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要进行时间校准吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
    }];
    
    BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:@[item1]];
    [self.dataList addObject:group];
}

#pragma mark - MQTT 消息推送
- (void)MQTTMessage:(NSNotification *)not
{
    SkywareMQTTModel *model = [not.userInfo objectForKey:kSkywareMQTTuserInfoKey];
    NSString *deCode_deviceData = [NSString decodeBase64String:[model.data firstObject]];
    DeviceDataModel *deviceM = [[DeviceDataModel alloc] initWithBase64String:deCode_deviceData];
    NSTimeInterval inster =[NSDate getDiscrepancyData: [self setdataYMD:_sendTime] WithDate:[self setdataYMD:deviceM.deviceTime]];
    if (inster <= 60) {
        [SVProgressHUD showSuccessWithStatus:@"时间校准成功"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"时间校准失败"];
    }
    [kNotificationCenter removeObserver:self];
}

- (NSDate *)setdataYMD:(NSString *) hms{
    NSMutableString *ymdhms = [NSMutableString string];
    NSArray *timeArray = [[[NSDate date] FormatterYMDHMS] componentsSeparatedByString:@" "];
    if (timeArray.count) {
        [ymdhms appendString:[[timeArray firstObject] stringValue]];
        [ymdhms appendFormat:@" %@",hms];
    }
    return [ymdhms FormatterDateFromYMDHMS];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *compoents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute |  NSCalendarUnitHour fromDate:[NSDate date]];
        NSInteger sec = compoents.second;
        NSInteger minute = compoents.minute;
        NSInteger hour = compoents.hour;
        NSString *timeStr = [NSString stringWithFormat:@"%02ld%02ld%02ld",hour,minute,sec];
        _sendTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,sec];
        sendCmdModel.deviceTime = timeStr;
        [kNotificationCenter addObserver:self selector:@selector(MQTTMessage:) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    }
}

@end
