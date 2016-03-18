//
//  SystemHttpDetailCell.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 16/2/18.
//  Copyright © 2016年 LXFrameWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpToolLogModel.h"

@interface SystemHttpDetailCell : UITableViewCell

@property (nonatomic,strong) HttpToolLogModel *model;

/**
 *  创建 TableViewCell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
