//
//  SystemExceptionDebugCell.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 16/2/19.
//  Copyright © 2016年 LXFrameWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemExceptionDebugModel.h"

@interface SystemExceptionDebugCell : UITableViewCell

@property (nonatomic,strong) SystemExceptionDebugModel *model;

/**
 *  创建 TableViewCell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
