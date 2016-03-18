//
//  SkywareJSApiTool.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/14.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareJSApiTool.h"

@interface SkywareJSApiTool ()<UIActionSheetDelegate>
{
    CoreLocationTool *locationTool;
}
@end

@implementation SkywareJSApiTool

/**
 *  拦截WebView的请求,截取请求获得相应的处理
 *
 *  @param request 请求的 Request
 *
 *  @return 是否允许WebView 继续加载操作
 */
- (BOOL) JSApiSubStringRequestWith:(NSURLRequest *) request WebView:(UIWebView *) webView DeviceInfo:(SkywareDeviceInfoModel *) deviceInfo;
{
    NSString *urlStr = request.URL.absoluteString;
    NSString *jsStr = @"jsapi.skyware.com/";
    NSRange range = [urlStr rangeOfString:jsStr];
    if (range.location != NSNotFound) {
        //        urlStr = [urlStr substringFromIndex:range.location + range.length];
        //        NSArray *urlArray = [urlStr componentsSeparatedByString:@"/"];
        //        NSInteger count = urlArray.count;
        //        [urlArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        //            if ([str isEqualToString:@"sendCmdToDevice"]) { // 发送指令给设备
        //                SkywareSendCmdModel *sendModel = [[SkywareSendCmdModel alloc]init];
        //                sendModel.sn = urlArray[count - 3];
        //                sendModel.mac = urlArray[count - 2];
        //                sendModel.commandv = [urlArray[count - 1] decodeFromPercentEscapeString];
        //                [self sendCmdToDeviceWith:sendModel];
        //                *stop = YES;
        //            }else if ([str isEqualToString:@"getCurrentDeviceInfo"]){ // 获取设备列表某个Cell信息
        //                NSRange range = [urlStr rangeOfString:@"type/"];
        //                NSArray *typeArray = [[urlStr substringFromIndex:range.length + range.location] componentsSeparatedByString:@"/"];
        //                [self getMethodWithTypeArray:typeArray WebView:webView WithDeviceInfo:deviceInfo];
        //                *stop = YES;
        //            }else if([str isEqualToString:@"goback"]){
        //                [KBaseDelegate.navigationController popViewControllerAnimated:YES];
        //            }else if ([str isEqualToString:@"gomenu"]){
        //                if ([self.delegate respondsToSelector:@selector(SkywareJSApiWillShowMenu:)]) {
        //                    [self.delegate SkywareJSApiWillShowMenu:self];
        //                }
        //            }else if ([str isEqualToString:@"goshare"]){
        //                //                [SVProgressHUD showSuccessWithStatus:@"敬请期待!"];
        //                [self goShare];
        //            }
        //        }];
        NSArray *urlArray = [urlStr componentsSeparatedByString:@"="];
        if (urlArray.count == 2) {
            if ([self.delegate respondsToSelector:@selector(SkywareJSApiWillShowOneKeyBuy:)]) {
                [self.delegate SkywareJSApiWillShowOneKeyBuy:[urlArray objectAtIndex:1]];
            }
        }
        return NO;
    }
    return YES;
}

- (void) goShare
{
    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    //
    //    //构造分享内容
    //    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
    //                                       defaultContent:@"测试一下"
    //                                                image:[ShareSDK imageWithPath:imagePath]
    //                                                title:@"ShareSDK"
    //                                                  url:@"http://www.mob.com"
    //                                          description:@"这是一条测试信息"
    //                                            mediaType:SSPublishContentMediaTypeNews];
    //    //创建弹出菜单容器
    //    id<ISSContainer> container = [ShareSDK container];
    //    UIWindow *window = [UIWindow getCurrentWindow];
    //    [container setIPadContainerWithView:window arrowDirect:UIPopoverArrowDirectionUp];
    //
    //    //弹出分享菜单
    //    [ShareSDK showShareActionSheet:container
    //                         shareList:nil
    //                           content:publishContent
    //                     statusBarTips:YES
    //                       authOptions:nil
    //                      shareOptions:nil
    //                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
    //
    //                                if (state == SSResponseStateSuccess)
    //                                {
    //                                    NSLog(@"分享成功");
    //                                }
    //                                else if (state == SSResponseStateFail)
    //                                {
    //                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
    //                                }
    //                            }];
    
}

- (void) getMethodWithTypeArray:(NSArray *) typeArray WebView:(UIWebView *) webView WithDeviceInfo:(SkywareDeviceInfoModel *) deviceInfo
{
    [typeArray enumerateObjectsUsingBlock:^(NSString *typeStr, NSUInteger idx, BOOL *stop) {
        NSInteger type = [typeStr integerValue];
        switch (type) {
            case getDeviceInfo:
            {
                [self onGotCurDevInfoJsonStr:[deviceInfo JSONString]  Type:typeStr  ToWebView:webView];
            }
                break;
            case getWeather:
            {
                locationTool = [[CoreLocationTool alloc] init];
                [locationTool getLocation:^(CLLocation *location) {
                    [locationTool reverseGeocodeLocation:location userAddress:^(UserAddressModel *userAddress){
                        SkywareWeatherModel *model = [[SkywareWeatherModel alloc] init];
                        model.province = userAddress.State;
                        model.city = userAddress.City;
                        model.district = userAddress.SubLocality;
                        [SkywareOtherManager UserAddressWeatherParamesers:model Success:^(SkywareResult *result) {
                            [self onGotCurDevInfoJsonStr:[result.result JSONString]  Type:typeStr  ToWebView:webView];
                        } failure:^(SkywareResult *result) {
                            NSLog(@"%@",result);
                        }];
                    }];
                }];
            }
                break;
            default:
                break;
        }
    }];
}

/**
 *  MQTT 推送消息给 WebView
 *
 *  @param data    MQTT 推送的Data
 *  @param webView 推送到 WebView
 */
- (void) onRecvDevStatusData:(NSData *) data ToWebView:(UIWebView *) webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onRecvDevStatus('%@')",[data JSONString]]];
}

/**
 *  将错误信息推到 WebView
 *
 *  @param jsonStr JSON
 *  @param code    错误代码
 *  @param message 错误信息
 *  @param webView 推送到 WebView
 */
- (void) onSendCmdResultJsonStr:(NSString *) jsonStr Code:(NSString *) code Message:(NSString *) message ToWebView:(UIWebView *) webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onSendCmdResult('%@','%@','%@')",jsonStr,code,message]];
}

/**
 *  将设备信息推到 WebView
 *
 *  @param jsonStr JSOn
 *  @param code    错误代码
 *  @param message 错误信息
 *  @param webView 推送到 WebView
 */
- (void)onGotCurDevInfoJsonStr:(NSString *) jsonStr Type:(NSString *) type ToWebView:(UIWebView *) webView
{
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onGotCurDevInfo('%@','%@')",jsonStr,type]];
    //    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"ceshi('%@')",@"ceshi"]];
}

/**
 *  发送指令到设备
 */
- (void) sendCmdToDeviceWith:(SkywareSendCmdModel *) send
{
    // 获取当前正在操作的 Device
    SkywareDeviceInfoModel *info = [SkywareSDKManager sharedSkywareSDKManager].currentDevice;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!info) return;
    [params setObject: info.device_id forKey:@"device_id"];
    [params setObject: send.commandv forKey:@"commandv"];
    [SVProgressHUD show];
    [SkywareDeviceManager DevicePushCMD:params Success:^(SkywareResult *result) {
        NSLog(@"指令发送成功---%@",params);
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        NSLog(@"指令发送失败");
        [SVProgressHUD dismiss];
    }];
}

/**
 *  查询设备信息
 */
- (SkywareResult *)queryDeviceInfoToWebView:(UIWebView *) webView
{
    __block typeof(SkywareResult) *httpResult;
    SkywareDeviceQueryInfoModel *query = [[SkywareDeviceQueryInfoModel alloc] init];
    SkywareDeviceInfoModel *info = [SkywareSDKManager sharedSkywareSDKManager].currentDevice;
    query.id = info.device_id;
    [SVProgressHUD show];
    [SkywareDeviceManager DeviceQueryInfo:query Success:^(SkywareResult *result) {
        httpResult = result;
        [self onGotCurDevInfoJsonStr:[result.result JSONString] Type:nil ToWebView:webView];
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        httpResult  = nil;
    }];
    return httpResult;
}

@end
