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
    selectDataPickView *_pick;
    NSIndexPath *_indexPath; // 点击的Cell indexPath ，设置选中的时间
}

@property (nonatomic,strong) NSMutableArray *hourArray;
@property (nonatomic,strong) NSMutableArray *minuteArray;
@property (nonatomic,strong) CustomModel *customModel;
@end

@implementation CustomTimeViewController

static const SendCommandModel *sendCmdModel;

+ (void)initialize
{
    sendCmdModel = [[SendCommandModel alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"定时设置"];
    [self addNavRightBtn];
    [self setCellData];
    [kNotificationCenter addObserver:self selector:@selector(selectDatePickViewCenterBtnClick:) name:kSelectCustomDatePickNotification object:nil];
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
    
    BaseSwitchCellItem *item1 = [BaseSwitchCellItem createBaseCellItemWithIcon:nil AndTitle:@"开启" SubTitle:model.settingOpenTime  defaultOpen:isOpenTime ClickOption:nil SwitchOption:^(UISwitch *cellSwitch) {
        if (cellSwitch.on) {
            self.customModel.open = YES;
        }else{
            self.customModel.open = NO;
        }
    }];
    
    BOOL isCloseTime = YES;
    if ([model.closeTime rangeOfString:@"--"].location != NSNotFound) {
        isCloseTime = NO;
        self.customModel.close = NO;
    }else{
        self.customModel.close = YES;
    }
    BaseSwitchCellItem *item2 = [BaseSwitchCellItem createBaseCellItemWithIcon:nil AndTitle:@"关闭" SubTitle:model.settingCloseTime defaultOpen:isCloseTime ClickOption:nil SwitchOption:^(UISwitch *cellSwitch) {
        if (cellSwitch.on) {
            self.customModel.close = YES;
        }else{
            self.customModel.close = NO;
        }
    }];
    
    BaseCellItemGroup  *group = [BaseCellItemGroup createGroupWithItem:@[item1,item2]];
    [self.dataList addObject:group];
}

#pragma mark - Method
- (void) addNavRightBtn
{
    __weak typeof (self) weakSelf = self;
    [self setRightBtnWithImage:nil orTitle:@"确定" ClickOption:^{
        if (weakSelf.customModel.open) {
            weakSelf.customModel.openTime  = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text;
            NSArray *arry = [weakSelf.customModel.openTime componentsSeparatedByString:@":"];
            NSMutableString *mustr = [NSMutableString string];
            [arry enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mustr appendFormat:@"%02lx",[obj integerValue] & 0xff];
            }];
            sendCmdModel.openTime = mustr;
        }else{
            sendCmdModel.openTime = @"ffff";
        }
        
        if (weakSelf.customModel.close) {
            weakSelf.customModel.closeTime = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text;
            NSArray *arry = [weakSelf.customModel.closeTime componentsSeparatedByString:@":"];
            NSMutableString *mustr = [NSMutableString string];
            [arry enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mustr appendFormat:@"%02lx",[obj integerValue] & 0xff];
            }];
            sendCmdModel.closeTime = mustr;
        }else{
            sendCmdModel.closeTime = @"ffff";
        }
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
        //        NSString *file = [[NSString getApplicationDocumentsDirectory] stringByAppendingPathComponent:@"/timing.data"];
        //        [NSKeyedArchiver archiveRootObject:weakSelf.customModel toFile:file];
    }];
}

#pragma mark - NotificationCenter
- (void)selectDatePickViewCenterBtnClick:(NSNotification *) nsf
{
    NSString *selectWeekStr = nsf.userInfo[@"selectPick"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.detailTextLabel.text = selectWeekStr;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _indexPath = indexPath;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    NSString *selectWeekStr = cell.detailTextLabel.text;
    [self clickSelectDateWithDefine:selectWeekStr];
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
