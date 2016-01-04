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
#import "DeviceDataModel.h"
#import "SendCommandModel.h"
#import <SkywareNotificationCenter.h>

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ASValueTrackingSliderDelegate>

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
    [self downloadDeviceList];
    //通知
    [self.tempretureSliderView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [kNotificationCenter addObserver:self selector:@selector(MQTTMessage:) name:kSkywareNotificationCenterCurrentDeviceMQTT object:nil];
    [kNotificationCenter addObserver:self selector:@selector(sliderValueChangeEnd) name:@"endTrackingWithTouch" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取设备列表
    [self downloadDeviceList];
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
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
            // 订阅所有设备
            [SkywareNotificationCenter subscribeUserBindDevices];
            
            [self.dataList removeAllObjects];
            [manager.bind_Devices_Array enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DeviceDataModel *deviceM = [[DeviceDataModel alloc] initWithBase64String: [obj.device_data[@"bin"] toHexStringFromBase64String]];
                obj.device_data = deviceM;
                [self.dataList addObject:obj];
                if ([obj.device_mac isEqualToString:manager.currentDevice.device_mac]) {
                    manager.currentDevice = obj;
                }
            }];
            // 更新设备信息
            [self updateDeviceStatus:manager.currentDevice];
            // 设置 分页数
            self.pageVC.numberOfPages = self.dataList.count;
            [self.CollectionView reloadData];
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if([result.message intValue] == 404) {//没有设备
            self.pageVC.numberOfPages = 1;
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
    DeviceDataModel *deviceData = deviceM.device_data;
    _btnPower.hidden = NO;
    if ([deviceM.device_online integerValue]) {
        _btnPower.enabled = YES;
        _btnPower.selected = deviceData.power; // 电源
    }else{
        _btnPower.enabled = NO;
        [self setVisibleItemPowerCellWith:@"已离线"];
    }
    [self updateDeviceStatusWithModel:deviceData];
}

/**
 *  MQTT 更新设备状态
 */
-(void)updateMQTTDeviceStatus:(SkywareMQTTModel *)MqttM
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    DeviceDataModel *deviceM = [[DeviceDataModel alloc] initWithBase64String:[[MqttM.data firstObject] toHexStringFromBase64String]];
    manager.currentDevice.device_data = deviceM;
    
    _btnPower.hidden = NO;
    if (MqttM.device_online) {
        _btnPower.enabled = YES;
        _btnPower.selected = deviceM.power; // 电源
    }else{
        _btnPower.enabled = NO;
        [self setVisibleItemPowerCellWith:@"已离线"];
    }
    [self updateDeviceStatusWithModel:deviceM];
}

- (void) updateDeviceStatusWithModel:(DeviceDataModel *)deviceM
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
    if (deviceM.deviceError.length) { // 设备报警
        [[[UIAlertView alloc] initWithTitle:@"提示" message:deviceM.deviceError delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
    }
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
        collectionViewCell.skywareInfo = self.dataList[indexPath.row];
    }
    return collectionViewCell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageVC.currentPage = page;
    if (self.dataList.count) {
        SkywareDeviceInfoModel *model = self.dataList[page];
        SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
        manager.currentDevice = model;
        [self updateDeviceStatus:model];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
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
        if (!_btnPower.enabled) {  // 去配网
            AddDeviceViewController *add = [[AddDeviceViewController alloc] init];
            add.addDevice = NO;
            [self.navigationController pushViewController: add animated:YES];
        }else if (_btnPower.selected) {  // 开机中，执行关机
            _powerLoding.hidden = NO;
            _btnPower.hidden = YES;
            _powerLoding.text = @"关机中";
            sendCmdModel.power = NO;
        }else{ // 关机中，执行开机
            _powerLoding.hidden = NO;
            _btnPower.hidden = YES;
            _powerLoding.text = @"开机中";
            sendCmdModel.power = YES;
        }
        _btnPower.selected = !_btnPower.selected;
    }else{
        [self showAlterView:@"您还未添加设备"];
    }
}
/**
 *  1档
 */
- (IBAction)oneGearsClick:(UIButton *)sender {
    [self setVisibleItemCellWith:@"切换档位中"];
    sendCmdModel.level = one_level;
}

/**
 *  2档
 */
- (IBAction)twoGearsClick:(UIButton *)sender {
    [self setVisibleItemCellWith:@"切换档位中"];
    sendCmdModel.level = tow_level;
}

/**
 *  3档
 */
- (IBAction)threeGearsClick:(UIButton *)sender {
    [self setVisibleItemCellWith:@"切换档位中"];
    sendCmdModel.level = three_level;
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
-(void)showAlterView:(NSString *)msg
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
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
