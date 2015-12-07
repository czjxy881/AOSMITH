//
//  WebViewController.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/17.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:self.title];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URL]]];
}


@end
