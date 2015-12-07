//
//  BaseWebViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/14.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController ()<UIWebViewDelegate>

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    
    // 初始化 webView
    [self setUpWebView];
}

#pragma mark - WebView 代理方法

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

#pragma mark - Method
/**
 *  初始化 webView
 */
- (void) setUpWebView
{
    _webView = [UIWebView newAutoLayoutView];
    [self.view addSubview:_webView];
    [_webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    _webView.delegate = self;
}

/**
 *  设置是否展示NavigationBar
 */
- (void)setDisplayNav:(BOOL)displayNav
{
    _displayNav = displayNav;
    if (displayNav) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.navView setBackgroundColor:[UIColor clearColor]];
        [self.navView setScrollNavigationBarLineBackColor:[UIColor clearColor]];
    }
}

@end
