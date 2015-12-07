//
//  BaseCenterTitleCellItem.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseCenterTitleCellItem.h"

@implementation BaseCenterTitleCellItem

+ (instancetype)createBaseCellItemWithCenterTitle:(NSString *)centerTitle ClickOption:(cellOption)option WithColor:(UIColor *)color
{
    BaseCenterTitleCellItem *centerTitleCell = [super createBaseCellItemWithIcon:nil AndTitle:nil SubTitle:nil ClickOption:option];
    centerTitleCell.centerTitle = centerTitle;
    centerTitleCell.color  = color;
    return centerTitleCell;
}

@end
