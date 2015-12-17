//
//  DeviceManagerViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceManagerViewController.h"

@interface DeviceManagerViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UITableViewDelegate>
/**
 *  记录当前点击的DeviceModel
 */
@property (nonatomic,strong) SkywareDeviceInfoModel *deviceModel;

@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设备管理"];
    [self addItemCellWithBindDevices];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addItemCellWithBindDevices) name:kSkywareFindBindUserAllDeviceSuccess object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) getUserAllBindDevices
{
    [SVProgressHUD show];
    NSMutableArray *deviceArray= [NSMutableArray array];
    [self.dataList removeAllObjects];
    [SkywareDeviceManager DeviceGetAllDevicesSuccess:^(SkywareResult *result) {
        NSArray *array = [SkywareDeviceInfoModel mj_objectArrayWithKeyValuesArray:result.result];
        [array enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel *DeviceInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            BaseArrowCellItem *item = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:DeviceInfo.device_name SubTitle:[DeviceInfo.device_lock integerValue]== 1? @"未锁定": @"已锁定" ClickOption:nil];
            [deviceArray addObject:item];
        }];
        BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:deviceArray];
        [self.dataList addObject:group];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        if ([result.message isEqualToString:@"404"]) {
            [SVProgressHUD showInfoWithStatus:@"暂无设备"];
        }
    }];
}

- (void) addItemCellWithBindDevices
{
    NSMutableArray *deviceArray= [NSMutableArray array];
    [self.dataList removeAllObjects];
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    if (!manager.bind_Devices_Array.count){
        [self getUserAllBindDevices];
        return;
    }
    [manager.bind_Devices_Array enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel *DeviceInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        BaseArrowCellItem *item = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:DeviceInfo.device_name SubTitle:[DeviceInfo.device_lock integerValue]== 1? @"未锁定": @"已锁定" ClickOption:nil];
        [deviceArray addObject:item];
    }];
    BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:deviceArray];
    [self.dataList addObject:group];
    [self.tableView reloadData];
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    self.deviceModel = [manager.bind_Devices_Array objectAtIndex:indexPath.row];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解绑" otherButtonTitles:@"编辑", @"锁定",nil];
    [sheet showInView:[UIWindow getCurrentWindow]];
}

#pragma mark- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // 解绑
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要解绑这台设备吗？（设备解绑后将无法再查看该设备）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = buttonIndex;
        [alertView show];
    }else if(buttonIndex == 1){ // 编辑
        DeviceEditInfoViewController *edit = [[DeviceEditInfoViewController alloc] initWithNibName:@"DeviceEditInfoViewController" bundle:nil];
        edit.DeviceInfo = self.deviceModel;
        [self.navigationController pushViewController:edit animated:YES];
    }else if(buttonIndex == 2){ // 锁定
        if ([_deviceModel.device_lock isEqualToString:@"0"]) {
            [SVProgressHUD showErrorWithStatus:@"该设备已锁定"];
            return;
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要锁定这台设备吗？（设备锁定后不能再被其他人建立绑定关系）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = buttonIndex;
        [alertView show];
    }
}

#pragma mark- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) return;
    if (alertView.tag == 0) { //解绑
        [SVProgressHUD show];
        [SkywareDeviceManager DeviceReleaseUser:@[self.deviceModel.device_id] Success:^(SkywareResult *result) {
            [SVProgressHUD showSuccessWithStatus:@"设备解绑成功"];
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"解绑失败,请稍后重试"];
        }];
    }else if (alertView.tag == 2){ // 锁定
        SkywareDeviceUpdateInfoModel *update = [[SkywareDeviceUpdateInfoModel alloc] init];
        update.device_mac = _deviceModel.device_mac;
        update.device_lock = @"0";
        [SVProgressHUD show];
        [SkywareDeviceManager DeviceUpdateDeviceInfo:update Success:^(SkywareResult *result) {
            [SVProgressHUD showSuccessWithStatus:@"锁定设备成功"];
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"锁定设备失败"];
        }];
    }
}

@end
