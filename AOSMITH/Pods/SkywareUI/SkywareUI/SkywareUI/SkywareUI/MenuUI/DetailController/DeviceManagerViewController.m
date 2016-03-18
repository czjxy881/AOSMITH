//
//  DeviceManagerViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "AddDeviceViewController.h"
#import "ShareCodeQRViewController.h"
#import "ShareDeviceListViewController.h"
#import "DeviceUser.h"

typedef NS_ENUM(NSInteger,  AlertViewTag)
{
    AlertViewUnBind = 1,    //解绑
    AlertViewLock = 2,    //锁定
    AlertViewUnlock = 3,    //解锁
    AlertViewResetDevice = 4,
    
};

@interface DeviceManagerViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UITableViewDelegate>
/**
 *  记录当前点击的DeviceModel
 */
@property (nonatomic,strong) SkywareDeviceInfoModel *deviceModel;
@property (nonatomic,strong) NSMutableArray *devicesReset;  //客人的设备被主人重置
@property (nonatomic,strong) NSMutableArray *devicesMasterReset; //主人的设备被别人重置

@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设备管理"];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addItemCellWithBindDevices) name:kSkywareFindBindUserAllDeviceSuccess object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadResetDevicesBeforeAllBindedDevices];
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
        [self.dataList removeAllObjects];
        NSArray *array = [SkywareDeviceInfoModel mj_objectArrayWithKeyValuesArray:result.result];
        [array enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel *DeviceInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            BaseArrowCellItem *item = [BaseArrowCellItem createBaseCellItemWithIcon:[SkywareUIManager sharedSkywareUIManager].DeviceListIconImg AndTitle:DeviceInfo.device_name SubTitle:[DeviceInfo.device_lock integerValue]== 1? @"未锁定": @"已锁定" ClickOption:nil];
            [deviceArray addObject:item];
        }];
        BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:deviceArray];
        [self.dataList addObject:group];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        if ([result.message isEqualToString:@"404"]) {
            [self.dataList removeAllObjects];
            [SVProgressHUD showInfoWithStatus:@"暂无设备"];
            [self.tableView reloadData];
        }
    }];
}


-(void)downloadResetDevicesBeforeAllBindedDevices
{
    [SkywareDeviceManager DeviceGetUndefinedDevicesSuccess:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            NSArray *jsonArray =result.result;
            if (jsonArray.count > 0) {
                [self.devicesReset removeAllObjects];
                for (int i = 0 ; i < jsonArray.count; i++) {
                    DeviceUser *deviceUser = [DeviceUser mj_objectWithKeyValues:jsonArray [i]];
                    //设备状态 1：未确认绑定 3：主用户重新配网
                    if ([deviceUser.device_state intValue]== 3) {//主人重置该设备
                        [self.devicesReset addObject:deviceUser];
                    }
                    if ([deviceUser.device_state intValue] == 4) { //主人的设备被别人重置
                        [self.devicesMasterReset addObject:deviceUser];
                    }
                }
                if (self.devicesReset.count > 0) { //被重置的设备
                    NSMutableString *devicesR = [NSMutableString new];
                    [self.devicesReset enumerateObjectsUsingBlock:^(DeviceUser *deviceU, NSUInteger idx, BOOL * _Nonnull stop) {
                        [devicesR appendString:deviceU.device_name];
                        if (idx!=self.devicesReset.count) {
                            [devicesR appendString:@","];
                        }
                    }];
                    NSString *resetDevicesStr = [NSString stringWithFormat:@"%@已被主人解绑，您无法查看该设备",devicesR];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:resetDevicesStr delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    alertView.tag = AlertViewResetDevice;
                    [alertView show];
                }else{
                    [self getUserAllBindDevices];
                }
            }
        }else{
            [self getUserAllBindDevices];
        }
    } failure:^(SkywareResult *result) {
        [self getUserAllBindDevices];
    }];
}



- (void) addItemCellWithBindDevices
{
    //    NSMutableArray *deviceArray= [NSMutableArray array];
    [self.dataList removeAllObjects];
    [self getUserAllBindDevices];
    //    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    //    if (!manager.bind_Devices_Array.count){
    //        [self getUserAllBindDevices];
    //        return;
    //    }
    //    [manager.bind_Devices_Array enumerateObjectsUsingBlock:^(SkywareDeviceInfoModel *DeviceInfo, NSUInteger idx, BOOL * _Nonnull stop) {
    //        BaseArrowCellItem *item = [BaseArrowCellItem createBaseCellItemWithIcon:@"show_biao" AndTitle:DeviceInfo.device_name SubTitle:[DeviceInfo.device_lock integerValue]== 1? @"未锁定": @"已锁定" ClickOption:nil];
    //        [deviceArray addObject:item];
    //    }];
    //    BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:deviceArray];
    //    [self.dataList addObject:group];
    //    [self.tableView reloadData];
}

#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    self.deviceModel = [manager.bind_Devices_Array objectAtIndex:indexPath.row];
    //区分主设备和被分享的设备
    if ([self.deviceModel.user_state boolValue]) { //被分享用户
        UIActionSheet *sheetCustom = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设备解绑",@"网络配置", nil];
        sheetCustom.tag = 1;
        [sheetCustom showInView:[UIWindow getCurrentWindow]];
    }else{//主用户
        NSString *isLock = [self.deviceModel.device_lock integerValue]== 1?@"设备锁定":@"设备解锁";
        UIActionSheet *sheetMaster = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设备编辑",@"共享管理",@"共享设备",isLock,@"设备解绑",@"网络配置",nil];
        sheetMaster.tag = 0;
        [sheetMaster showInView:[UIWindow getCurrentWindow]];
    }
    
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle =  [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"设备解绑"]) {
        if (![_deviceModel.user_state boolValue]) {//主人
            if ( [self.deviceModel.device_lock integerValue]== 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备已经锁定，不可以解除绑定" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                return ;
            }
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要解绑这台设备吗？" message:[_deviceModel.user_state boolValue]?@"设备解绑后将无法再查看该设备":@"解绑后被分享者将无法查看该设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = AlertViewUnBind;
        [alertView show];
    }
    if ([buttonTitle isEqualToString:@"设备锁定"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要锁定这台设备吗？（锁定后被分享者将无法控制该设备）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = AlertViewLock;
        [alertView show];
    }
    if ([buttonTitle isEqualToString:@"设备解锁"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要解锁这台设备吗？\n （设备解锁后可以被他人建立新绑定关系）" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = AlertViewUnlock;
        [alertView show];
    }
    if ([buttonTitle isEqualToString:@"设备编辑"]) {
        DeviceEditInfoViewController *edit = [[DeviceEditInfoViewController alloc] initWithNibName:@"DeviceEditInfoViewController" bundle:nil];
        edit.DeviceInfo = self.deviceModel;
        [self.navigationController pushViewController:edit animated:YES];
    }
    if ([buttonTitle isEqualToString:@"共享设备"]) {
        ShareCodeQRViewController *shareViewController = [[ShareCodeQRViewController alloc] init];
        shareViewController.codeStr = [NSString stringWithFormat:@"%@;%@",self.deviceModel.device_id,self.deviceModel.device_name];
        [self.navigationController pushViewController:shareViewController animated:YES];
    }
    if ([buttonTitle isEqualToString:@"共享管理"]) {
        ShareDeviceListViewController *listVC = [[ShareDeviceListViewController alloc] init];
        listVC.currentDeviceId = _deviceModel.device_id;
        [self.navigationController pushViewController:listVC animated:YES];
    }
    if ([buttonTitle isEqualToString:@"网络配置"]) {
        AddDeviceViewController *add = [[AddDeviceViewController alloc] init];
        add.addDevice = NO;
        [self.navigationController pushViewController:add animated:YES];
    }
    
}



#pragma mark- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertViewUnBind) { //解绑
        if (buttonIndex == alertView.cancelButtonIndex) return;
        [SVProgressHUD show];
        //这里分主用户和被分享的用户
        if ([_deviceModel.user_state boolValue]) {//被分享的用户
            [SkywareDeviceManager DeviceReleaseUser:@[self.deviceModel.device_id] Success:^(SkywareResult *result) {
                [SVProgressHUD showSuccessWithStatus:@"设备解绑成功"];
                [self getUserAllBindDevices];
            } failure:^(SkywareResult *result) {
                [SVProgressHUD showErrorWithStatus:@"解绑失败,请稍后重试"];
            }];
        }else{//主用户 -- 解绑
            [SkywareDeviceManager DeviceReleaseMasterUser:@[self.deviceModel.device_id] Success:^(SkywareResult *result) {
                [SkywareDeviceManager DeviceReleaseUser:@[self.deviceModel.device_id] Success:^(SkywareResult *result) {
                    [SVProgressHUD showSuccessWithStatus:@"设备解绑成功"];
                    [self getUserAllBindDevices];
                } failure:^(SkywareResult *result) {
                    [SVProgressHUD showErrorWithStatus:@"解绑失败,请稍后重试"];
                }];
            } failure:^(SkywareResult *result) {
                [SVProgressHUD showErrorWithStatus:@"解绑失败,请稍后重试"];
            }];
        }
    }else if (alertView.tag == AlertViewLock){ // 锁定
        if (buttonIndex == alertView.cancelButtonIndex) return;
        SkywareDeviceUpdateInfoModel *update = [[SkywareDeviceUpdateInfoModel alloc] init];
        update.device_mac = _deviceModel.device_mac;
        update.device_lock = @"0";
        [SVProgressHUD show];
        [SkywareDeviceManager DeviceUpdateDeviceInfo:update Success:^(SkywareResult *result) {
            if ([result.message intValue] == 200) {
                [SkywareDeviceManager Devicelock:@{@"deviceid":self.deviceModel.device_id} Success:^(SkywareResult *result) {
                    [SVProgressHUD showSuccessWithStatus:@"锁定设备成功"];
                    [self getUserAllBindDevices];
                } failure:^(SkywareResult *result) {
                    [SVProgressHUD showErrorWithStatus:@"锁定设备失败"];
                }];
            }
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"锁定设备失败"];
        }];
    }else if (alertView.tag == AlertViewUnlock){//解锁
        if (buttonIndex == alertView.cancelButtonIndex) return;
        SkywareDeviceUpdateInfoModel *update = [[SkywareDeviceUpdateInfoModel alloc] init];
        update.device_mac = _deviceModel.device_mac;
        update.device_lock = @"1";
        [SVProgressHUD show];
        [SkywareDeviceManager DeviceUpdateDeviceInfo:update Success:^(SkywareResult *result) {
            if ([result.message intValue] == 200) {
                [SkywareDeviceManager DeviceUnlock:@{@"deviceid":self.deviceModel.device_id} Success:^(SkywareResult *result) {
                    [SVProgressHUD showSuccessWithStatus:@"解锁成功"];
                    [self getUserAllBindDevices];
                } failure:^(SkywareResult *result) {
                    //
                    [SVProgressHUD showErrorWithStatus:@"解锁失败"];
                }];
            }
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"解锁失败"];
        }];
    }else if (alertView.tag == AlertViewResetDevice){
        NSMutableArray *arrReset = [NSMutableArray new];
        [self.devicesReset enumerateObjectsUsingBlock:^(DeviceUser *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrReset addObject:obj.device_id];
        }];
        [SkywareDeviceManager DeviceReleaseUser:arrReset Success:^(SkywareResult *result) {
            NSLog(@"重置列表成功");
            [self getUserAllBindDevices];
        } failure:^(SkywareResult *result) {
            NSLog(@"重置失败");
        }];
    }
}


-(NSMutableArray *)devicesReset{
    if (_devicesReset==nil) {
        _devicesReset = [NSMutableArray new];
    }
    return _devicesReset;
}

-(NSMutableArray *)devicesMasterReset
{
    if (!_devicesMasterReset) {
        _devicesMasterReset = [NSMutableArray new];
    }
    return _devicesMasterReset;
}




@end
