//
//  UserMenuViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/8.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserMenuViewController.h"
#import "HelpViewController.h"
#import "SettingViewController.h"
#import "Util.h"

@interface UserMenuViewController ()

@end

@implementation UserMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShareBar];
    [self addUserInfoManagerGroup];
//    [self addBuyDeviceGroup];
    [self addDeviceManagerGroup];
    [self addDeviceGroup];
    [self setUpOtherItemGroup];
    
}
-(void)setShareBar
{
    [self setRightBtnWithImage:[UIImage imageNamed:@"btn_share"] orTitle:nil ClickOption:^{
        [Util shareAllButtonClickHandler:self.view withContent:SHARE_CONTENT];
    }];
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
}

- (void) addBuyDeviceGroup
{
    BaseArrowCellItem *buyItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_buy" AndTitle:@"网购商城" SubTitle:nil ClickOption:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://rsdcw.jd.com/"]];
    }];
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadView:nil AndFootView:nil OrItem:@[buyItem]];
    [self.dataList addObject:group1];
}

- (void)setUpOtherItemGroup
{
//    BaseArrowCellItem *settingItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"user_setting" AndTitle:@"设置" SubTitle:nil ClickOption:^{
//        SettingViewController *settingVC = [[SettingViewController alloc]init];
//        [self.navigationController pushViewController:settingVC animated:YES];
//    }];
    
//    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithItem:@[settingItem]];
//    [self.dataList addObject:group2];
    
    BaseArrowCellItem *helpItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_help" AndTitle:@"帮助" SubTitle:nil ClickOption:^{
        HelpViewController *helpVC = [[HelpViewController alloc]init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }];
    
    BaseArrowCellItem *feedbackItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_feedback" AndTitle:@"反馈" SubTitle:nil ClickOption:^{
        SystemFeedBackViewController *feedBack = [[SystemFeedBackViewController alloc] initWithNibName:@"SystemFeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:feedBack animated:YES];
    }];
    
    BaseArrowCellItem *aboutItem = [BaseArrowCellItem  createBaseCellItemWithIcon:@"icon_setting_about" AndTitle:@"关于" SubTitle:nil ClickOption:^{
        SystemAboutViewController *about = [[SystemAboutViewController alloc] initWithNibName:@"SystemAboutViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
    }];
    
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithHeadView:self.groupHeadTitle AndFootView:nil OrItem:@[helpItem,feedbackItem,aboutItem]];
    [self.dataList addObject:group3];
    
    [self.tableView reloadData];
}


@end
