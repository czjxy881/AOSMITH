//
//  SystemExceptionDebugController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 16/2/19.
//  Copyright © 2016年 LXFrameWork. All rights reserved.
//

#import "SystemExceptionDebugController.h"
#import "SystemExceptionDetailController.h"
#import "SystemExceptionDebugModel.h"
#import "SystemExceptionDebugCell.h"

#define MYBUNDLE_NAME @ "LXFrameWork.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface SystemExceptionDebugController ()<UITableViewDelegate>
{
    NSInteger _pageIndex;
}
@end

@implementation SystemExceptionDebugController

static NSInteger   const pageSize = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"异常日志"];
    self.tableView.rowHeight = 65;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    NSArray *array = [SystemExceptionDebugModel getSystemExceptionDebugModelWithPageIndex:_pageIndex pageSize:pageSize];
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
    SystemExceptionDebugCell *cell = [SystemExceptionDebugCell cellWithTableView:tableView];
    SystemExceptionDebugModel *model = self.dataList[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    SystemExceptionDebugModel *model = self.dataList[indexPath.row];
    SystemExceptionDetailController *detail = [[SystemExceptionDetailController alloc] initWithNibName:@"SystemExceptionDetailController" bundle:MYBUNDLE];
    //    SystemExceptionDetailController *detail = [[SystemExceptionDetailController alloc] initWithNibName:@"SystemExceptionDetailController" bundle:nil];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
