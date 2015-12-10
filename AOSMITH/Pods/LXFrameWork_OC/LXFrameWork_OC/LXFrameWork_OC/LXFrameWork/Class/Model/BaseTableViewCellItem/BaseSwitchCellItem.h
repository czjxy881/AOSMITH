//
//  BaseSwitchCellItem.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseCellItem.h"

typedef void(^switchCellOption)(UISwitch *cellSwitch);

@interface BaseSwitchCellItem : BaseCellItem

/* 默认Switch开关是否开启 */
@property (nonatomic,assign) BOOL open;

/* block 保存一段代码在用到的时候执行 */
@property (nonatomic,copy) switchCellOption switchOption;

+ (instancetype)createBaseCellItemWithIcon:(NSString *)icon AndTitle:(NSString *)title SubTitle:(NSString *)subTitle defaultOpen:(BOOL)open ClickOption:(cellOption) cellOption SwitchOption:(switchCellOption) switchOption;

@end
