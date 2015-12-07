//
//  BaseArrowCellItem.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/6/15.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseCellItem.h"

@interface BaseArrowCellItem : BaseCellItem

/* 跳转控制器的Class */
@property (nonatomic,assign) Class detailClass;

+(instancetype)createBaseCellItemWithIcon:(NSString *)icon AndTitle:(NSString *)title SubTitle:(NSString *)subTitle ClickOption:(cellOption)option AndDetailClass:(Class) detailClass;

@end
