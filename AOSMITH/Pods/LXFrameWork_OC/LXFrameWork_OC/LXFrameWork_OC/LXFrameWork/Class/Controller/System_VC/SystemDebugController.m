//
//  SystemDebugController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/7.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "SystemDebugController.h"
#import "SystemSelectServiceViewController.h"
@interface SystemDebugController ()

@end

@implementation SystemDebugController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"调试选项"];
    [self addCellDataList];
}

- (void)addCellDataList
{
    BaseSwitchCellItem *openAbnormalLog = [BaseSwitchCellItem createBaseCellItemWithIcon:nil AndTitle:@"接口请求日志" SubTitle:nil ClickOption:^{
        NSLog(@"开启日志监控");
    }];
    BaseArrowCellItem *arrowCell = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"接口请求日志" SubTitle:nil ClickOption:nil AndDetailClass:nil];
    BaseCellItem *baseCell = [BaseCellItem createBaseCellItemWithIcon:nil AndTitle:@"重设引导信息" SubTitle:nil ClickOption:nil];
    BaseArrowCellItem *ChooseServiewCell = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"选择服务器" SubTitle:nil ClickOption:^{
        SystemSelectServiceViewController *systemSelectService = [[SystemSelectServiceViewController alloc] init];
        [self.navigationController pushViewController:systemSelectService animated:YES];
    }];
    BaseArrowCellItem *ServiewMonitoring = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"服务器监控" SubTitle:nil ClickOption:nil AndDetailClass:nil];
    BaseArrowCellItem *TestPage = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"进入测试Page" SubTitle:nil ClickOption:nil AndDetailClass:nil];
    BaseArrowCellItem *CompelCrash = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"强制Crash" SubTitle:nil ClickOption:nil AndDetailClass:nil];
    BaseArrowCellItem *abnormalLog = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"异常日志" SubTitle:nil ClickOption:nil AndDetailClass:nil];
    
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadTitle:@"系统功能" AndFooterTitle:nil OrItem:@[arrowCell,baseCell,ChooseServiewCell,ServiewMonitoring,TestPage,CompelCrash,abnormalLog,openAbnormalLog]];
    
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithHeadTitle:@"项目功能" AndFooterTitle:nil OrItem:@[arrowCell,baseCell,ChooseServiewCell,ServiewMonitoring,TestPage,CompelCrash,abnormalLog,openAbnormalLog]];
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
}

@end
