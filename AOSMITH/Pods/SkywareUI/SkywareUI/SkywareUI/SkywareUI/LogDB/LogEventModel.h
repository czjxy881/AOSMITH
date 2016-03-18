//
//  LogEventModel.h
//  Pods
//
//  Created by ybyao07 on 16/1/28.
//
//

#import <Foundation/Foundation.h>

/**
事件表
event_id		-- 事件id
event_name		-- 事件名称
event_category 		-- 事件类型（1-抽象逻辑，2–业务逻辑, 3-用户交互，4-接口请求，5-数据库读写 ...）
event_remark		-- 事件备注

日志表
id			-- 自增id
tid 			-- 流水号（参考海尔设计，该事件的唯一时空标识，时间戳+userid+clientid）
event_id		-- 事件id
user_id 		-- 用户id
parent_event_id 	-- 父事件id（父事件不是固定的，一个事件在不同场景可能有不同父事件）
parent_tid 		-- 父事件流水号（由父事件传给子事件，用于追溯一个事件流）
parent_order 		-- 此事件在父事件中的顺序标识（从1开始）
event_start_time	-- 开始时间
event_end_time     -- 结束时间
event_input		-- 输入参数，根据不同类型定义不同参数
event_result 		-- 结果，0-失败  1-成功
event_output 		-- 输出参数，根据不同类型定义不同结果
event_exception 	-- 发生异常的类型
event_exception_info  	-- 具体异常的信息，比如接口返回错误信息，错误堆栈日志等信息

flag_upload		-- 标记：该事件是否需要上传服务器（服务器端不需要此字段）
**/

@interface LogEventModel : NSObject
@property (nonatomic,assign) int event_id;
@property (nonatomic,copy) NSString *event_name;
@property (nonatomic,assign) int event_category;
@property (nonatomic,copy) NSString *event_remark;

@property (nonatomic,copy) NSString *device_mac;
@property (nonatomic,assign) int tid;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *parent_event_id;
@property (nonatomic,copy) NSString *parent_pid;
@property (nonatomic,copy) NSString *parent_order;


@property (nonatomic,assign) long event_start_time;
@property (nonatomic,assign) long event_end_time;
@property (nonatomic,copy) NSString *event_input;
@property (nonatomic,copy) NSString *event_result;
@property (nonatomic,copy) NSString *event_output;
@property (nonatomic,copy) NSString *event_exception;
@property (nonatomic,copy) NSString *event_exception_info;

@property (nonatomic,assign) int flag_upload;


@end
