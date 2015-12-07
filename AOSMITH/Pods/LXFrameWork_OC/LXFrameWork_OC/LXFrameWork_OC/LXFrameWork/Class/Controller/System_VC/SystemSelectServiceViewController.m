//
//  SystemSelectServiceViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/11/27.
//  Copyright © 2015年 LXFrameWork. All rights reserved.
//

#import "SystemSelectServiceViewController.h"

@interface SystemSelectServiceViewController ()

@end

@implementation SystemSelectServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"选择服务器"];
    [self addDataList];
}

- (void) addDataList
{
    BaseArrowCellItem *Group1_item1 = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"开发_服务器_老接口" SubTitle:nil ClickOption:^{
        [self showTitleView];
    } AndDetailClass:nil];
    BaseArrowCellItem *Group1_item2 = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"开发_服务器_新接口" SubTitle:nil ClickOption:^{
        [self showTitleView];
    } AndDetailClass:nil];
    
    BaseArrowCellItem *Group2_item1 = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"测试_服务器_老接口" SubTitle:nil ClickOption:^{
        [self showTitleView];
    } AndDetailClass:nil];
    BaseArrowCellItem *Group2_item2 = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"测试_服务器_新接口" SubTitle:nil ClickOption:^{
        [self showTitleView];
    } AndDetailClass:nil];
    
    BaseArrowCellItem *Group3_item1 = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"正式_服务器_老接口" SubTitle:nil ClickOption:^{
        [self showTitleView];
    } AndDetailClass:nil];
    BaseArrowCellItem *Group3_item2 = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"正式_服务器_新接口" SubTitle:nil ClickOption:^{
        [self showTitleView];
    } AndDetailClass:nil];
    
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadTitle:@"开发" AndFooterTitle:nil OrItem:@[Group1_item1,Group1_item2,]];
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithHeadTitle:@"测试" AndFooterTitle:nil OrItem:@[Group2_item1,Group2_item2,]];
    BaseCellItemGroup *group3 = [BaseCellItemGroup createGroupWithHeadTitle:@"正式" AndFooterTitle:nil OrItem:@[Group3_item1,Group3_item2,]];
    
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
    [self.dataList addObject:group3];
}

- (void) showTitleView
{
    [NSThread sleepForTimeInterval:1];
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"切换服务器成功，请重新启动APP" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
}


@end
