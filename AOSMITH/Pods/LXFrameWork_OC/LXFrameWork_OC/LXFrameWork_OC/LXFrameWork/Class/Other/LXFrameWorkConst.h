//
//  LXFrameWorkConst.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/24.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXFrameWorkConst : NSObject

/** 与互联网断开连接 */
extern NSString * const kUseDisconnectInternet;

/** 使用 WiFi 连接互联网 */
extern NSString * const kUseWiFiConnectInternet;

/** 使用移动蜂窝数据连接互联网 */
extern NSString * const kUseMobileNetworkConnectInternet;




/**    ------------ NSUserDefault ------------      **/

/** 是否开启了接口请求日志 */
extern NSString * const kOpenHttpRequestLog;

/** 是否已经显示过指导页 */
extern NSString * const kShowGuidancePage;

@end
