//
//  BaseCellTableViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/9/16.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseCellTableViewController.h"

@interface BaseCellTableViewController ()

@end

@implementation BaseCellTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellItemGroup *group = self.dataList[indexPath.section];
    BaseCellItem *item = group.item[indexPath.row];
    
    BaseTableViewCell *cell = nil;
    if ([item isKindOfClass:[BaseArrowCellItem class]]) {
        cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleValue1];
    }else if([item isKindOfClass:[BaseSubtitleCellItem class]]){
        cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
    }else if ([item isKindOfClass:[BaseSwitchCellItem class]]){
        cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleSubtitle];
    }else{
        cell = [BaseTableViewCell createProfileBaseCellWithTableView:tableView andCellStyle:UITableViewCellStyleDefault];
    }
    cell.items = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 手动取消选中某一行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseCellItemGroup *group = self.dataList[indexPath.section];
    BaseCellItem *item = group.item[indexPath.row];
    
    // 如果有block 就执行block 中的操作
    if (item.option) {
        item.option();
        return;
    }
    // 判断是否为箭头样式的cell 操作就是跳转控制器的操作
    if ([item isKindOfClass:[BaseArrowCellItem class]]) {
        BaseArrowCellItem *arrowItem = (BaseArrowCellItem *)item;
        if (arrowItem.detailClass) {
            UIViewController *VC = [[arrowItem.detailClass alloc] init];
            if ([VC isKindOfClass:[BaseViewController class]]) {
                BaseViewController *baseViewController = (BaseViewController *)VC;
                [baseViewController setTitle:item.title];
            }
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
    //    else if ([item isKindOfClass:[BaseSwitchCellItem class]]){
    //        BaseSwitchCellItem *switchCell = (BaseSwitchCellItem *) item;
    //        if (switchCell.switchOption) {
    //            switchCell.switchOption();
    //        }
    //    }
    
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.headTitle;
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.footerTitle;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.headView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    BaseCellItemGroup *group = self.dataList[section];
    return group.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.dataList.count) return 0;
    if (![self.dataList[section] isKindOfClass:[BaseCellItemGroup class]]) return 0;
    BaseCellItemGroup *group = self.dataList[section];
    if (group.headView) {
        return group.headView.height;
    }else if(group.headTitle.length){
        return 23;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.dataList.count) return 0;
    if (![self.dataList[section] isKindOfClass:[BaseCellItemGroup class]]) return 0;
    BaseCellItemGroup *group = self.dataList[section];
    if (group.footerView) {
        return group.footerView.height;
    }else if(group.footerTitle.length){
        return 23;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellItemGroup *group = self.dataList[indexPath.section];
    BaseCellItem *item = group.item[indexPath.row];
    if ([item isKindOfClass:[BaseIconItem class]]) {
        return 70;
    }else if (IS_IPHONE_6_OR_6S) {
        return 49;
    }else if (IS_IPHONE_6P_OR_6PS){
        return 54;
    }
    return 44;
}

@end
