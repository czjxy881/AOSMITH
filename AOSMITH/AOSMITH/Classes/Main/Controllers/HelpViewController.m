//
//  HelpViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/14.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HelpViewController.h"
#import "WebViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"帮助中心"];
    [self addDataList];
}

- (void) addDataList
{
    BaseArrowCellItem *item1 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"产品使用说明书" SubTitle:nil ClickOption:^{
        WebViewController *web = [[WebViewController alloc] init];
        web.URL = @"http://t1.skyware.com.cn/bglinfo";
        web.title = @"产品使用说明书";
        [self.navigationController pushViewController:web animated:YES];
    }];
    BaseArrowCellItem *item2 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"故障说明" SubTitle:nil ClickOption:^{
        WebViewController *web = [[WebViewController alloc] init];
        web.URL = @"http://t1.skyware.com.cn/bglerror";
        web.title = @"故障说明";
        [self.navigationController pushViewController:web animated:YES];
    }];
    BaseArrowCellItem *item3 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"保养维护" SubTitle:nil ClickOption:^{
        WebViewController *web = [[WebViewController alloc] init];
        web.URL = @"http://t1.skyware.com.cn/bgltending";
        web.title = @"保养维护";
        [self.navigationController pushViewController:web animated:YES];
    }];
    BaseArrowCellItem *item4 = [BaseArrowCellItem  createBaseCellItemWithIcon:nil AndTitle:@"安全注意事项" SubTitle:nil ClickOption:^{
        WebViewController *web = [[WebViewController alloc] init];
        web.URL = @"http://t1.skyware.com.cn/bglsoft";
        web.title = @"安全注意事项";
        [self.navigationController pushViewController:web animated:YES];
    }];
    
    BaseCellItemGroup *group = [BaseCellItemGroup createGroupWithItem:@[item1,item2,item3,item4]];
    
    [self.dataList addObject:group];
}

@end
