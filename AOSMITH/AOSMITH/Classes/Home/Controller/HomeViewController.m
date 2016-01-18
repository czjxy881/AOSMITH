//
//  HomeViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/1.
//  Copyright (c) 2015年 skyware. All rights reserved.
//
#import "HomeViewController.h"
#import "HomeCollectionView.h"
#import "HomeCollectionViewCell.h"
#import "ASValueTrackingSlider.h"
#import "UserMenuViewController.h"
#import "CustomTimeViewController.h"
#import <AddDeviceViewController.h>
#import "CustomModel.h"
#import "UIView+Toast.h"
#import "DeviceDataModel.h"
#import "SendCommandModel.h"
#import "CoverView.h"
#import <SkywareNotificationCenter.h>


//#define kToastCurrentLevelInfo @"设备已在该档"
#define kDeviceOffLine  @"请检查：\n1.设备是否连接电源；\n2.WiFi是否正常；\n3.请尝试重新配置WiFi；\n当检查完毕，请重新刷新；              "

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ASValueTrackingSliderDelegate>

/**
 * btn_control状态码
 */
typedef NS_ENUM(NSInteger,  BTN_CONTROL)
{
    ControlAdd = 1,//添加净化器
    ControlOpen = 2,    //净化器没有开启
    ControlWifi = 3,    //净化器不在线
    ControlClose = 4,    //
};

// ----------------屏幕适配---------------
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeBtnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *T_setH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *S_setH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *F_setH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

/*** 一档按钮 */
@property (weak, nonatomic) IBOutlet UIButton *oneGearsBtn;
/*** 二档按钮 */
@property (weak, nonatomic) IBOutlet UIButton *twoGearsBtn;
/*** 三档按钮 */
@property (weak, nonatomic) IBOutlet UIButton *threeGearsBtn;
/*** 首页的温度指示Slider */
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *tempretureSliderView;
/***  模式设定Label */
@property (weak, nonatomic) IBOutlet UILabel *modelSettingLabel;
/***  当前模式 */
@property (weak, nonatomic) IBOutlet UILabel *deviceModelLabel;
/***  温度设定Label */
@property (weak, nonatomic) IBOutlet UILabel *settingTlabel;
/*** 首页的CollectionView */
@property (weak, nonatomic) IBOutlet HomeCollectionView *CollectionView;
/***  首页的分页展示 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageVC;
/***  Slider 温度数值 */
@property (weak, nonatomic) IBOutlet UILabel *sliderMin;
@property (weak, nonatomic) IBOutlet UILabel *sliderMax;
/*** 用户所有设备的Array */
@property (nonatomic,strong) NSMutableArray *dataList;
/*** 开关机loding... */
@property (weak, nonatomic) IBOutlet UILabel *powerLoding;

@property (nonatomic,assign) BOOL willScroll;
@end

@implementation HomeViewController

static const SendCommandModel *sendCmdModel;

static NSString *CollectionViewCellID = @"HomeCollectionViewCell";

+ (void)initialize
{
    sendCmdModel = [[SendCommandModel alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarBtn];
    // 获取定时信息
    //    [self getTimingTime];
    // 注册 Cell
    [self registerCollectionNib];
    //设置温度指示
    [self setTSliderView];
    // 适配
    [self setScreenDisplay];
    // 获取设备列表
    //    [self downloadDeviceList];
    //通知
    [self.tempretureSliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [kNotificationCenter addObserver:self selector:@selector(MQTTMessage:) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    [kNotificationCenter addObserver:self selector:@selector(sliderValueChangeEnd) name:@"endTrackingWithTouch" object:nil];
    
    [kNotificationCenter addObserver:self selector:@selector(updateOpenCloseTime) name:NotifactionUpdateOpenCloseTime object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取设备列表
    [self downloadDeviceList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _willScroll = NO;
    if (self.dataList.count) {
        SkywareDeviceInfoModel *deviceInfo = [self.dataList objectAtIndex:self.pageVC.currentPage];
        NSString *key = [NSString stringWithFormat:@"%@-currrentDeviceIndex", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        [[NSUserDefaults standardUserDefaults] setObject:deviceInfo.device_mac  forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //移除蒙版
    [CoverView removeCoverView];
}
-(int)getCurrentDeviceIndex
{
    NSString *key = [NSString stringWithFormat:@"%@-currrentDeviceIndex", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    NSString *deviceMac = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    for (int i = 0 ; i < self.dataList.count; i++) {
        SkywareDeviceInfoModel *deviceInfo = [self.dataList objectAtIndex:i];
        if ([deviceInfo.device_mac isEqualToString:deviceMac]) {
            return i;
            break;
        }
    }
    return 0;//如果没有找到则认为是第一个
}


/**
 *  获取定时信息
 */
- (void) getTimingTime
{
    NSString *file = [[NSString getApplicationDocumentsDirectory] stringByAppendingPathComponent:@"/timing.data"];
    CustomModel *customModel = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (customModel) {
        
    }
}

/**
 *  获取设备列表
 */
-(void)downloadDeviceList
{
    [SVProgressHUD showInfoWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeGradient];
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
            // 订阅所有设备
            [[SkywareNotificationCenter sharedSkywareNotificationCenter] subscribeUserBindAllDevices];
            [self.dataList removeAllObjects];
            [manager.bind_Devices_Array enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DeviceDataModel *deviceM = [[DeviceDataModel alloc] initWithBase64String: [obj.device_data[@"bin"] toHexStringFromBase64String]];
                if (obj.device_data[@"updatetime"] !=nil) {
                    deviceM.serverUpdateTime = [obj.device_data[@"updatetime"] integerValue];
                }
                obj.device_data = deviceM;
                [self.dataList addObject:obj];
            }];
            manager.currentDevice =  [self.dataList objectAtIndex:[self getCurrentDeviceIndex]];
            
            if (self.dataList.count>1) {
                self.pageVC.hidden = NO;
            }else{
                self.pageVC.hidden = YES;
            }
            // 更新设备信息
            [self updateDeviceStatus:manager.currentDevice];
            // 设置 分页数
            self.pageVC.numberOfPages = self.dataList.count;
            [self.CollectionView reloadData];
            //            [SVProgressHUD dismiss];
        }else
        {
            //            [SVProgressHUD dismiss];
        }
    } failure:^(SkywareResult *result) {
        //        [SVProgressHUD dismiss];
        if([result.message intValue] == 404) {//没有设备
            [self.dataList removeAllObjects];
            self.pageVC.numberOfPages = 1;
            self.pageVC.hidden = YES;
            //添加蒙版
            [CoverView addCoverViewWithHeight:_CollectionView.frame.size.height];
            [self updateDeviceStatus:nil];
            [self.CollectionView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取设备列表失败"];
        }
    }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setNavBarBtn
{
    //    [self setCenterView: [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Nav_logo"]]];
    [self setNavTitle:@"智能热水器"];
    [self setLeftBtnWithImage:[UIImage imageNamed:@"menu"] orTitle:nil ClickOption:^{
        UserMenuViewController *menu = [[UserMenuViewController alloc] init];
        
        UINavigationController *nav = ((AppDelegate *)[UIApplication sharedApplication].delegate).navigationController;
        //        [((AppDelegate *)[UIApplication sharedApplication].delegate).navigationController pushViewController:menu animated:YES];
        [MainDelegate.navigationController pushViewController:menu animated:YES];
    }];
    [self setRightBtnWithImage:[UIImage imageNamed:@"addDevice"] orTitle:nil ClickOption:^{
        AddDeviceViewController *add = [[AddDeviceViewController alloc] init];
        add.addDevice = YES;
        [MainDelegate.navigationController pushViewController:add animated:YES];
    }];
}

- (void) updateDeviceStatus:(SkywareDeviceInfoModel *)deviceM
{
    if (deviceM==nil) { //未添加设备
        _btnPower.tag = ControlAdd;
        _btnPower.hidden = NO;
        [self setImageOnControllButton:_btnPower WithDefaultImage:@"addDevice" seletecdImage:@"addDevice"];
        DeviceDataModel *nodeviceModel = [[DeviceDataModel alloc] init];
        nodeviceModel.level = 0;
        [self updateDeviceStatusWithModel:nodeviceModel];
    }else{
        DeviceDataModel *deviceData = deviceM.device_data;
        if ([deviceM.device_online boolValue]) {
            if (deviceData.power) {//开机状态下显示关机
                _btnPower.tag = ControlClose;
                _btnPower.hidden = NO;
                _powerLoding.hidden = YES;
                [self setImageOnControllButton:_btnPower WithDefaultImage:@"home_power_off" seletecdImage:@"home_power_off"];
            }else{//显示开机
                _btnPower.tag = ControlOpen;
                _btnPower.hidden = NO;
                _powerLoding.hidden = YES;
                [self setImageOnControllButton:_btnPower WithDefaultImage:@"home_power_on" seletecdImage:@"home_power_on"];
            }
            [self updateDeviceStatusWithModel:deviceData];
        }else{//设备离线
            _btnPower.tag = ControlWifi;
            _powerLoding.hidden = YES;
            _btnPower.hidden = NO;
            [self setImageOnControllButton:_btnPower WithDefaultImage:@"home_wifi_normal" seletecdImage:@"home_wifi_normal"];
            [self updateDeviceStatusWithModel:deviceData];
        }
    }
}

/**
 *  MQTT 更新设备状态
 */
-(void)updateMQTTDeviceStatus:(SkywareMQTTModel *)MqttM
{
    SkywareDeviceInfoModel *deviceInfo = nil;
    if (MqttM.mac && [self.dataList count]>0)
    {
        for (int i=0; i<self.dataList.count; i++) {
            deviceInfo= (SkywareDeviceInfoModel *)[self.dataList objectAtIndex:i];
            if ([deviceInfo.device_mac isEqualToString:MqttM.mac]) {
                if (MqttM.device_online == 0) { //设备掉线的时候才返回
                    deviceInfo.device_online =[NSString stringWithFormat:@"%d",MqttM.device_online] ;
                }else{
                    deviceInfo.device_online = @"1";////掉线之后再上线
                }
                
                deviceInfo.device_data = [[DeviceDataModel alloc] initWithBase64String:[[MqttM.data firstObject] toHexStringFromBase64String]];
                //刷新Cell界面
                dispatch_async(dispatch_get_main_queue(), ^{
                    HomeCollectionViewCell *collectionCell = (HomeCollectionViewCell *) [self.CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    collectionCell.skywareInfo = deviceInfo;
                    //只更新当前设备首页信息---ybyao07
                    SkywareDeviceInfoModel *currentDevice = [self.dataList objectAtIndex:self.pageVC.currentPage];
                    if ([currentDevice.device_mac isEqualToString:MqttM.mac]) {
                        [self updateDeviceStatus:deviceInfo];
                    }
                });
            }
        }
    }
}


- (void)updateDeviceStatusWithModel:(DeviceDataModel *)deviceM
{
    [self setSilderViewTemp:deviceM.settingTemp]; // 温度设置
    if (deviceM.power) {
        _powerLoding.hidden = YES;
        if ([deviceM.closeTime rangeOfString:@"--"].location == NSNotFound) {
            _deviceModelLabel.text = deviceM.closeTime;
        }else{
            _deviceModelLabel.text = @"定时未开启";
        }
    }else{
        _powerLoding.hidden = YES;
        if ([deviceM.openTime rangeOfString:@"--"].location == NSNotFound) {
            _deviceModelLabel.text = deviceM.openTime;
        }else{
            _deviceModelLabel.text = @"定时未开启";
        }
    }
    
    switch (deviceM.level) {  // 档位
        case one_level:
        {
            self.oneGearsBtn.selected = YES;
            self.twoGearsBtn.selected = NO;
            self.threeGearsBtn.selected = NO;
        }
        break;
        case tow_level:
        {
            self.oneGearsBtn.selected = NO;
            self.twoGearsBtn.selected = YES;
            self.threeGearsBtn.selected = NO;
        }
        break;
        case three_level:
        {
            self.oneGearsBtn.selected = NO;
            self.twoGearsBtn.selected = NO;
            self.threeGearsBtn.selected = YES;
        }
        break;
        default:
        {
            self.oneGearsBtn.selected = NO;
            self.twoGearsBtn.selected = NO;
            self.threeGearsBtn.selected = NO;
        }
        break;
    }
    //    if (deviceM.deviceError.length) { // 设备报警
    //        if (_errorAlertView == nil) {
    //            _errorAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:deviceM.deviceError delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //            [_errorAlertView show];
    //            [CoverView addCoverErrorViewWithHeight:_CollectionView.frame.size.height];
    //        }
    //    }
}



#pragma mark -----------温度指示

-(void)setTSliderView
{
    self.tempretureSliderView.delegate = self;
    [self.tempretureSliderView customeSliderView];
}

#pragma mark -ASValueTrackingSliderDelegate

-(void)sliderDidHidePopUpView:(ASValueTrackingSlider *)slider
{
    
}

-(void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider
{
    
}

- (void)sliderValueChange:(ASValueTrackingSlider *)slider
{
    [self setSilderViewTemp:slider.value];
}

/**
 *  发送设定的温度
 */
- (void)sliderValueChangeEnd
{
    [self setVisibleItemCellWith:@"温度设置中"];
    sendCmdModel.settingTemp = self.tempretureSliderView.value;
}

- (void) setSilderViewTemp:(NSInteger) temp
{
    NSInteger value = round(temp);
    if (value <=35) {
        [self.tempretureSliderView setValue:35 animated:YES];
    }else if (35< value && value <=40){
        [self.tempretureSliderView setValue:40 animated:YES];
    }else if (40< value && value <=45){
        [self.tempretureSliderView setValue:45 animated:YES];
    }else if (45< value && value <=50){
        [self.tempretureSliderView setValue:50 animated:YES];
    }else if (50< value && value <=55){
        [self.tempretureSliderView setValue:55 animated:YES];
    }else if (55< value && value <=60){
        [self.tempretureSliderView setValue:60 animated:YES];
    }else if (60< value && value <=65){
        [self.tempretureSliderView setValue:65 animated:YES];
    }else if (65< value && value <=70){
        [self.tempretureSliderView setValue:70 animated:YES];
    }else if (70 < value && value <=75){
        [self.tempretureSliderView setValue:75 animated:YES];
    }
    
    if (value > 70 || value < 40) {
        [self.tempretureSliderView hidePopUpView];
    }else{
        [self.tempretureSliderView showPopUpView];
    }
}

/**
 *  适配屏幕大小
 */
- (void)setScreenDisplay
{
    if (IS_IPHONE_4_OR_LESS) {
        _homeBtnH.constant = HomeiPhone4s_3;
        _T_setH.constant = HomeiPhone4s_1;
        _S_setH.constant = HomeiPhone4s_3;
        _F_setH.constant = HomeiPhone4s_3;
        _bottomViewH.constant = HomeiPhone4s_1 + HomeiPhone4s_3*3;
    }else if (IS_IPHONE_5_OR_5S) {
        _homeBtnH.constant = HomeiPhone5s_3;
        _T_setH.constant = HomeiPhone5s_1;
        _S_setH.constant = HomeiPhone5s_3;
        _F_setH.constant = HomeiPhone5s_3;
        _bottomViewH.constant = HomeiPhone5s_1 + HomeiPhone5s_3*3;
    }else if (IS_IPHONE_6_OR_6S){
        
    }else if (IS_IPHONE_6P_OR_6PS){
        _homeBtnH.constant = HomeiPhone6plus_3;
        _T_setH.constant = HomeiPhone6plus_1;
        _S_setH.constant = HomeiPhone6plus_3;
        _F_setH.constant = HomeiPhone6plus_3;
        _bottomViewH.constant = HomeiPhone6plus_1 + HomeiPhone6plus_3*3;
        self.modelSettingLabel.font = [UIFont systemFontOfSize:16];
        self.deviceModelLabel.font = [UIFont systemFontOfSize:15];
        self.settingTlabel.font = [UIFont systemFontOfSize:16];
    }
}

#pragma mark - MQTT 消息推送
- (void)MQTTMessage:(NSNotification *)not
{
    SkywareMQTTModel *model = [not.userInfo objectForKey:kSkywareMQTTuserInfoKey];
    [self updateMQTTDeviceStatus:model];
}

#pragma mark - CollectionViewDelegate / DataSource

- (void) registerCollectionNib
{
    UINib *xib = [UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil];
    [self.CollectionView registerNib:xib forCellWithReuseIdentifier:CollectionViewCellID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataList.count) {
        return self.dataList.count;
    }else
    {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    if (self.dataList.count > 0) {
        if (_willScroll) {
        }else{
            collectionViewCell.skywareInfo = self.dataList[indexPath.row];
        }
    }else{//没有设备
        collectionViewCell.powerLabel.text = @"未绑定";
        collectionViewCell.powerLabel.hidden = NO;
        collectionViewCell.hotUpLabel.hidden = YES;
        collectionViewCell.temp.hidden = YES;
        collectionViewCell.centigradeImg.hidden = YES;
        collectionViewCell.thermometer.hidden = YES;
        collectionViewCell.deviceName.text = @"热水器";
    }
    return collectionViewCell;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _willScroll = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [CoverView removeCoverView];
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageVC.currentPage = page;
    if (self.dataList.count) {
        SkywareDeviceInfoModel *model = self.dataList[page];
        SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
        manager.currentDevice = model;
        [self updateDeviceStatus:model];
        HomeCollectionViewCell *collectionCell = (HomeCollectionViewCell *) [self.CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageVC.currentPage inSection:0]];
        collectionCell.skywareInfo = self.dataList[page];
    }
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
}



-(void)updateOpenCloseTime
{
    if (self.dataList.count) {
        SkywareDeviceInfoModel *model = self.dataList[self.pageVC.currentPage];
        [self updateDeviceStatus:model];
    }
}


#pragma mark -- ButtonClick

/**
 *  跳转到定时页面
 */
- (IBAction)pushModeVC:(UITapGestureRecognizer *)sender {
    CustomTimeViewController *timeVC = [[CustomTimeViewController alloc] init];
    [self.navigationController pushViewController:timeVC animated:YES];
}

/**
 *  开关机，wifi,添加设备
 *
 *  @param sender 开关机按钮
 */
- (IBAction)changePower:(UIButton *)sender {
    if (self.dataList.count) {
        if([sender tag] == ControlOpen){
            _powerLoding.hidden = NO;
            _powerLoding.text = @"开机中";
            _btnPower.hidden = YES;
            sendCmdModel.power = YES;
        }else if ([sender tag] == ControlClose){
            _powerLoding.hidden = NO;
            _powerLoding.text = @"关机中";
            _btnPower.hidden = YES;
            sendCmdModel.power = NO;
        }
        else if([sender tag] == ControlWifi){
            [self showAlterWifiView];
        }
    }else{
        //直接进入添加设备
        AddDeviceViewController *add = [[AddDeviceViewController alloc] init];
        add.addDevice = YES;
        [MainDelegate.navigationController pushViewController:add animated:YES];
    }
}
/**
 *  1档
 */
- (IBAction)oneGearsClick:(UIButton *)sender {
    if ([self isCurrentLevel:one_level]) {
        return   ;
    }else{
            [self setVisibleItemCellWith:@"切换档位中"];
            sendCmdModel.level = one_level;
        }
}

/**
 *  2档
 */
- (IBAction)twoGearsClick:(UIButton *)sender {
    if ([self isCurrentLevel:tow_level]) {
        
        
        return;
    }else{
        [self setVisibleItemCellWith:@"切换档位中"];
        sendCmdModel.level = tow_level;
    }
}

/**
 *  3档
 */
- (IBAction)threeGearsClick:(UIButton *)sender {
    if ([self isCurrentLevel:three_level]) {
        return ;
    }else{
        [self setVisibleItemCellWith:@"切换档位中"];
        sendCmdModel.level = three_level;
    }
}
/**
 *  如果是当前挡位的话，提醒是当前挡位，不用发送指令
 */
-(BOOL)isCurrentLevel:(level_type)level
{
    SkywareDeviceInfoModel *model = self.dataList[self.pageVC.currentPage];
    
    DeviceDataModel *dataModel = model.device_data;
    if (level == dataModel.level) {
        NSString *toastStr =[NSString stringWithFormat:@"设备已在%@档",(level == one_level?@"I":(level == tow_level?@"II":@"III"))] ;
        [self.view makeToast:toastStr];
        return YES;
    }
    return NO;
}

- (void) setVisibleItemCellWith:(NSString *) alert
{
    HomeCollectionViewCell *collectionCell = (HomeCollectionViewCell *) [self.CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageVC.currentPage inSection:0]];
    collectionCell.hotUpLabel.text  = alert;
}

- (void) setVisibleItemPowerCellWith:(NSString *) alert
{
    HomeCollectionViewCell *collectionCell = (HomeCollectionViewCell *) [self.CollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageVC.currentPage inSection:0]];
    collectionCell.powerLabel.text  = alert;
}

/**
 *  设备不在线
 */
-(void)showAlterWifiView
{
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"设备已离线" message:kDeviceOffLine delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新配置WiFi",@"刷新", nil];
    [view show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) { //重新配网
        AddDeviceViewController *add = [[AddDeviceViewController alloc] init];
        add.addDevice = NO;
        [self.navigationController pushViewController: add animated:YES];
    }
    if (buttonIndex == 2) { //刷新列表
        [self downloadDeviceList];
    }
}


#pragma mark show btnButton image
-(void)setImageOnControllButton:(UIButton *)button WithDefaultImage:(NSString *)defaultImgStr seletecdImage:(NSString *)pressedImgStr
{
    [button setImage:[UIImage imageNamed:defaultImgStr] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:pressedImgStr] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:pressedImgStr] forState:UIControlStateSelected];
}



#pragma mark - 懒加载
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
