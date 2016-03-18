//
//  DataBasePrivateLetter.m
//  startKitchen
//
//  Created by blue on 15/6/16.
//  Copyright (c) 2015年 203b. All rights reserved.
//

#import "DataBaseLogEventManager.h"
#import "SkywareSDKManager.h"

#define DBNAME    @"logevent.sqlite"
#define TABLENAME @"LogEvent_tb"
#define  ID @"id"

#define isEmptyString( str )  (( str == nil || str == NULL || [str isEqualToString:@""] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) ? YES : NO)

NSString *const Device_mac = @"device_mac";
NSString * const Event_id =@"event_id";
NSString * const Event_name =@"event_name";
NSString * const Event_category =@"event_category";
NSString * const Event_remark =@"event_remark";

NSString * const tid =@"tid";
NSString * const user_id =@"user_id";
NSString * const parent_event_id =@"parent_event_id";
NSString * const parent_pid =@"parent_pid";
NSString * const parent_order =@"parent_order";

NSString * const Event_start_time =@"event_start_time";
NSString * const Event_end_time =@"event_end_time";
NSString * const Event_input =@"event_input";
NSString * const Event_output =@"event_output";
NSString * const Event_result =@"event_result";
NSString * const Event_exception =@"event_exception";
NSString * const Event_exception_info =@"event_exception_info";

@interface DataBaseLogEventManager()
@end

@implementation DataBaseLogEventManager

static FMDatabase *db;
+(DataBaseLogEventManager *)shareDatabaseManager
{
    static DataBaseLogEventManager *logeventManager = nil;
    static dispatch_once_t onceToken;
    //一次只允许一个线程访问
    dispatch_once(&onceToken, ^{
        if(logeventManager==nil){
            logeventManager =  [[self alloc] init];
            NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documents = [paths objectAtIndex:0];
            //获取数据库
            db = [FMDatabase databaseWithPath:[documents stringByAppendingPathComponent:DBNAME]];
            [self createTable];
        }
    });
    return logeventManager;
}
+(void)createTable{
    if ([db open]) {
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS LogEvent_tb ( \
        id integer PRIMARY KEY AUTOINCREMENT, \
        device_mac TEXT,\
        event_id integer, \
        event_name TEXT, \
        event_category integer , \
        event_remark TEXT, \
        event_start_time INTEGER, \
        event_end_time INTEGER, \
        event_input TEXT, \
        event_output TEXT, \
        event_result TEXT, \
        event_exception TEXT,\
        event_exception_info TEXT,\
        flag_upload integer);";
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        [db close];
    }
}

-(void)insertData:(LogEventModel *)data{
    if ([db open]) {
        NSString *insertSql=
        @"INSERT INTO LogEvent_tb(device_mac,event_id,event_name,event_category,event_remark,event_start_time,event_end_time,event_input,event_output,event_result,event_exception,event_exception_info,flag_upload) VALUES (?,?, ?, ?, ?, ?,?, ?, ?, ?, ?,?,?)";
        BOOL res = [db executeUpdate:insertSql,data.device_mac,@(data.event_id),data.event_name,@(data.event_category),data.event_remark,@(data.event_start_time), @(data.event_end_time),data.event_input,data.event_output,data.event_result,data.event_exception,data.event_exception_info,@(data.flag_upload)];
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [db close];
    }
}

-(void)updateData:(LogEventModel *)data{
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"update LogEvent_tb set device_mac = ?, event_remark = ?, event_end_time = ?, event_input = ?, event_output = ?, event_result = ?, flag_upload = ? WHERE event_id = ? AND event_start_time = ?"];
        BOOL update = [db executeUpdate:sql,data.device_mac,data.event_remark,@(data.event_end_time),data.event_input,data.event_output,data.event_result, @(data.flag_upload), @(data.event_id),@(data.event_start_time)];
        if(update){
            NSLog(@"success when update db table");
        }else{
            NSLog(@"error when update db table");
        }
        [db close];
    }
}

-(void)updateFlagUploadWithEventId:(NSInteger)eventId AndAfterTime:(NSInteger)eventStartTime
{
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"update LogEvent_tb set flag_upload = ? WHERE event_id = ? AND event_start_time = ?"];
        BOOL update = [db executeUpdate:sql,@(1),@(eventId),@(eventStartTime)];
        if(update){
            NSLog(@"success when update db table");
        }else{
            NSLog(@"error when update db table");
        }
        [db close];
    }
}

-(void)deleteData{
    if ([db open]) {
        
//        BOOL res =  [db executeUpdate:@"DROP TABLE IF EXISTS LogEvent_tb;"];
        BOOL res = [db executeUpdate:@"Delete From LogEvent_tb"];
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
        
        [db close];
    }
}

-(NSArray *)selectData{
    if ([db open]) {
        //获取
        NSMutableArray *eventDicArray = [NSMutableArray new];
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ WHERE flag_upload = ?",TABLENAME];
        FMResultSet * rs = [db executeQuery:sql,@(1)];
        while ([rs next]) {
            NSString *deviceMac = [rs stringForColumn:Device_mac];
            NSInteger eventId = [rs intForColumn:Event_id];
            NSString *eventName = [rs stringForColumn:Event_name];
            NSInteger eventCate = [rs intForColumn:Event_category];
            NSString *eventRemark = [rs stringForColumn:Event_remark];
            NSInteger eventStartTime = [rs intForColumn:Event_start_time];
            NSInteger eventEndTime = [rs intForColumn:Event_end_time];
            NSString *eventInput = [rs stringForColumn:Event_input];
            NSString *eventOutput = [rs stringForColumn:Event_output];
            NSString *eventResult = [rs stringForColumn:Event_result];
            NSString *eventException = [rs stringForColumn:Event_exception];
            NSString *eventExceptionInfo = [rs stringForColumn:Event_exception_info];
            //            NSLog(@"id = %ld, name = %@, content = %@", eventId, eventName);
            SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
            NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSDictionary *dic = @{
                                  @"app_id":@(manager.app_id),
                                  @"app_type":@"1",
                                  @"app_version":app_version,
                                  Device_mac:isEmptyString(deviceMac)?@"":deviceMac ,
                                  Event_id:@(eventId),
                                  Event_name:isEmptyString(eventName)?@"":eventName,
                                  Event_category:@(eventCate),
                                  Event_remark: isEmptyString(eventRemark)?@"":eventRemark,
                                  Event_start_time:@(eventStartTime),
                                  Event_end_time:@(eventEndTime),
                                  Event_input:isEmptyString(eventInput)?@"":eventInput,
                                  Event_output:isEmptyString(eventOutput)?@"":eventOutput,
                                  Event_result:isEmptyString(eventResult)?@"":eventResult,
                                  Event_exception:isEmptyString(eventException)?@"":eventException,
                                  Event_exception_info:isEmptyString(eventExceptionInfo)?@"":eventExceptionInfo
                                  };
            [eventDicArray addObject:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding]];
            //            [eventDicArray addObject:dic];
        }
        [db close];
        return eventDicArray;
    }
    return nil;
}


@end
