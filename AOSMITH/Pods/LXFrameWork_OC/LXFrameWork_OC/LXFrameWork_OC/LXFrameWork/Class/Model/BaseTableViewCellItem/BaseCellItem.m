//
//  BaseCellItem.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseCellItem.h"

@implementation BaseCellItem

+(instancetype)createBaseCellItemWithIcon:(NSString *)icon AndTitle:(NSString *)title SubTitle:(NSString *)subTitle ClickOption:(cellOption)option
{
    BaseCellItem *baseCellItem = [[self alloc] init];
    baseCellItem.icon = icon;
    baseCellItem.title = title;
    baseCellItem.subTitle = subTitle;
    baseCellItem.option = option;
    return baseCellItem;
}
@end
