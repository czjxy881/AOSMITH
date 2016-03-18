//
//  SystemExceptionDebugModel.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 16/2/19.
//  Copyright © 2016年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  App异常日志记录
 */
@interface SystemExceptionDebugModel : NSObject

/**
 *  异常ID
 */
@property (nonatomic,assign) NSInteger exception_id;
/**
 *  请求时间
 */
@property (nonatomic,strong) NSDate *exception_time;
/**
 *  异常
 */
@property (nonatomic,strong) NSException *exception;
/**
 *  异常详细地址错误信息
 */
@property (nonatomic,strong) NSArray *exception_callStack;
/**
 *  是否处理过
 */
@property (nonatomic,assign,getter=isDispose) BOOL dispose;


/**
 *  添加异常日志
 */
+ (void)addSystemExceptionDebugModel:(SystemExceptionDebugModel *)exception;

/**
 *  更新异常日志状态
 */
+ (void)updateExceptionStatusWithExceptionId:(NSInteger)exception_id;

/**
 *  根据 exception_id 查询
 */
+ (SystemExceptionDebugModel *) getSystemExceptionDebugModelWithExceptionId:(NSInteger)exception_id;

/**
 *  分页查询异常日志
 *
 *  @param pageIndex 第几页
 *  @param pageSize  每页显示条数
 *
 *  @return Arary
 */
+ (NSArray *)getSystemExceptionDebugModelWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
