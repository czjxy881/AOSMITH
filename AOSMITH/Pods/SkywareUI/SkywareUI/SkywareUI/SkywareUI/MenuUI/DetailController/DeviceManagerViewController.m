//
//  DeviceManagerViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceManagerViewController.h"

@interface DeviceManagerViewController ()

@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设备管理"];
    [self getUserAllDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserAllDevice) name:kDeviceRelseaseUserRefreshTableView object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getUserAllDevice
{
    [self.dataList removeAllObjects];
    [SVProgressHUD show];
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        NSArray *dataArray = [SkywareDeviceInfoModel mj_objectArrayWithKeyValuesArray:result.result];
        [self deviceInfoWithArray:dataArray];
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        if ([result.message isEqualToString:@"404"]) {
            [self.dataList removeAllObjects];
            [self.tableView reloadData];
            [SVProgressHUD showInfoWithStatus:@"暂无设备"];
        }
    }];
}

- (void) deviceInfoWithArray:(NSArray *)dataArray
{
    NSMutableArray *deviceArray= [NSMutableArray array];
    [dataArray enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel *DeviceInfo, NSUInteger idx, BOOL *stop) {
        BaseArrowCellItem *nickName = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:DeviceInfo.device_name SubTitle:[DeviceInfo.device_lock integerValue]== 1? @"未锁定": @"已锁定" ClickOption:^{
            DeviceEditInfoViewController *edit = [[DeviceEditInfoViewController alloc] initWithNibName:@"DeviceEditInfoViewController" bundle:nil];
            edit.DeviceInfo = DeviceInfo;
            [self.navigationController pushViewController:edit animated:YES];
        }];
        [deviceArray addObject:nickName];
    }];
    BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:deviceArray];
    [self.dataList addObject:group];
    [self.tableView reloadData];
}

@end
