//
//  BaseSwitchCellItem.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseSwitchCellItem.h"

@implementation BaseSwitchCellItem

+ (instancetype)createBaseCellItemWithIcon:(NSString *)icon AndTitle:(NSString *)title SubTitle:(NSString *)subTitle defaultOpen:(BOOL)open ClickOption:(cellOption) cellOption SwitchOption:(switchCellOption) switchOption
{
    BaseSwitchCellItem *baseSwitchCell = [super createBaseCellItemWithIcon:icon AndTitle:title SubTitle:subTitle ClickOption:cellOption];
    baseSwitchCell.switchOption = switchOption;
    baseSwitchCell.open = open;
    return baseSwitchCell;
}


@end
