//
//  BaseCenterTitleCellItem.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseCellItem.h"
#import <UIKit/UIKit.h>

@interface BaseCenterTitleCellItem : BaseCellItem

@property (nonatomic,copy) NSString *centerTitle;

@property (nonatomic,strong) UIColor *color;

+(instancetype)createBaseCellItemWithCenterTitle:(NSString *) centerTitle ClickOption:(cellOption) option WithColor:(UIColor *) color;

@end
