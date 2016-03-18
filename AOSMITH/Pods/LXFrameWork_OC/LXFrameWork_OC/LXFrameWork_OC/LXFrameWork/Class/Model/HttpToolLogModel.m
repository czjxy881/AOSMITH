//
//  HttpToolLogModel.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/7.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "HttpToolLogModel.h"
#import "NSString+Extension.h"
#import <FMDB.h>

@implementation HttpToolLogModel

static FMDatabase *_db;

+ (void)initialize
{
    // 1.打开数据库
    NSString *path = [[NSString getApplicationDocumentsDirectory] stringByAppendingPathComponent:@"HttpToolLog.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_HttpToolLog (id integer PRIMARY KEY, request_time text NOT NULL, request_URL text,request_heard_data blob ,request_data blob ,result_data blob,error_data blob,isSuccess bool);"];
}

+ (void) addHttpToolLog:(HttpToolLogModel *) httpLog
{
    NSData *error_data = [NSKeyedArchiver archivedDataWithRootObject:httpLog.error_data];
    NSData *result_data = [NSKeyedArchiver archivedDataWithRootObject:httpLog.result_data];
    NSData *request_data = [NSKeyedArchiver archivedDataWithRootObject:httpLog.request_data];
    NSData *request_heard_data = [NSKeyedArchiver archivedDataWithRootObject:httpLog.request_heard_data];
    [_db executeUpdateWithFormat:@"INSERT INTO t_HttpToolLog(request_time,request_URL,request_heard_data,request_data,result_data,error_data,isSuccess) VALUES (%@,%@,%@,%@,%@,%@,%d);",httpLog.request_time,httpLog.request_URL,request_heard_data,request_data,result_data,error_data,httpLog.isSuccess];
}

+ (HttpToolLogModel *) getHttpToolLogWithId:(NSInteger) log_id
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_HttpToolLog WHERE id = %ld",log_id];
    HttpToolLogModel *httpLog = [[HttpToolLogModel alloc]init];
    if (set.next) {
        NSData *request_data = [set objectForColumnName:@"request_data"];
        NSData *result_data = [set objectForColumnName:@"result_data"];
        NSData *error_data = [set objectForColumnName:@"error_data"];
        NSData *request_heard_data = [set objectForColumnName:@"request_heard_data"];
        
        httpLog.request_time = [set stringForColumn:@"request_time"];
        httpLog.request_URL = [set stringForColumn:@"request_URL"];
        httpLog.error_data = [NSKeyedUnarchiver unarchiveObjectWithData:error_data];
        httpLog.result_data = [NSKeyedUnarchiver unarchiveObjectWithData:result_data];
        httpLog.request_data = [NSKeyedUnarchiver unarchiveObjectWithData:request_data];
        httpLog.request_heard_data = [NSKeyedUnarchiver unarchiveObjectWithData:request_heard_data];
        httpLog.Success = [set boolForColumn:@"isSuccess"];
    }
    return httpLog;
}

+ (NSArray *) getHttpToolLogWithPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_HttpToolLog order by id DESC limit %ld offset %ld ;", pageSize, (pageIndex - 1) * pageSize];
    NSMutableArray *HttpLogs = [NSMutableArray array];
    while (set.next) {
        NSData *result_data = [set objectForColumnName:@"result_data"];
        NSData *request_data = [set objectForColumnName:@"request_data"];
        NSData *error_data = [set objectForColumnName:@"error_data"];
        NSData *request_heard_data = [set objectForColumnName:@"request_heard_data"];
        
        HttpToolLogModel *httpLog = [[HttpToolLogModel alloc]init];
        httpLog.log_id = [set intForColumn:@"id"];
        httpLog.request_time = [set stringForColumn:@"request_time"];
        httpLog.request_URL = [set stringForColumn:@"request_URL"];
        httpLog.error_data = [NSKeyedUnarchiver unarchiveObjectWithData:error_data];
        httpLog.result_data = [NSKeyedUnarchiver unarchiveObjectWithData:result_data];
        httpLog.request_data = [NSKeyedUnarchiver unarchiveObjectWithData:request_data];
        httpLog.request_heard_data = [NSKeyedUnarchiver unarchiveObjectWithData:request_heard_data];
        httpLog.Success = [set boolForColumn:@"isSuccess"];
        [HttpLogs addObject:httpLog];
    }
    return HttpLogs;
}


@end
