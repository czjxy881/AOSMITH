//
//  StepView.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/14.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "StepView.h"

#define kWindowWidth [UIScreen mainScreen].bounds.size.width

@interface StepView()
{
    UIButton *_selectBtn;
    StepNextView *_tempView;
    NSInteger _page;
}
@end

@implementation StepView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stepHeadView = [UIView newAutoLayoutView];
        [self addSubview:self.stepHeadView];
        [self.stepHeadView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.stepHeadView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.stepHeadView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
        [self.stepHeadView autoSetDimension:ALDimensionHeight toSize:44];
        
        self.stepFootView = [UIView newAutoLayoutView];
        [self addSubview:self.stepFootView];
        [self.stepFootView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.stepFootView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stepHeadView];
        
        self.line = [UIView newAutoLayoutView];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self.stepHeadView addSubview:self.line];
        [self.line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.line autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    return self;
}

- (void)setDelegate:(id<StepViewControllerDelegate>)delegate
{
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(titleArrayAtHeadView:)]) {
        NSArray *titleArray = [delegate titleArrayAtHeadView:self];
        NSInteger count = titleArray.count;
        CGFloat btnWidth = kWindowWidth / count;
        
        for (int i = 0; i < titleArray.count; i++) {
            InterchangeButton *btn = [[InterchangeButton alloc] initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, 44)];
            btn.tag = i + 1;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"%d %@",i+1,titleArray[i]]forState:UIControlStateNormal];
            [btn setImage:[BundleTool getImage:@"Arrow_Left" FromBundle:LXFrameWorkBundle] forState:UIControlStateNormal];
            if (i == titleArray.count - 1) {
                [btn setImage:nil forState:UIControlStateNormal];
                btn.x +=5;
            }
            [self.stepHeadView addSubview:btn];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(viewForRowAtFootView:Count:)]) {
        [_tempView removeFromSuperview];
        _page = ++_page;
        _selectBtn = (UIButton *)[self viewWithTag:_page];
        _selectBtn.selected = YES;
        _tempView = [self.delegate viewForRowAtFootView:self Count:_page];
        [self.stepFootView addSubview:_tempView];
        _tempView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tempView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
}

- (void)nextPage
{
    if ([self.delegate respondsToSelector:@selector(viewForRowAtFootView:Count:)]) {
        [_tempView removeFromSuperview];
        _page = ++_page;
        _selectBtn.selected = NO;
        _selectBtn = (UIButton *)[self viewWithTag:_page];
        _selectBtn.selected = YES;
        _tempView = [self.delegate viewForRowAtFootView:self Count:_page];
        [self.stepFootView addSubview:_tempView];
        _tempView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tempView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
}

@end
