//
//  HelpViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/14.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *_activityView;
    UIWebView *protWebView;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"帮助"];
    [self setupWebView];
}
/**
 *  网页布局
 */
- (void)setupWebView
{
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://yun.skyware.com.cn/help/17"]];
    [webView loadRequest:request];
    webView.scrollView.bounces = NO;
    webView.delegate=self;
    webView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:webView];
}

#pragma mark Web运行
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.3];
    [self.view addSubview:view];
    
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f,60.0f)];
    [activityIndicator setCenter:self.view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    _activityView=activityIndicator;
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityView stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityView stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}


@end
