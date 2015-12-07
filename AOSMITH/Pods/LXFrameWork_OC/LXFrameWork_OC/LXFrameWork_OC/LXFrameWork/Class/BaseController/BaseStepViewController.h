//
//  BaseStepViewController.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/20.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseViewController.h"
#import "InterchangeButton.h"
#import "StepNextView.h"

@protocol StepViewDelegate <NSObject>

@required

/**
 *  步骤标题的titleArray
 */
- (NSArray *) titleArrayAtHeadView:(UIView *)StepView;

/**
 *  返回每个步骤标题所对应的View
 */
- (StepNextView *) viewForRowAtFootView :(UIView *)StepView Count:(NSInteger) number;

@end

@interface BaseStepViewController : BaseViewController

/***  StepViewDelegate */
@property (nonatomic,assign) id <StepViewDelegate> delegate;
/***  步骤的头部View */
@property (nonatomic,strong) UIView *stepHeadView;
/***  步骤所对应的底部View */
@property (nonatomic,strong) UIView *stepContentView;
/***  底部的分割线 */
@property (nonatomic,strong) UIView *line;

/**
 *  进入下一个步骤
 */
- (void) nextPage;

/**
 *  跳到某一个页面
 */
- (void) toPage:(NSInteger) pageCount;

/**
 *  刷新数据
 */
- (void) reloadData;

@end
