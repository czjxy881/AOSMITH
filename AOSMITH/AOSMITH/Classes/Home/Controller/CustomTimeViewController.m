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
@interface CustomTimeViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
{
    selectDataPickView *_pick;
    NSIndexPath *_indexPath; // 点击的Cell indexPath ，设置选中的时间
}

@property (nonatomic,strong) NSMutableArray *hourArray;
@property (nonatomic,strong) NSMutableArray *minuteArray;
@property (nonatomic,strong) CustomModel *customModel;
@end

@implementation CustomTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"定时设置"];
    [self.dataList addObjectsFromArray:@[@"开启",@"关闭"]];
    [self addNavRightBtn];
    [kNotificationCenter addObserver:self selector:@selector(selectDatePickViewCenterBtnClick:) name:kSelectCustomDatePickNotification object:nil];
    
    NSString *file = [[NSString getApplicationDocumentsDirectory] stringByAppendingPathComponent:@"/timing.data"];
    self.customModel = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    if (!self.customModel) {
        self.customModel = [[CustomModel alloc] init];
    }
}

#pragma mark - Method
- (void) addNavRightBtn
{
    __weak typeof (self) weakSelf = self;
    [self setRightBtnWithImage:nil orTitle:@"确定" ClickOption:^{
        weakSelf.customModel.openTime  = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text;
        weakSelf.customModel.closeTime = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text;
        NSString *file = [[NSString getApplicationDocumentsDirectory] stringByAppendingPathComponent:@"/timing.data"];
        [NSKeyedArchiver archiveRootObject:weakSelf.customModel toFile:file];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CustomTimeViewControllerCellID = @"CustomTimeViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTimeViewControllerCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CustomTimeViewControllerCellID];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.customModel.openTime;
    }else if (indexPath.row == 1){
        cell.detailTextLabel.text = self.customModel.closeTime;
    }
    return cell;
}

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

@end
