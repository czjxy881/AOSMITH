//
//  BaseViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    NSLayoutConstraint *_navBarHeight;
    BlockButton *_btn;
}

@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
/***  无网状态提示 View */
@property (nonatomic,strong) UIView *NetworkView;

@end

@implementation BaseViewController

#define BaseNavBarTextFont [UIFont systemFontOfSize:17]

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置默认的View背景颜色
    LXFrameWorkManager *manager = [LXFrameWorkManager sharedLXFrameWorkManager];
    if (!self.view.backgroundColor) {
        self.view.backgroundColor = manager.viewController_bgColor;
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
    
    // 检测当前屏幕是横屏还是竖屏
    if (self.interfaceOrientation == 4 || self.interfaceOrientation == 3) {
        _navBarHeight.constant = 32;
        [self.navView setNavBarInterfaceOrientation:LeftRight];
    }else if (self.interfaceOrientation == 1 || self.interfaceOrientation == 2 ){
        _navBarHeight.constant = 64;
        [self.navView setNavBarInterfaceOrientation:PortraitUpsideDown];
    }
}

#pragma mark - 设置左右中View

- (void)setNavigationBarView
{
    [self.navigationController.navigationBar removeFromSuperview];
    [self.view addSubview:self.navView];
    [self.navView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    _navBarHeight = [self.navView autoSetDimension:ALDimensionHeight toSize:64];
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
    LXFrameWorkManager *manager = [LXFrameWorkManager sharedLXFrameWorkManager];
    if (manager.backState == writeBase) {
        [button setImage:[BundleTool getImage:@"Navigationbar_back_write" FromBundle:LXFrameWorkBundle] forState:UIControlStateNormal];
    }else if(manager.backState == blackBase){
        [button setImage:[BundleTool getImage:@"navigationbar_back" FromBundle:LXFrameWorkBundle] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(NavBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self setLeftView:button];
    return button;
}

- (UILabel *)setNavTitle:(NSString *)title
{
    LXFrameWorkManager *manager = [LXFrameWorkManager sharedLXFrameWorkManager];
    UILabel *centerTitle = [UILabel newAutoLayoutView];
    centerTitle.textAlignment = NSTextAlignmentCenter;
    centerTitle.font = BaseNavBarTextFont;
    centerTitle.textColor = manager.navigationBar_textColor;
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
    LXFrameWorkManager *manager = [LXFrameWorkManager sharedLXFrameWorkManager];
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
        [button setTitleColor:manager.navigationBar_textColor forState:UIControlStateNormal];
    }
    button.ClickOption = clickOption;
    return button;
}

- (void)showNetWorkView:(BOOL)show
{
    if (show) {
        [self.view bringSubviewToFront:self.NetworkView];
    }else{
        [self.view sendSubviewToBack:self.NetworkView];
    }
}

- (void)setNetworkRefreshOption:(ClickButton)networkRefreshOption
{
    networkRefreshOption = networkRefreshOption;
    _btn.ClickOption = networkRefreshOption;
}

#pragma  mark - 按钮点击

- (void)NavBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 屏幕旋转方向
/**
 *  屏幕将要进行旋转
 *  可以操作隐藏一些View 等操作
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

/**
 *  屏幕开始旋转，执行旋转动画
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    if (interfaceOrientation == 4 || interfaceOrientation == 3) {
        _navBarHeight.constant = 32;
        [self.navView setNavBarInterfaceOrientation:LeftRight];
    }else if (interfaceOrientation == 1 || interfaceOrientation == 2 ){
        _navBarHeight.constant = 64;
        [self.navView setNavBarInterfaceOrientation:PortraitUpsideDown];
    }
}

/**
 *  旋转动画执行完毕
 *  可以操作显示前期隐藏的View
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

#pragma mark - 懒加载

- (NavigationBar *)navView
{
    if (!_navView) {
        _navView = [NavigationBar newAutoLayoutView];
    }
    return _navView;
}

- (UIView *)NetworkView
{
    if (!_NetworkView) {
        _NetworkView = [UIView newAutoLayoutView];
        [self.view insertSubview:_NetworkView atIndex:self.view.subviews.count];
        _NetworkView.backgroundColor = [UIColor whiteColor];
        [_NetworkView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(64, 0, 0, 0)];
        
        _btn = [BlockButton newAutoLayoutView];
        [_NetworkView addSubview:_btn];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btn setTitle:@"刷新" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[BundleTool getImage:@"notwork_btn_normal" FromBundle:LXFrameWorkBundle] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[BundleTool getImage:@"notwork_btn_selected" FromBundle:LXFrameWorkBundle] forState:UIControlStateHighlighted];
        [_btn autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_btn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        _btn.ClickOption = self.networkRefreshOption;
        
        UILabel *label = [UILabel newAutoLayoutView];
        [_NetworkView addSubview:label];
        label.text = @"数据加载失败，请检查您的网络";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:15];
        [label autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_btn withOffset: -20];
        
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        [_NetworkView addSubview:imageView];
        imageView.image = [BundleTool getImage:@"network_failed_gray" FromBundle:LXFrameWorkBundle];
        [imageView autoSetDimensionsToSize:CGSizeMake(100, 100)];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [imageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:label withOffset: -18];
    }
    return _NetworkView;
}

@end
