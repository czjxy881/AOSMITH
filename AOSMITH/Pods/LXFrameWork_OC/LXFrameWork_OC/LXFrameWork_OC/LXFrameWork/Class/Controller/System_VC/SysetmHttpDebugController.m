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
#import "BundleTool.h"


#define MYBUNDLE_NAME @ "LXFrameWork.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
@interface SysetmHttpDebugController ()<UITableViewDelegate>

@end

@implementation SysetmHttpDebugController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
    NSArray *httpArray = [HttpToolLogModel getHttpToolLog];
    BaseCellItemGroup *group = [[BaseCellItemGroup alloc] init];
    [httpArray enumerateObjectsUsingBlock:^(HttpToolLogModel *model, NSUInteger idx, BOOL *stop) {
        BaseSubtitleCellItem *subTitle = [BaseSubtitleCellItem createBaseCellItemWithIcon:nil AndTitle:model.request_URL SubTitle:model.request_time ClickOption:nil];
        [group addObjectWith:subTitle];
    }];
    [self.dataList addObject:group];
    [self.tableView.mj_header endRefreshing];
}

- (void) loadNewData
{
    [self loadData];
}

- (void)loadMoreData
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    HttpToolLogModel *model = [HttpToolLogModel getHttpToolLogWithId:indexPath.row + 1];
    SystemHttpDetailController *detail = [[SystemHttpDetailController alloc] initWithNibName:@"SystemHttpDetailController" bundle:MYBUNDLE];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}
@end
