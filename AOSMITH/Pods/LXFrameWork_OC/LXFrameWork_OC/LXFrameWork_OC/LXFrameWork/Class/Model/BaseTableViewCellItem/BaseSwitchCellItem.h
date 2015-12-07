//
//  BaseSwitchCellItem.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseCellItem.h"

typedef void(^switchCellOption)();

@interface BaseSwitchCellItem : BaseCellItem

/* block 保存一段代码在用到的时候执行 */
@property (nonatomic,copy) switchCellOption switchOption;

+ (instancetype)createBaseCellItemWithIcon:(NSString *)icon AndTitle:(NSString *)title SubTitle:(NSString *)subTitle ClickOption:(switchCellOption)switchOption;

@end
