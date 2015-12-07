//
//  BaseArrowCellItem.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseArrowCellItem.h"

@implementation BaseArrowCellItem

+ (instancetype)createBaseCellItemWithIcon:(NSString *)icon AndTitle:(NSString *)title SubTitle:(NSString *)subTitle ClickOption:(cellOption)option AndDetailClass:(Class)detailClass
{
    BaseArrowCellItem *baseArrorwCellItem = [super createBaseCellItemWithIcon:icon AndTitle:title SubTitle:subTitle ClickOption:option];
    if (detailClass) {
        baseArrorwCellItem.detailClass = detailClass;
    }
    return baseArrorwCellItem;
}

@end
