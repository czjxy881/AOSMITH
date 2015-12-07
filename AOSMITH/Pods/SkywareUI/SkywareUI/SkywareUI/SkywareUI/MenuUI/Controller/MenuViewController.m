//
//  MenuViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "MenuViewController.h"
#import <BaseDelegate.h>
#define Delegate  ((BaseDelegate *)[UIApplication sharedApplication].delegate)
@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"菜单"];
    [self getUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:kEditUserNickNameRefreshTableView object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) getUserInfo
{
    [SVProgressHUD show];
    [SkywareUserManager UserGetUserWithParamesers:nil Success:^(SkywareResult *result) {
        SkywareUserInfoModel *userInfo = [SkywareUserInfoModel mj_objectWithKeyValues:[result.result firstObject]];
        [SVProgressHUD dismiss];
        [self setUpDataListWith:userInfo];
    } failure:^(SkywareResult *result) {
        
    }];
}

- (void)setUpDataListWith:(SkywareUserInfoModel *) user
{
    BaseIconItem *iconItem ;
    
    NSString *user_icon = (user.user_img.length == 0 || user == nil )? @"view_userface" :user.user_img;
    NSString *user_name = (user.user_name.length == 0 || user == nil )? @"匿名" : user.user_name;
    NSString *user_phone = (user.user_phone.length == 0 || user == nil )? @"" :user.user_phone;
    
    iconItem = [BaseIconItem createBaseCellItemWithIconNameOrUrl:user_icon AndTitle:user_name SubTitle:user_phone ClickCellOption:^{
        UserAccountViewController *account = [[UserAccountViewController alloc] init];
        account.user_name = user_name;
        account.user_img = user_icon;
        [self.navigationController pushViewController:account animated:YES];
    } ClickIconOption:nil];
    
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadView:iconItem.sectionView AndFootView:iconItem.sectionView OrItem:@[iconItem]];
    
    //    BaseArrowCellItem *buyItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_buy" AndTitle:@"一键购买" SubTitle:nil ClickOption:^{
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rsdcw.jd.com/"]];
    //    }];
    
    BaseArrowCellItem *deviceManagerItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_device" AndTitle:@"设备管理" SubTitle:nil ClickOption:^{
        DeviceManagerViewController *deviceManager = [[DeviceManagerViewController alloc] init];
        [self.navigationController pushViewController:deviceManager animated:YES];
    }];
    
    BaseArrowCellItem *addDeviceItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_scan" AndTitle:@"添加设备" SubTitle:nil ClickOption:^{
        // 添加设备操作
        AddDeviceViewController *deviceVC = [[AddDeviceViewController alloc] init];
        deviceVC.isAddDevice = YES;
        [self.navigationController pushViewController:deviceVC animated:YES];
    }];
    
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithItem:@[deviceManagerItem,addDeviceItem]];
    
    BaseArrowCellItem *helpItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_help" AndTitle:@"帮助" SubTitle:nil ClickOption:^{
        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
        
        //   测试天气接口
        //        SkywareWeatherModel *model = [[SkywareWeatherModel alloc] init];
        //        model.province = @"河北省";
        //        model.city = @"沧州市";
        //        model.district = @"吴桥县";
        //        [SkywareOthersManagement UserAddressWeatherParamesers:model Success:^(SkywareResult *result) {
        //            SkywareAddressWeatherModel *addressModel = [SkywareAddressWeatherModel objectWithKeyValues:result.result];
        //            NSLog(@"%@",addressModel);
        //        } failure:^(SkywareResult *result) {
        //            NSLog(@"%@",result);
        //        }];
        
    }];
    
    BaseArrowCellItem *feedbackItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_feedback" AndTitle:@"反馈" SubTitle:nil ClickOption:^{
        SystemFeedBackViewController *feedBack = [[SystemFeedBackViewController alloc] initWithNibName:@"SystemFeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:feedBack animated:YES];
    }];
    
    BaseArrowCellItem *aboutItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_about" AndTitle:@"关于" SubTitle:nil ClickOption:^{
        SystemAboutViewController *about = [[SystemAboutViewController alloc] initWithNibName:@"SystemAboutViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
    }];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 25)];
    sectionLabel.text = @"您可以通过扫描或输入机身编码绑定新的设备";
    sectionLabel.textColor = [UIColor grayColor];
    sectionLabel.font = [UIFont systemFontOfSize:14];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.backgroundColor = kRGBColor(231, 231, 231, 1);
    
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithHeadView:sectionLabel AndFootView:nil OrItem:@[helpItem,feedbackItem,aboutItem]];
    
    [self.dataList removeAllObjects];
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
    [self.dataList addObject:group3];
    
    [self.tableView reloadData];
}

@end
