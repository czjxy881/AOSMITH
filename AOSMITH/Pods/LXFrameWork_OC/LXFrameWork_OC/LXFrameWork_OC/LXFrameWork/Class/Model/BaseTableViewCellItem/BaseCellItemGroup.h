//
//  BaseCellItemGroup.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseCellItemGroup : NSObject

/**
 *  分组的头部
 */
@property (nonatomic,copy) NSString *headTitle;
/**
 *  分组的尾部
 */
@property (nonatomic,copy) NSString *footerTitle;
/**
 *  分组的头部View
 */
@property (nonatomic,strong) UIView *headView;
/**
 *  分组的尾部View
 */
@property (nonatomic,strong) UIView *footerView;
/**
 *  分组的数据
 */
@property (nonatomic,strong) NSArray *item;

+ (instancetype)createGroupWithHeadTitle:(NSString *) headTitle AndFooterTitle:(NSString *) footerTitle OrItem:(NSArray *) item;

+ (instancetype)createGroupWithHeadView:(UIView *) headView AndFootView:(UIView *) footerView OrItem:(NSArray *)item;

+ (instancetype)createGroupWithItem:(NSArray *) item;

/**
 *  向 item 当中添加数据
 */
- (instancetype)addObjectWith:(id)object;

@end
