//
//  UserMenuViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/8.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserMenuViewController.h"
#import "SystemAboutViewController.h"
#import "SystemFeedBackViewController.h"
#import "UserAccountViewController.h"
#import "DeviceManagerViewController.h"
#import "SystemFeedBackViewController.h"
#import "AddDeviceViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "NotifyViewController.h"
#import <SkywareUIConst.h>

@interface UserMenuViewController ()

@end

@implementation UserMenuViewController

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
    [SkywareUserManager UserGetUserWithParamesers:nil Success:^(SkywareResult *result) {
        SkywareUserInfoModel *userInfo = [SkywareUserInfoModel objectWithKeyValues:[result.result firstObject]];
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
    
    BaseArrowCellItem *buyItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_buy" AndTitle:@"网购商城" SubTitle:nil ClickOption:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rsdcw.jd.com/"]];
    }];
    
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
    
    BaseArrowCellItem *settingItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"user_setting" AndTitle:@"设置" SubTitle:nil ClickOption:^{
        SettingViewController *settingVC = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithItem:@[buyItem,deviceManagerItem,addDeviceItem,settingItem]];
    
    BaseArrowCellItem *helpItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_help" AndTitle:@"帮助中心" SubTitle:nil ClickOption:^{
        HelpViewController *helpVC = [[HelpViewController alloc]init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }];
    
    BaseArrowCellItem *notification = [BaseArrowCellItem  createBaseCellItemWithIcon:@"notice" AndTitle:@"通知" SubTitle:nil ClickOption:^{
        NotifyViewController *nogify = [[NotifyViewController alloc]init];
        [self.navigationController pushViewController:nogify animated:YES];
    }];
    
    BaseArrowCellItem *feedbackItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_feedback" AndTitle:@"问题反馈" SubTitle:nil ClickOption:^{
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
    
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithHeadView:sectionLabel AndFootView:nil OrItem:@[notification,helpItem,feedbackItem,aboutItem]];
    
    [self.dataList removeAllObjects];
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
    [self.dataList addObject:group3];
    
    [self.tableView reloadData];
}


@end
