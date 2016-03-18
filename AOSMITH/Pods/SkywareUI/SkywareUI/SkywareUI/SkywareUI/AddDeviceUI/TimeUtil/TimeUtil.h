//
//  StartTimeUtil.h
//  Pods
//
//  Created by ybyao07 on 16/2/17.
//
//

#import <Foundation/Foundation.h>
#import "LXSingleton.h"
@interface TimeUtil : NSObject

LXSingletonH(TimeUtil)

@property (nonatomic,assign) long addDeviceStartTime;  /** 开始日志的第一个时间点 **/
@property (nonatomic,assign) long addDeviceEndTime;  /** 日志结束时间 **/

@property (nonatomic,assign) long configNetwokStartTime;  /** 设备配网开始时间 **/
@property (nonatomic,assign) long configNetwokEndTime;    /** 设备配网结束时间 **/


@property (nonatomic,assign) long smartLinkStartTime;  /** smartLink开始时间 **/
@property (nonatomic,assign) long smartLinkEndTime;  /** smartLink结束时间 **/

@property (nonatomic,assign) long checkOnlineApiStartTime; /** 检查设备是否上线开始时间 **/
@property (nonatomic,assign) long checkOnlineApiEndTime;  /** 检查设备是否上线结束时间 **/



@property (nonatomic,assign) long bindDeviceStartTime; /** 绑定设备  开始时间**/
@property (nonatomic,assign) long bindDeviceEndTime;   /** 绑定设备 结束时间 **/


@property (nonatomic,assign) long bindDeviceApiStartTime;   /** 绑定设备API 开始时间 **/
@property (nonatomic,assign) long bindDeviceApiEndTime;    /** 绑定设备API 结束时间 **/

@property (nonatomic,assign) long updateDeviceApiStartTime;  /** 提交设备信息请求 开始时间 **/
@property (nonatomic,assign) long updateDeviceApiEndTime;  /** 提交设备信息请求 结束时间 **/

@end
