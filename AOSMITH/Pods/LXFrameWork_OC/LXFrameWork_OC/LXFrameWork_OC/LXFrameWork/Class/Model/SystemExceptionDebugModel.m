//
//  SystemExceptionDebugModel.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 16/2/19.
//  Copyright © 2016年 LXFrameWork. All rights reserved.
//

#import "SystemExceptionDebugModel.h"
#import "NSString+Extension.h"
#import <FMDB.h>

@implementation SystemExceptionDebugModel

static FMDatabase *_db;

+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSString getApplicationDocumentsDirectory] stringByAppendingPathComponent:@"SystemExceptionDebug.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_SystemExceptionDebug (id integer PRIMARY KEY, exception_time Date NOT NULL, exception blob,exception_callStack blob,dispose bool);"];
}

+ (void)addSystemExceptionDebugModel:(SystemExceptionDebugModel *)exception
{
    NSData *exception_data = [NSKeyedArchiver archivedDataWithRootObject:exception.exception];
    NSData *exception_callstack = [NSKeyedArchiver archivedDataWithRootObject:exception.exception_callStack];
    [_db executeUpdateWithFormat:@"INSERT INTO t_SystemExceptionDebug(exception_time,exception,exception_callStack,dispose) VALUES (%@,%@,%@,%d);",exception.exception_time,exception_data,exception_callstack,exception.dispose];
}

+ (void)updateExceptionStatusWithExceptionId:(NSInteger)exception_id
{
    [_db executeUpdateWithFormat:@"UPDATE t_SystemExceptionDebug set dispose = %d WHERE id = %ld;",YES,exception_id];
}

+ (SystemExceptionDebugModel *) getSystemExceptionDebugModelWithExceptionId:(NSInteger)exception_id
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_SystemExceptionDebug WHERE id = %ld",exception_id];
    SystemExceptionDebugModel *exceptionDebugModel = [[SystemExceptionDebugModel alloc]init];
    while (set.next) {
        NSData *exception = [set objectForColumnName:@"exception"];
        NSData *exception_callStack = [set objectForKeyedSubscript:@"exception_callStack"];
        exceptionDebugModel.exception_id = [set intForColumn:@"id"];
        exceptionDebugModel.exception_time = [set dateForColumn:@"exception_time"];
        exceptionDebugModel.exception = [NSKeyedUnarchiver unarchiveObjectWithData:exception];
        exceptionDebugModel.exception_callStack = [NSKeyedUnarchiver unarchiveObjectWithData:exception_callStack];
        exceptionDebugModel.dispose = [set boolForColumn:@"dispose"];
    }
    return exceptionDebugModel;
}

+ (NSArray *)getSystemExceptionDebugModelWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_SystemExceptionDebug order by id DESC limit %ld offset %ld ;", pageSize, (pageIndex - 1) * pageSize];
    NSMutableArray *exceptions = [NSMutableArray array];
    while (set.next) {
        NSData *exception = [set objectForColumnName:@"exception"];
        NSData *exception_callStack = [set objectForKeyedSubscript:@"exception_callStack"];
        SystemExceptionDebugModel *exceptionDebugModel = [[SystemExceptionDebugModel alloc]init];
        exceptionDebugModel.exception_id = [set intForColumn:@"id"];
        exceptionDebugModel.exception_time = [set dateForColumn:@"exception_time"];
        exceptionDebugModel.exception = [NSKeyedUnarchiver unarchiveObjectWithData:exception];
        exceptionDebugModel.exception_callStack = [NSKeyedUnarchiver unarchiveObjectWithData:exception_callStack];
        exceptionDebugModel.dispose = [set boolForColumn:@"dispose"];
        [exceptions addObject:exceptionDebugModel];
    }
    return exceptions;
}

@end
