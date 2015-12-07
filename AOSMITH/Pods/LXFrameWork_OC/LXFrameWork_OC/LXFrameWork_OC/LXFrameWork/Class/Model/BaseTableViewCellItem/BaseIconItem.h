//
//  BaseIconItem.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/17.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseCellItem.h"

@interface BaseIconItem : BaseCellItem

typedef void(^iconOption)();

/**
 *  默认TableViewSection 分割View H:10px,
 */
@property (nonatomic,strong) UIView *sectionView;

/* block 保存一段代码在用到的时候执行 */
@property (nonatomic,copy) iconOption iconOption;

+(instancetype)createBaseCellItemWithIconNameOrUrl:(NSString *) icon AndTitle:(NSString *)title SubTitle:(NSString *) subTitle ClickCellOption:(cellOption) option ClickIconOption:(iconOption)iconOption;

@end
