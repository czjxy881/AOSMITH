//
//  BaseTableViewController.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

//           　 へ　　　　　 ／|
//          　　/＼7　　　 ∠＿/
//          　 /　│　　 ／　／
//          　│　Z ＿,＜　／　　 /`ヽ
//          　│　　　　　ヽ　　 /　　〉
//          　Y　　　　　`　  /　　/
//          　ｲ●　､　●　　⊂⊃〈　　/
//          　()　 へ　　　　|　＼〈
//          　　>ｰ ､_　 ィ　 │ ／／
//          　 / へ　　 /　ﾉ＜| ＼＼
//          　 ヽ_ﾉ　　(_／　 │／／
//              7　　　　　　　|／
//              ＞―r￣￣`ｰ―＿
//         永   无  BUG   十  万 电  伏

#import "BaseViewController.h"
#import "BaseCellItem.h"
#import "BaseArrowCellItem.h"
#import "BaseSwitchCellItem.h"
#import "BaseCenterTitleCellItem.h"
#import "BaseSubtitleCellItem.h"
#import "BaseCellItemGroup.h"
#import "BaseTableViewCell.h"
#import <MJRefresh.h>

@interface BaseTableViewController : BaseViewController

/** 自定义的TableView */
@property (nonatomic,strong) UITableView *tableView;

/** UITableView数据源 */
@property (nonatomic,strong) NSMutableArray *dataList;

/** TableView 实时滚动展示NavigationBar */
@property (nonatomic,assign) BOOL displayNav;

/** TableView 拖拽 TableView 放大HeadImg */
@property (nonatomic,strong) UIImage *scaleImage;

/** TableView 拖拽 TableView 放大HeadImg Height */
@property (nonatomic,assign) CGFloat scaleHeight;


@end
