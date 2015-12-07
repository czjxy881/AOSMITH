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

/**
 *  请求时间
 */
@property (nonatomic,copy) NSString *request_time;

/**
 *  请求地址
 */
@property (nonatomic,copy) NSString *request_URL;
/**
 *  请求参数
 */
@property (nonatomic,copy) NSDictionary *request_dict;
/**
 *  返回的对象
 */
@property (nonatomic,strong) NSDictionary *result_dict;
/**
 *  是否成功
 */
@property (nonatomic,assign) BOOL isSuccess;


+ (void) addHttpToolLog:(HttpToolLogModel *) httpLog;

+ (HttpToolLogModel *) getHttpToolLogWithId:(NSInteger) log_id;

+ (NSArray *) getHttpToolLog;


@end
