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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:kEditUserNickNameRefreshTableView object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Method

- (void) addUserInfoManagerGroup
{
    BaseIconItem *iconItem = [BaseIconItem createBaseCellItemWithIconNameOrUrl:@"view_userface" AndTitle:@"匿名" SubTitle:nil ClickCellOption:^{
        UserAccountViewController *account = [[UserAccountViewController alloc] init];
        [self.navigationController pushViewController:account animated:YES];
    } ClickIconOption:nil];
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadView:iconItem.sectionView AndFootView:iconItem.sectionView OrItem:@[iconItem]];
    [self.dataList insertObject:group1 atIndex:0];
    // 加载网络用户信息
    [self getUserInfo];
}

- (void) addDeviceManagerGroup
{
    BaseArrowCellItem *deviceManagerItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_device" AndTitle:@"设备管理" SubTitle:nil ClickOption:^{
        DeviceManagerViewController *deviceManager = [[DeviceManagerViewController alloc] init];
        [self.navigationController pushViewController:deviceManager animated:YES];
    }];
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithItem:@[deviceManagerItem]];
    [self.dataList addObject:group2];
}

- (void) addDeviceGroup
{
    BaseArrowCellItem *addDeviceItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_scan" AndTitle:@"添加设备" SubTitle:nil ClickOption:^{
        // 添加设备操作
        AddDeviceViewController *deviceVC = [[AddDeviceViewController alloc] init];
        deviceVC.isAddDevice = YES;
        [self.navigationController pushViewController:deviceVC animated:YES];
    }];
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithItem:@[addDeviceItem]];
    [self.dataList addObject:group3];
}

- (void)SystemFeedBack
{
    BaseArrowCellItem *feedbackItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_feedback" AndTitle:@"反馈" SubTitle:nil ClickOption:^{
        SystemFeedBackViewController *feedBack = [[SystemFeedBackViewController alloc] initWithNibName:@"SystemFeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:feedBack animated:YES];
    }];
    BaseCellItemGroup *group4 = [BaseCellItemGroup createGroupWithItem:@[feedbackItem]];
    [self.dataList addObject:group4];
}



- (void) getUserInfo
{
    [SkywareUserManager UserGetUserWithParamesers:nil Success:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
        SkywareUserInfoModel *user = [SkywareUserInfoModel mj_objectWithKeyValues:[result.result firstObject]];
        NSString *user_icon = (user.user_img.length == 0 || user == nil )? @"view_userface" :user.user_img;
        NSString *user_name = (user.user_name.length == 0 || user == nil )? @"匿名" : user.user_name;
        NSString *user_phone = (user.user_phone.length == 0 || user == nil )? @"" :user.user_phone;
        BaseIconItem *iconItem = [BaseIconItem createBaseCellItemWithIconNameOrUrl:user_icon AndTitle:user_name SubTitle:user_phone ClickCellOption:^{
            UserAccountViewController *account = [[UserAccountViewController alloc] init];
            account.user_name = user_name;
            account.user_img = user_icon;
            [self.navigationController pushViewController:account animated:YES];
        } ClickIconOption:nil];
        BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadView:iconItem.sectionView AndFootView:iconItem.sectionView OrItem:@[iconItem]];
        [self.dataList removeObjectAtIndex:0];
        [self.dataList insertObject:group1 atIndex:0];
        [self.tableView reloadData];
    } failure:^(SkywareResult *result) {
        
    }];
}

- (void)addExampleCellGroup
{
    BaseArrowCellItem *buyItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_buy" AndTitle:@"一键购买" SubTitle:nil ClickOption:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    }];
    
    BaseArrowCellItem *helpItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_help" AndTitle:@"帮助" SubTitle:nil ClickOption:^{
        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
    }];
    
    BaseArrowCellItem *aboutItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_about" AndTitle:@"关于" SubTitle:nil ClickOption:^{
        SystemAboutViewController *about = [[SystemAboutViewController alloc] initWithNibName:@"SystemAboutViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
    }];
    
    BaseCellItemGroup *group5 = [BaseCellItemGroup createGroupWithHeadView:nil AndFootView:nil OrItem:@[buyItem,helpItem,aboutItem]];
    [self.dataList addObject:group5];
}

#pragma mark - 懒加载
- (UILabel *)groupHeadTitle
{
    if (!_groupHeadTitle) {
        _groupHeadTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 25)];
        _groupHeadTitle.text = @"您可以通过扫描或输入机身编码绑定新的设备";
        _groupHeadTitle.textColor = [UIColor grayColor];
        _groupHeadTitle.font = [UIFont systemFontOfSize:14];
        _groupHeadTitle.textAlignment = NSTextAlignmentCenter;
        _groupHeadTitle.backgroundColor = kRGBColor(231, 231, 231, 1);
    }
    return _groupHeadTitle;
}

@end
