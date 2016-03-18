//
//  SysetmHttpDebugController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/10.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "SysetmHttpDebugController.h"
#import "HttpToolLogModel.h"
#import "SystemHttpDetailController.h"
#import "SystemHttpDetailCell.h"
#import "BundleTool.h"

#define MYBUNDLE_NAME @ "LXFrameWork.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface SysetmHttpDebugController ()<UITableViewDelegate>
{
    NSInteger _pageIndex;
}
@end

@implementation SysetmHttpDebugController

static NSInteger   const pageSize = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"请求日志"];
    self.tableView.rowHeight = 65;
    [self.tableView.mj_header beginRefreshing];
}

- (void) loadNewData
{
    _pageIndex = 1;
    [self.dataList removeAllObjects];
    [self loadData];
}

- (void)loadMoreData
{
    _pageIndex ++;
    [self loadData];
}

- (void) loadData
{
    NSArray *array = [HttpToolLogModel getHttpToolLogWithPageIndex:_pageIndex pageSize:pageSize];
    if (array.count) {
        [self.dataList addObjectsFromArray:array];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemHttpDetailCell *cell = [SystemHttpDetailCell cellWithTableView:tableView];
    HttpToolLogModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    HttpToolLogModel *model = self.dataList[indexPath.row];
    SystemHttpDetailController *detail = [[SystemHttpDetailController alloc] initWithNibName:@"SystemHttpDetailController" bundle:MYBUNDLE];
    //    SystemHttpDetailController *detail = [[SystemHttpDetailController alloc] initWithNibName:@"SystemHttpDetailController" bundle:nil];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}
@end
