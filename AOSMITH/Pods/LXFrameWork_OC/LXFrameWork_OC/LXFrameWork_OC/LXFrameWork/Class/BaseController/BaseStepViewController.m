//
//  BaseStepViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/20.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseStepViewController.h"

@interface BaseStepViewController ()<StepViewDelegate>
{
    UIButton *_selectBtn;
    StepNextView *_tempView;
    NSInteger _page;
    NSArray *_titleArray;
}

@end

@implementation BaseStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpContentView];
}

/**
 *  初始化界面
 */
- (void) setUpContentView
{
    self.stepHeadView = [UIView newAutoLayoutView];
    [self.view addSubview:self.stepHeadView];
    [self.stepHeadView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.stepHeadView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.stepHeadView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.stepHeadView autoSetDimension:ALDimensionHeight toSize:44];
    
    self.stepContentView = [UIView newAutoLayoutView];
    [self.view addSubview:self.stepContentView];
    [self.stepContentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.stepContentView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.stepHeadView];
    
    self.line = [UIView newAutoLayoutView];
    self.line.backgroundColor = [UIColor lightGrayColor];
    [self.stepHeadView addSubview:self.line];
    [self.line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.line autoSetDimension:ALDimensionHeight toSize:0.5];
}

/**
 *  设置Delegate调用
 */
- (void)setDelegate:(id<StepViewDelegate>)delegate
{
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(titleArrayAtHeadView:)]) {
        _titleArray = [delegate titleArrayAtHeadView:self.view];
        NSInteger count = _titleArray.count;
        if (!count) return;
        CGFloat btnWidth = kWindowWidth / count;
        
        for (int i = 0; i < _titleArray.count; i++) {
            InterchangeButton *btn = [[InterchangeButton alloc] initWithFrame:CGRectMake(i * btnWidth,0, btnWidth, 44)];
            btn.tag = i + 1;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"%d %@",i+1,_titleArray[i]]forState:UIControlStateNormal];
            [btn setImage:[BundleTool getImage:@"Arrow_Left" FromBundle:LXFrameWorkBundle] forState:UIControlStateNormal];
            if (i == _titleArray.count - 1) {
                [btn setImage:nil forState:UIControlStateNormal];
            }
            [self.stepHeadView addSubview:btn];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(viewForRowAtFootView:Count:)]) {
        [_tempView removeFromSuperview];
        _page = ++_page;
        _selectBtn = (UIButton *)[self.view viewWithTag:_page];
        _selectBtn.selected = YES;
        _tempView = [self.delegate viewForRowAtFootView:self.view Count:_page];
        [self.stepContentView addSubview:_tempView];
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
        _selectBtn = (UIButton *)[self.view viewWithTag:_page];
        _selectBtn.selected = YES;
        _tempView = [self.delegate viewForRowAtFootView:self.view Count:_page];
        [self.stepContentView addSubview:_tempView];
        _tempView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tempView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
}

- (void)toPage:(NSInteger)pageCount
{
    if (pageCount > _titleArray.count) return;
    if ([self.delegate respondsToSelector:@selector(viewForRowAtFootView:Count:)]) {
        [_tempView removeFromSuperview];
        _page = pageCount;
        _selectBtn.selected = NO;
        _selectBtn = (UIButton *)[self.view viewWithTag:_page];
        _selectBtn.selected = YES;
        _tempView = [self.delegate viewForRowAtFootView:self.view Count:_page];
        [self.stepContentView addSubview:_tempView];
        _tempView.translatesAutoresizingMaskIntoConstraints = NO;
        [_tempView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
}

- (void)reloadData
{
    self.delegate = self;
}

#pragma mark - 代理方法需要字累重写
- (NSArray *) titleArrayAtHeadView:(UIView *)StepView
{
    return nil;
}

- (StepNextView *) viewForRowAtFootView :(UIView *)StepView Count:(NSInteger) number
{
    return nil;
}

@end
