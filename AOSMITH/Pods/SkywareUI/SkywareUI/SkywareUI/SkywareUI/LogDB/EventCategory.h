//
//  EventCategory.h
//  Pods
//
// 日志类型定义
//  Created by ybyao07 on 16/2/18.
//
//

#import <Foundation/Foundation.h>

@interface EventCategory : NSObject

@property (nonatomic,strong) NSNumber *event_id;  /** 日志事件id  **/
@property (nonatomic,copy) NSString *event_name; /** 日志事件名称  **/
@property (nonatomic,strong) NSNumber *event_category; /**  日志类型 **/
@property (nonatomic,copy) NSString *event_descrip;  /** 事件描述  **/
@property (nonatomic,copy) NSString *event_remark;   /** 备注  **/


@end
