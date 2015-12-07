//
//  NotifyViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/16.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "NotifyViewController.h"

@interface NotifyViewController ()

@end

@implementation NotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDataList];
    [self setNavTitle:@"通知"];
}

- (void)addDataList
{
    BaseSubtitleCellItem *item1 = [BaseSubtitleCellItem createBaseCellItemWithIcon:nil AndTitle:@"固件升级" SubTitle:@"V1.9.11" ClickOption:nil];
    
    BaseSwitchCellItem *item2 = [BaseSwitchCellItem createBaseCellItemWithIcon:nil AndTitle:@"维修提醒" SubTitle:@"当机器出现故障时提醒您" ClickOption:nil];
    
    BaseSwitchCellItem *item3 = [BaseSwitchCellItem createBaseCellItemWithIcon:nil AndTitle:@"保养提醒" SubTitle:@"每年进入冬季后提醒您保养机器" ClickOption:nil];
    
    BaseArrowCellItem *item4 = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"优惠活动" SubTitle:nil ClickOption:nil];
    
    BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:@[item1,item2,item3,item4]];
    
    [self.dataList addObject:group];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

@end
