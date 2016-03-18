//
//  HttpToolLogModel.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/7.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用户请求日志记录
 */
@interface HttpToolLogModel : NSObject

@property (nonatomic,assign) NSInteger log_id;
/**
 *  请求时间
 */
@property (nonatomic,copy) NSString *request_time;
/**
 *  请求地址
 */
@property (nonatomic,copy) NSString *request_URL;
/**
 *  请求头参数
 */
@property (nonatomic,copy) NSDictionary *request_heard_data;
/**
 *  请求参数
 */
@property (nonatomic,copy) NSDictionary *request_data;
/**
 *  返回的对象
 */
@property (nonatomic,strong) NSDictionary *result_data;
/**
 *  返回的错误对象（NSError）
 */
@property (nonatomic,strong) NSError *error_data;
/**
 *  是否成功
 */
@property (nonatomic,assign,getter=isSuccess) BOOL Success;

/**
 *  添加请求日志 Log
 */
+ (void) addHttpToolLog:(HttpToolLogModel *) httpLog;

/**
 *  根据 Log_id 查询详细
 */
+ (HttpToolLogModel *) getHttpToolLogWithId:(NSInteger) log_id;

/**
 *  分页查询请求日志
 *
 *  @param pageIndex 第几页
 *  @param pageSize  每页显示条数
 *
 *  @return Arary
 */
+ (NSArray *) getHttpToolLogWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
