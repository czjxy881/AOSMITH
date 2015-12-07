//
//  BaseWebViewController.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/14.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

//              ◢██████◣　　　　　　◢████◣
//          ◢◤　　　　　　◥◣　　　　◢◤　　　　◥◣
//          ◤　　　　　　　　◥◣　　◢◤　　　　　　█
//          ▎　　　◢█◣　　　◥◣◢◤　　◢█　　　█
//          ◣　　◢◤　　◥◣　　　　　　◢◣◥◣　◢◤
//          ◥██◤　　　◢◤　　     　　◥◣
//          　　　　　　　┃　　　　　   ┃
//          　　　　　　　┃　　　━　　  ┃
//          　　　　　　　┃　┳┛　┗┳    ┃
//          　　　　　　　┃　　　 　　  ┃
//          　　　　　　　┃≡╰┬┬┬╯≡┃
//          　　　　　　　┃　　　　　　　┃
//          　　　　　　　┗━┓　　　┏━┛
//          　　　　　　　　　┃　　　┃
//          　　　　　　　　　┃　　　┃
//          　　　　　　　　　┃　　　┗━━━┓
//          　　　　　　　　　┃　　　    ┣━━━━┓
//          　　　　　　　　　┃         ┏━━━━┛
//          　　　　　　　　　┗┓┓┏━┳┓┏┛
//          　　　　　　　　　 ┃┫┫ ┃┫┫
//          　　　　　　　　　 ┗┻┛ ┗┻┛


#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController

/*** 显示的 WebView */
@property (nonatomic,strong) UIWebView *webView;

/***  显示 NavBar(透明颜色) 显示NavBar 上的按钮  */
@property (nonatomic,assign) BOOL displayNav;

@end
