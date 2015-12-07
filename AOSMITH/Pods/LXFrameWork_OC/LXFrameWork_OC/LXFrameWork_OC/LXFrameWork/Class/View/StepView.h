//
//  StepView.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/14.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepNextView.h"
#import "InterchangeButton.h"
#import "UIView+Extension.h"
#import "BundleTool.h"
#import <PureLayout.h>
@class StepView;

@protocol StepViewControllerDelegate <NSObject>

@required

/**
 *  步骤标题的titleArray
 */
- (NSArray *) titleArrayAtHeadView:(StepView *)StepView;

/**
 *  返回每个步骤标题所对应的View
 */
- (StepNextView *) viewForRowAtFootView :(StepView *)StepView Count:(NSInteger) number;

@end

@interface StepView : UIView

/***  StepViewDelegate */
@property (nonatomic,assign) id<StepViewControllerDelegate> delegate;
/***  步骤的头部View */
@property (nonatomic,strong) UIView *stepHeadView;
/***  步骤所对应的底部View */
@property (nonatomic,strong) UIView *stepFootView;
/***  底部的分割线 */
@property (nonatomic,strong) UIView *line;

/**
 *  进入下一个步骤
 */
- (void) nextPage;

@end
