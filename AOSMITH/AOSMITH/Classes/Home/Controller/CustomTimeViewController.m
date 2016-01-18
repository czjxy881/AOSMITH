//
//  CustomTimeViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/9.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "CustomTimeViewController.h"
#import "selectDataPickView.h"
#import "CustomModel.h"
#import "SendCommandModel.h"
#import "DeviceDataModel.h"
@interface CustomTimeViewController ()<UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *_sendTime;
    selectDataPickView *_pick;
    NSIndexPath *_indexPath; // 点击的Cell indexPath ，设置选中的时间
}

@property (nonatomic,strong) NSMutableArray *hourArray;
@property (nonatomic,strong) NSMutableArray *minuteArray;
@property (nonatomic,strong) CustomModel *customModel;


@property (nonatomic,strong) SkywareDeviceInfoModel *skywareInfo;


@end

@implementation CustomTimeViewController

static const SendCommandModel *sendCmdModel;

+ (void)initialize
{
    sendCmdModel = [[SendCommandModel alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"时间设定"];
    [self setCellData];
    [kNotificationCenter addObserver:self selector:@selector(selectDatePickViewCenterBtnClick:) name:kSelectCustomDatePickNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(refreshCalculateTime) name:NotifactionUpdateCaculateTime object:nil];
    //获取当前设备的更新时间，计算设备的校准时间
    [kNotificationCenter addObserver:self selector:@selector(downloadDeviceUpdateTime) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [kNotificationCenter removeObserver:self];
}


-(void)downloadDeviceUpdateTime
{
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
            [manager.bind_Devices_Array enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DeviceDataModel *deviceM = [[DeviceDataModel alloc] initWithBase64String: [obj.device_data[@"bin"] toHexStringFromBase64String]];
                deviceM.serverUpdateTime = [obj.device_data[@"updatetime"] integerValue];
                if ([manager.currentDevice.device_mac isEqualToString:obj.device_mac]) {
                    ((DeviceDataModel *)manager.currentDevice.device_data).serverUpdateTime = deviceM.serverUpdateTime;
                }
            }];
        }
    } failure:^(SkywareResult *result) {
        if([result.message intValue] == 404) {//没有设备
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取设备列表失败"];
        }
    }];
}


#pragma mark - MQTT 消息推送
- (void)MQTTMessage:(NSNotification *)not
{
    SkywareMQTTModel *model = [not.userInfo objectForKey:kSkywareMQTTuserInfoKey];
    DeviceDataModel *deviceM = [[DeviceDataModel alloc] initWithBase64String:[[model.data firstObject] toHexStringFromBase64String]];
    NSTimeInterval inster =[NSDate getDiscrepancyData: [self setdataYMD:_sendTime] WithDate:[self setdataYMD:deviceM.deviceTime]];
    if (inster <= 60) {
        [SVProgressHUD showSuccessWithStatus:@"时间校准成功"];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        cell.detailTextLabel.text = _sendTime;
    }else{
        [SVProgressHUD showSuccessWithStatus:@"时间校准失败"];
    }
    [kNotificationCenter removeObserver:self name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
}

- (NSDate *)setdataYMD:(NSString *) hms{
    NSMutableString *ymdhms = [NSMutableString string];
    NSArray *timeArray = [[[NSDate date] FormatterYMDHMS] componentsSeparatedByString:@" "];
    if (timeArray.count) {
        [ymdhms appendString:[timeArray firstObject]];
        [ymdhms appendFormat:@" %@",hms];
    }
    return [ymdhms FormatterDateFromYMDHMS];
}


- (void)setCellData
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    DeviceDataModel *model = manager.currentDevice.device_data;
    BOOL isOpenTime = YES;
    if ([model.openTime rangeOfString:@"--"].location != NSNotFound) {
        isOpenTime = NO;
        self.customModel.open = NO;
    }else{
        self.customModel.open = YES;
    }
    //开启
    BaseSwitchCellItem *item1 = [BaseSwitchCellItem createBaseCellItemWithIcon:nil AndTitle:@"开启" SubTitle:model.settingOpenTime  defaultOpen:isOpenTime ClickOption:nil SwitchOption:^(UISwitch *cellSwitch) {
        if (cellSwitch.on) {
            self.customModel.open = YES;
            //弹出时间选择框
            _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
            NSString *selectWeekStr = cell.detailTextLabel.text;
            [self clickSelectDateWithDefine:selectWeekStr];
        }else{
            self.customModel.open = NO;
            sendCmdModel.openTime = @"ffff";
            _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
            cell.detailTextLabel.text =@"--:--";
        }
    }];
    
    
    BOOL isCloseTime = YES;
    if ([model.closeTime rangeOfString:@"--"].location != NSNotFound) {
        isCloseTime = NO;
        self.customModel.close = NO;
    }else{
        self.customModel.close = YES;
    }
    
    //关闭
    BaseSwitchCellItem *item2 = [BaseSwitchCellItem createBaseCellItemWithIcon:nil AndTitle:@"关闭" SubTitle:model.settingCloseTime defaultOpen:isCloseTime ClickOption:nil SwitchOption:^(UISwitch *cellSwitch) {
        if (cellSwitch.on) {
            self.customModel.close = YES;
            //弹出时间选择框
            _indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
            NSString *selectWeekStr = cell.detailTextLabel.text;
            [self clickSelectDateWithDefine:selectWeekStr];
        }else{
            self.customModel.close = NO;
            sendCmdModel.closeTime = @"ffff";
            _indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
            cell.detailTextLabel.text =@"--:--";
        }
    }];
    
    BaseCellItemGroup  *group = [BaseCellItemGroup createGroupWithItem:@[item1,item2]];
    [self.dataList addObject:group];
    
    //时间校准
    BaseSubtitleCellItem *item3 = [BaseSubtitleCellItem createBaseCellItemWithIcon:nil AndTitle:@"时间校准" SubTitle:model.deviceTime ClickOption:^{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要进行时间校准吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
    }];
    
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithItem:@[item3]];
    group2.headView = group2.headView;
    [self.dataList addObject:group2];
}

#pragma mark - NotificationCenter   时间“确定”按钮
- (void)selectDatePickViewCenterBtnClick:(NSNotification *) nsf
{
    NSString *selectWeekStr = nsf.userInfo[@"selectPick"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    NSLog(@"the indexPath is section= %ld,row = %ld",_indexPath.section,_indexPath.row);
    cell.detailTextLabel.text = selectWeekStr;
    if (_indexPath.row == 0) { //开启
        //刷新定时开的按钮
        
        self.customModel.openTime  = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text;
        NSArray *arry = [self.customModel.openTime componentsSeparatedByString:@":"];
        NSMutableString *mustr = [NSMutableString string];
        [arry enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mustr appendFormat:@"%02lx",[obj integerValue] & 0xff];
        }];
        sendCmdModel.openTime = mustr;
    }else if (_indexPath.row == 1)//关闭
    {
        //刷新定时关的按钮
        
        
        self.customModel.closeTime = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text;
        NSArray *arry = [self.customModel.closeTime componentsSeparatedByString:@":"];
        NSMutableString *mustr = [NSMutableString string];
        [arry enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mustr appendFormat:@"%02lx",[obj integerValue] & 0xff];
        }];
        sendCmdModel.closeTime = mustr;
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _indexPath = indexPath;
    if (indexPath.section == 1) {//时间校准
               [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要进行时间校准吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
    }else{
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *selectWeekStr = cell.detailTextLabel.text;
        [self clickSelectDateWithDefine:selectWeekStr];
    }
}

/**
 *  点击了 Cell 将已经记录的时间传递给datePick
 */
- (void) clickSelectDateWithDefine:(NSString *) define
{
    selectDataPickView *pick = [selectDataPickView createSelectDatePickView];
    _pick = pick;
    pick.pickView.delegate =self ;
    pick.pickView.dataSource = self;
    [self.view addSubview:pick];
    
    UIButton *cover = [UIButton newAutoLayoutView];
    [cover addTarget:pick action:@selector(cleanMethod) forControlEvents:UIControlEventTouchUpInside];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.4;
    [[UIWindow getCurrentWindow] addSubview:cover];
    [cover autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    pick.cleanClick = ^{
        [cover removeFromSuperview];
    };
    pick.frame = CGRectMake(0, kWindowHeight, kWindowWidth, 240);
    [[UIWindow getCurrentWindow] addSubview:pick];
    [UIView animateWithDuration:0.4f animations:^{
        pick.y = (kWindowHeight - pick.height);
    } completion:^(BOOL finished) {
        
    }];
    
    NSArray *array = [define componentsSeparatedByString:@":"];
    [array enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        [pick.pickView selectRow:[[str removeStringFrontZero] integerValue] inComponent:idx animated:YES];
    }];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 24;
    }else{
        return 60;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName : kRGBColor(245, 31, 2, 1),NSFontAttributeName:[UIFont systemFontOfSize:18]};
    NSAttributedString *attributedString = nil;
    if (component == 0) {
        attributedString = [[NSAttributedString alloc] initWithString:self.hourArray[row] attributes:attributeDict];
    }else{
        attributedString = [[NSAttributedString alloc] initWithString:self.minuteArray[row] attributes:attributeDict];
    }
    UILabel *labelView = [[UILabel alloc] init];
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.attributedText = attributedString;
    return labelView;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *compoents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute |  NSCalendarUnitHour fromDate:[NSDate date]];
        NSMutableString *mustr = [NSMutableString string];
        [mustr appendFormat:@"%02lx",compoents.hour & 0xff];
        [mustr appendFormat:@"%02lx",compoents.minute & 0xff];
        [mustr appendFormat:@"%02lx",compoents.second & 0xff];
        _sendTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",compoents.hour,compoents.minute,compoents.second];
        sendCmdModel.deviceTime  = mustr;
        [kNotificationCenter addObserver:self selector:@selector(MQTTMessage:) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    }
}

-(void)refreshCalculateTime
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    DeviceDataModel *model = manager.currentDevice.device_data;
    cell.detailTextLabel.text = model.deviceTime;
}


#pragma mark - 懒加载

- (NSMutableArray *)hourArray
{
    if (!_hourArray) {
        _hourArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<24; i++) {
            [_hourArray addObject:[NSString stringWithFormat:@"%.2d 时",i]];
        }
    }
    return _hourArray;
}

- (NSMutableArray *)minuteArray
{
    if (!_minuteArray) {
        _minuteArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 60; i++) {
            [_minuteArray addObject:[NSString stringWithFormat:@"%.2d 分",i]];
        }
    }
    return _minuteArray;
}

- (CustomModel *)customModel
{
    if (!_customModel) {
        NSString *file = [[NSString getApplicationDocumentsDirectory] stringByAppendingPathComponent:@"/timing.data"];
        _customModel = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        if (!_customModel) {
            _customModel = [[CustomModel alloc] init];
        }
    }
    return _customModel;
}

@end
