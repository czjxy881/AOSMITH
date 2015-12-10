//
//  BaseViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@end

@implementation BaseViewController

#define BaseNavBarTextFont [UIFont systemFontOfSize:17]

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置默认的View背景颜色
    LXFrameWorkInstance *instance = [LXFrameWorkInstance sharedLXFrameWorkInstance];
    if (!self.view.backgroundColor) {
        self.view.backgroundColor = instance.ViewController_bgColor;
    }
    // 添加自定义的NavigationBar
    [self setNavigationBarView];
    
    // 设置键盘toolbar样式
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
}

- (void)dealloc
{
    self.returnKeyHandler = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navView];
}

#pragma mark - 设置左右中View

- (void)setNavigationBarView
{
    [self.navigationController.navigationBar removeFromSuperview];
    [self.view addSubview:self.navView];
    [self.navView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.navView autoSetDimension:ALDimensionHeight toSize:64];
}

- (void)setLeftView:(UIView *)leftView
{
    self.navView.leftView = leftView;
}

- (void)setRightView:(UIView *)rightView
{
    self.navView.rightView = rightView;
}

- (void)setCenterView:(UIView *)centerView
{
    self.navView.centerView = centerView;
}

- (void)setCustomNavView:(UIView *)customView
{
    [self.navView removeFromSuperview];
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:customView];
    [customView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [customView autoSetDimension:ALDimensionHeight toSize:64];
}

- (UIButton *)setNavBackBtn
{
    UIButton *button = [UIButton newAutoLayoutView];
    LXFrameWorkInstance *instance = [LXFrameWorkInstance sharedLXFrameWorkInstance];
    if (instance.backState == writeBase) {
        [button setImage:[BundleTool getImage:@"Navigationbar_back_write" FromBundle:LXFrameWorkBundle] forState:UIControlStateNormal];
    }else if(instance.backState == blackBase){
        [button setImage:[BundleTool getImage:@"navigationbar_back" FromBundle:LXFrameWorkBundle] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(NavBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftView:button];
    return button;
}

- (UILabel *)setNavTitle:(NSString *)title
{
    LXFrameWorkInstance *instance = [LXFrameWorkInstance sharedLXFrameWorkInstance];
    UILabel *centerTitle = [UILabel newAutoLayoutView];
    centerTitle.textAlignment = NSTextAlignmentCenter;
    centerTitle.font = BaseNavBarTextFont;
    centerTitle.textColor = instance.NavigationBar_textColor;
    centerTitle.text = title;
    [self setCenterView:centerTitle];
    return centerTitle;
}

- (void)setLeftBtnArray:(NSArray *)btnArray
{
    [self setLeftView:[self setNavBtnArray:btnArray]];
}

- (void)setRightBtnArray:(NSArray *)btnArray
{
    [self setRightView:[self setNavBtnArray:btnArray]];
}

- (UIView *) setNavBtnArray:(NSArray *) btnArray
{
    UIView *btnView = [UIView newAutoLayoutView];
    __block CGFloat btnW = 0;
    __block CGFloat btnH = 35;
    [btnArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        if (btn.width == 0 || btn.height == 0) {
            btn.size = CGSizeMake(btnH, btnH);
        }
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        [btnView addSubview:btn];
        [btn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [btn autoSetDimensionsToSize:btn.size];
        [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:btn.width * idx];
        btnW += btn.width;
    }];
    btnView.size = CGSizeMake(btnW, 40);
    return btnView;
}

- (UIButton *)setLeftBtnWithImage:(UIImage *)image orTitle:(NSString *)title ClickOption:(ClickButton)clickOption
{
    UIButton *leftBtn = [self setBtnWithNormalImage:image HighlightedImage:nil SelectedImage:nil DisabledImage:nil OrTitle:title ClickOption:clickOption];
    [self setLeftView:leftBtn];
    return leftBtn;
}

- (UIButton *)setRightBtnWithImage:(UIImage *)image orTitle:(NSString *)title ClickOption:(ClickButton) clickOption
{
    UIButton *rightBtn = [self setBtnWithNormalImage:image HighlightedImage:nil SelectedImage:nil DisabledImage:nil OrTitle:title ClickOption:clickOption];
    [self setRightView:rightBtn];
    return rightBtn;
}

- (UIButton *) setBtnWithNormalImage:(UIImage *)normalImg HighlightedImage:(UIImage *)highlightedImg SelectedImage:(UIImage *)selectedImg DisabledImage:(UIImage *)disableImg OrTitle:(NSString *) title ClickOption:(ClickButton) clickOption
{
    LXFrameWorkInstance *instance = [LXFrameWorkInstance sharedLXFrameWorkInstance];
    BlockButton *button = [[BlockButton alloc] init];
    button.titleLabel.font = BaseNavBarTextFont;
    if (normalImg) {
        [button setImage:normalImg forState:UIControlStateNormal];
    }
    if (highlightedImg) {
        [button setImage:highlightedImg forState:UIControlStateHighlighted];
    }
    if (selectedImg) {
        [button setImage:selectedImg forState:UIControlStateSelected];
    }
    if (disableImg) {
        [button setImage:disableImg forState:UIControlStateDisabled];
    }
    if (title.length) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:instance.NavigationBar_textColor forState:UIControlStateNormal];
    }
    button.ClickOption = clickOption;
    return button;
}

#pragma  mark - 按钮点击

- (void)NavBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载

- (NavigationBar *)navView
{
    if (!_navView) {
        _navView = [NavigationBar newAutoLayoutView];
    }
    return _navView;
}

@end
