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
#import <AddDeviceViewController.h>

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

/**
 *  Slider 温度数值
 */
@property (weak, nonatomic) IBOutlet UILabel *sliderMin;
@property (weak, nonatomic) IBOutlet UILabel *sliderMax;


/*** 用户所有设备的Array */
@property (nonatomic,strong) NSMutableArray *dataList;


@property (nonatomic,strong) SkywareDeviceInfoModel *currentSkywareInfo;//当前设备 -- 用于在多个设备之间切换

@end

@implementation HomeViewController

static NSString *CollectionViewCellID = @"HomeCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarBtn];
    // 冬季模式下默认为采暖 测试默认是地暖
    //    HFInstance *instance = [HFInstance sharedHFInstance];
    //    instance.heatingState = heating_floor;
    //    [self warmOneselfBtnClick:nil];
    // 注册CollectionViewCell
    [self registerCollectionNib];
    //设置温度指示
    [self setTSliderView];
    // 适配
    //    [self setScreenDisplay];
    //    [self downloadDeviceList];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
/**
 *  获取设备列表
 */
-(void)downloadDeviceList
{
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if ([result.message intValue] == 200) {
            NSArray *jsonArray =result.result;
            //首先清空列表
            [self.dataList removeAllObjects];
            [jsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                SkywareDeviceInfoModel *dev = [SkywareDeviceInfoModel objectWithKeyValues:dic];
                NSData* dataFromString = [[NSData alloc] initWithBase64EncodedString:dic[@"device_data"] options:0];//base64解码
                Byte *bytes = (Byte *)[dataFromString bytes];
                NSString *hexStr=@"";
                for(int i=0;i<[dataFromString length];i++)
                {
                    NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
                    if([newHexStr length]==1)
                        hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
                    else
                        hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
                }
                [self.dataList insertObject:dev atIndex:idx];
            }];
            self.pageVC.numberOfPages= self.dataList.count;
            if (self.pageVC.numberOfPages <= 1) {
                self.pageVC.hidden = YES;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self initViewAfterLoadedData];
            });
        }
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        if([result.message intValue] == 404) {//没有设备
            self.pageVC.numberOfPages = 1;
            //#warning  test 添加假设备
            //            NSString *sourceStr = @"20011010210100411f4215";
            //            NSData* sampleData = [sourceStr dataUsingEncoding:NSUTF8StringEncoding]; //开机，夏季
            //            NSString * base64String = [sampleData base64EncodedStringWithOptions:0];
            //            NSDictionary *dictionaryOne = @{@"device_id":@"100435",@"device_mac":@"111",@"device_sn":@"123456",@"device_name":@"我的房间",
            //                                            @"device_online":@"1",
            //                                            @"device_data":base64String,
            //                                            };
            //            SkywareDeviceInfoModel *dev = [SkywareDeviceInfoModel objectWithKeyValues:dictionaryOne];
            //
            //            NSDictionary *dictionaryTwo = @{@"device_id":@"100435",@"device_mac":@"111",@"device_sn":@"123456",@"device_name":@"我的卧室",
            //                                            @"device_online":@"1",
            //                                            @"device_data":base64String,
            //                                            };
            //            SkywareDeviceInfoModel *devTwo = [SkywareDeviceInfoModel objectWithKeyValues:dictionaryTwo];
            //
            //            NSData* dataFromString = [[NSData alloc] initWithBase64EncodedString:base64String options:0];//base64解码
            //            Byte *bytes = (Byte *)[dataFromString bytes];
            //            NSString *hexStr=@"";
            //            for(int i=0;i<[dataFromString length];i++)
            //            {
            //                NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
            //                if([newHexStr length]==1)
            //                    hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
            //                else
            //                    hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
            //            }
            //            dev.device_data = [[DeviceData alloc] initWithBase64String:hexStr];
            //            devTwo.device_data = [[DeviceData alloc] initWithBase64String:hexStr];
            //            [self.dataList insertObject:dev atIndex:0];
            ////            [self.dataList insertObject:devTwo atIndex:1];
            //            _currentSkywareInfo = self.dataList.firstObject;
            //            self.pageVC.numberOfPages= self.dataList.count;
            //            self.pageVC.hidden = YES;
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取设备列表失败"];
        }
    }];
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
        add.isAddDevice = YES;
        [MainDelegate.navigationController pushViewController:add animated:YES];
    }];
}

//
//-(void)updatePowerStatus:(SkywareDeviceInfoModel *)skywareInfo
//{
//    if ([skywareInfo.device_online boolValue]) {
//        DeviceData *deviceData = (DeviceData *)skywareInfo.device_data;
//        if ([deviceData.btnPower boolValue]) { //设备开机
//            [self setDevicePowerButton:_btnPower withDefalutImage:@"home_power_on" PressedImage:@"home_power_on_down"];
//        }else{
//            [self setDevicePowerButton:_btnPower withDefalutImage:@"home_power_off" PressedImage:@"home_power_off_down"];
//        }
//    }else{ //设备离线
//        [self showAlterView:@"设备不在线"];
//    }
//}
#pragma mark -----------温度指示
-(void)setTSliderView
{
    self.tempretureSliderView.delegate = self;
    [self.tempretureSliderView customeSliderView];
}

//-(void)updateTempretureByMode:(DeviceData *)deviceData
//{
//    //    NSArray *colorHang = [NSArray arrayWithObjects:kRGBColor(113, 173, 197, 0.8),kRGBColor(144, 180, 91, 0.8),[UIColor colorWithHue:0.15 saturation:0.9 brightness:0.9 alpha:1.0], kRGBColor(164, 80, 5, 0.9),[UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0], nil];//蓝,绿，黄，浅红，红
//    //    NSArray *positionHang = @[@20, @30, @40, @50, @70];
//    //
//    //    NSArray *colorsWarmer = [NSArray arrayWithObjects:kRGBColor(113, 173, 197, 0.8),[UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0], nil];
//    //    NSArray *positionWarmer = @[@20,  @70];
//    //        [self.tempretureSliderView setPopUpViewAnimatedColors:colorsWarmer withPositions:positionWarmer];
//    HFInstance *instance = deviceData.totalInstance;
//    NSInteger min = [instance.tRange.firstObject integerValue];
//    NSInteger max = [instance.tRange.lastObject integerValue];
//
//    self.tempretureSliderView.minimumValue = min;
//    self.tempretureSliderView.maximumValue = max;
//    self.tempretureSliderView.value = instance.defaultTem;
//
//    self.sliderMin.text = [NSString stringWithFormat:@"%ld°C",min];
//    self.sliderMax.text = [NSString stringWithFormat:@"%ld°C",max];
//    //    NSLog(@"%ld---%ld---%ld",[instance.tRange.firstObject integerValue],[instance.tRange.lastObject integerValue],instance.defaultTem);
//
//}


#pragma mark -ASValueTrackingSliderDelegate
//-(void)sliderDidHidePopUpView:(ASValueTrackingSlider *)slider
//{
//    //存储设定的值
//    DeviceData *deviceData = (DeviceData *)_currentSkywareInfo.device_data;
//    HFInstance *instance = deviceData.totalInstance;
//    instance.defaultTem = (NSInteger)slider.value;
//    //发送指令
//    [SendCommandManager sendSettingTempretureCmd:_currentSkywareInfo];
//}

-(void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider
{
    NSLog(@"the slider value is %lf",slider.value);
}

/**
 *  适配屏幕大小
 */
- (void)setScreenDisplay
{
    if (IS_IPHONE_5_OR_LESS) {
        _homeBtnH.constant = HomeiPhone5s_or_less_3;
        _T_setH.constant = HomeiPhone5s_or_less_1;
        _S_setH.constant = HomeiPhone5s_or_less_3;
        _F_setH.constant = HomeiPhone5s_or_less_3;
        _bottomViewH.constant = HomeiPhone5s_or_less_1 + HomeiPhone5s_or_less_3*3;
    }else if (IS_IPHONE_6_OR_6S){
        _homeBtnH.constant = HomeiPhone6_3;
        _T_setH.constant = HomeiPhone6_1;
        _S_setH.constant = HomeiPhone6_3;
        _F_setH.constant = HomeiPhone6_3;
        self.modelSettingLabel.font = [UIFont systemFontOfSize:16];
        self.deviceModelLabel.font = [UIFont systemFontOfSize:15];
        self.settingTlabel.font = [UIFont systemFontOfSize:16];
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
    // 计算当前页数
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageVC.currentPage = page;
    //    [self initViewAfterLoadedData];
    NSLog(@"----------切换下一个设备--------");
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
}

#pragma mark - UITapGestureRecognizer
//- (IBAction)pushModeVC:(UITapGestureRecognizer *)sender {
//    SettingModelViewController *settingModelVC = [[SettingModelViewController alloc] init];
//    settingModelVC.skywareInfo = _currentSkywareInfo;
//    [self.navigationController pushViewController:settingModelVC animated:YES];
//}

#pragma mark -- ButtonClick

/**
 *  开关机，wifi,添加设备
 *
 *  @param sender 开关机按钮
 */
- (IBAction)changePower:(UIButton *)sender {
    long index = self.pageVC.currentPage;
    if (self.dataList.count) {
        if ( index < self.dataList.count ) {
            SkywareDeviceInfoModel *deviceInfo = [self.dataList objectAtIndex:index];
            if (deviceInfo.device_online.boolValue) {
                //                [SendCommandManager sendDeviceOpenCloseCmd:deviceInfo];
            }else{
                //设备不在线
            }
        }
    }else{
        [self showAlterView:@"您还未添加设备"];
    }
}
/**
 *  设备不在线
 */
-(void)showAlterView:(NSString *)msg
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
}
-(void)setDevicePowerButton:(UIButton *)powerBtn withDefalutImage:(NSString *)defaultImage PressedImage:(NSString *)pressedImage
{
    [powerBtn setImage:[UIImage imageNamed:defaultImage] forState:UIControlStateNormal];
    [powerBtn setImage:[UIImage imageNamed:pressedImage] forState:UIControlStateHighlighted];
}

- (void)MQTTnewMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos
{
    NSLog(@"--Cell_MQTT:%@",[data JSONString]);
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
