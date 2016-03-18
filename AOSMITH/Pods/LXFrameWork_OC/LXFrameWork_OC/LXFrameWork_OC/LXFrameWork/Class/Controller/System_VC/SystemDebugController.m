//
//  SystemDebugController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/7.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "UserDefaultsTool.h"
#import "LXFrameWorkConst.h"
#import "SystemDebugController.h"
#import "SysetmHttpDebugController.h"
#import "SystemExceptionDebugController.h"
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
    BOOL openHttpRequestLog = [[UserDefaultsTool getUserDefaultsForKey:kOpenHttpRequestLog]boolValue];
    BaseSwitchCellItem *openAbnormalLog = [BaseSwitchCellItem createBaseCellItemWithIcon:nil AndTitle:@"开启接口请求日志" SubTitle:nil defaultOpen:openHttpRequestLog ClickOption:nil SwitchOption:^(UISwitch *cellSwitch) {
        [UserDefaultsTool setUserDefaultsWith:@(cellSwitch.on) forKey:kOpenHttpRequestLog];
    }];
    
    BaseArrowCellItem *httpRequestLog = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"接口请求日志" SubTitle:nil ClickOption:^{
        SysetmHttpDebugController *httpDebug = [[SysetmHttpDebugController alloc] init];
        [self.navigationController pushViewController:httpDebug animated:YES];
    } AndDetailClass:nil];
    
    BaseArrowCellItem *systemExceptionLog = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"异常日志" SubTitle:nil ClickOption:^{
        SystemExceptionDebugController *exceptionDebug = [[SystemExceptionDebugController alloc] init];
        [self.navigationController pushViewController:exceptionDebug animated:YES];
    } AndDetailClass:nil];
    
    BaseArrowCellItem *setUpGuide = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"重设引导信息" SubTitle:nil ClickOption:^{
        [UserDefaultsTool setUserDefaultsWith:@(NO) forKey:kShowGuidancePage];
        [SVProgressHUD showSuccessWithStatus:@"重设引导页成功"];
    }];
    
    BaseArrowCellItem *ChooseServiewCell = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"选择服务器" SubTitle:nil ClickOption:^{
        SystemSelectServiceViewController *systemSelectService = [[SystemSelectServiceViewController alloc] init];
        [self.navigationController pushViewController:systemSelectService animated:YES];
    }];
    
    BaseArrowCellItem *ServiewMonitoring = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"服务器监控" SubTitle:nil ClickOption:^{
        [SVProgressHUD showInfoWithStatus:@"敬请期待..."];
    } AndDetailClass:nil];
    
//    BaseArrowCellItem *TestPage = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"进入测试Page" SubTitle:nil ClickOption:^{
//        HttpViewController  *httpVC = [[HttpViewController alloc] init];
//        [self.navigationController pushViewController:httpVC animated:YES];
//    } AndDetailClass:nil];
    
    BaseArrowCellItem *CompelCrash = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"强制Crash" SubTitle:nil ClickOption:^{
        NSDictionary *dict = [NSDictionary dictionary];
        [dict setValue:nil forKey:@"1"];
    } AndDetailClass:nil];
    
    
    
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadTitle:@"系统功能" AndFooterTitle:nil OrItem:@[openAbnormalLog,httpRequestLog,systemExceptionLog,setUpGuide,ChooseServiewCell,ServiewMonitoring,CompelCrash]];
    
    //    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithHeadTitle:@"项目功能" AndFooterTitle:nil OrItem:@[openAbnormalLog,arrowCell,abnormalLog,baseCell,ChooseServiewCell,ServiewMonitoring,TestPage,CompelCrash]];
    
    [self.dataList addObject:group1];
    //    [self.dataList addObject:group2];
}

@end
