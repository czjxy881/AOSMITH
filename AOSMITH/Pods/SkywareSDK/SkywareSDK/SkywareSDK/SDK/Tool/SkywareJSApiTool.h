//
//  SkywareJSApiTool.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/14.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareDeviceManager.h"
#import "BaseDelegate.h"
#import <CoreLocationTool.h>
#import <UIWindow+Extension.h>
#import <NSObject+JSONCategories.h>
#define KBaseDelegate  ((BaseDelegate *)[UIApplication sharedApplication].delegate)

@class SkywareJSApiTool;

typedef enum {
    getDeviceInfo = 1,
    getWeather,
    sendCmd,
    definal
}WebType;


@protocol SkywareJSApiToolDelegate <NSObject>
@optional

- (void)SkywareJSApiWillShowMenu:(SkywareJSApiTool *)jsApiTool;

- (void)SkywareJSApiWillShowOneKeyBuy:(NSString *)jsApiOneKeyBuyURL;//一键购买连接网址
@end

@interface SkywareJSApiTool : NSObject

@property(nonatomic,weak) id<SkywareJSApiToolDelegate> delegate;

/**
 *  拦截WebView的请求,截取请求获得相应的处理
 *
 *  @param request 请求的 Request
 *
 *  @return 是否允许WebView 继续加载操作
 */
- (BOOL) JSApiSubStringRequestWith:(NSURLRequest *) request WebView:(UIWebView *) webView DeviceInfo:(SkywareDeviceInfoModel *) deviceInfo;

/**
 *  查询设备信息
 */
- (SkywareResult *)queryDeviceInfoToWebView:(UIWebView *) webView;

/**
 *  将设备信息推到 WebView
 *
 *  @param jsonStr JSOn
 *  @param code    错误代码
 *  @param message 错误信息
 *  @param webView 推送到 WebView
 */
- (void)onGotCurDevInfoJsonStr:(NSString *) jsonStr Type:(NSString *) type ToWebView:(UIWebView *) webView;

/**
 *  MQTT 推送消息给 WebView
 *
 *  @param data    MQTT 推送的Data
 *  @param webView 推送到 WebView
 */
- (void) onRecvDevStatusData:(NSData *) data ToWebView:(UIWebView *) webView;

/**
 *  将错误信息推到 WebView
 *
 *  @param jsonStr JSON
 *  @param code    错误代码
 *  @param message 错误信息
 *  @param webView 推送到 WebView
 */
- (void) onSendCmdResultJsonStr:(NSString *) jsonStr Code:(NSString *) code Message:(NSString *) message ToWebView:(UIWebView *) webView;

@end
