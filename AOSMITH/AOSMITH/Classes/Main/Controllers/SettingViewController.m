//
//  SettingViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/14.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"设置"];
    [self addDataList];
}

- (void) addDataList
{
    BaseArrowCellItem *item1 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"设备复位" SubTitle:nil ClickOption:^{
        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
    }];
    BaseArrowCellItem *item2 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"位置校准" SubTitle:nil ClickOption:^{
        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
    }];
    BaseArrowCellItem *item3 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"时间校准" SubTitle:nil ClickOption:^{
        [SVProgressHUD showSuccessWithStatus:@"敬请期待！"];
    }];
    
    BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:@[item1,item2,item3]];
    
    [self.dataList addObject:group];
}

@end
