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
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_HttpToolLog (id integer PRIMARY KEY, request_time text NOT NULL, request_URL text,request_data blob ,result_data blob,isSuccess bool);"];
}

+ (void) addHttpToolLog:(HttpToolLogModel *) httpLog
{
    NSData *request_data = [NSKeyedArchiver archivedDataWithRootObject:httpLog.request_dict];
    NSData *result_data = [NSKeyedArchiver archivedDataWithRootObject:httpLog.result_dict];
    [_db executeUpdateWithFormat:@"INSERT INTO t_HttpToolLog(request_time,request_URL,request_data,result_data,isSuccess) VALUES (%@,%@,%@,%@,%d)",httpLog.request_time,httpLog.request_URL,request_data,result_data,httpLog.isSuccess];
}

+ (HttpToolLogModel *) getHttpToolLogWithId:(NSInteger) log_id
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_HttpToolLog WHERE id = %ld",log_id];
    HttpToolLogModel *httpLog = [[HttpToolLogModel alloc]init];
    if (set.next) {
        NSData *request_data = [set objectForColumnName:@"request_data"];
        NSData *result_data = [set objectForColumnName:@"result_data"];
        
        httpLog.request_time = [set stringForColumn:@"request_time"];
        httpLog.request_URL = [set stringForColumn:@"request_URL"];
        httpLog.request_dict = [NSKeyedUnarchiver unarchiveObjectWithData:request_data];
        httpLog.result_dict = [NSKeyedUnarchiver unarchiveObjectWithData:result_data];
        httpLog.isSuccess = [set boolForColumn:@"isSuccess"];
    }
    return httpLog;
}

+ (NSArray *) getHttpToolLog
{
    FMResultSet *set = [_db executeQuery:@"SELECT * FROM t_HttpToolLog;"];
    NSMutableArray *HttpLogs = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        NSData *request_data = [set objectForColumnName:@"request_data"];
        NSData *result_data = [set objectForColumnName:@"result_data"];
        
        HttpToolLogModel *httpLog = [[HttpToolLogModel alloc]init];
        httpLog.request_time = [set stringForColumn:@"request_time"];
        httpLog.request_URL = [set stringForColumn:@"request_URL"];
        httpLog.request_dict = [NSKeyedUnarchiver unarchiveObjectWithData:request_data];
        httpLog.result_dict = [NSKeyedUnarchiver unarchiveObjectWithData:result_data];
        httpLog.isSuccess = [set boolForColumn:@"isSuccess"];
        [HttpLogs addObject:httpLog];
    }
    return HttpLogs;
}


@end
