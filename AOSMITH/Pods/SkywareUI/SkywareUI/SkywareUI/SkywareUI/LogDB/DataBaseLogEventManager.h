//
//  DataBasePrivateLetter.h
//  startKitchen
//
//  Created by blue on 15/6/16.
//  Copyright (c) 2015年 203b. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogEventModel.h"
#import <FMDatabase.h>
#import <FMDatabaseQueue.h>

@interface DataBaseLogEventManager : NSObject

+(DataBaseLogEventManager *)shareDatabaseManager;

-(void)insertData:(LogEventModel *)data;
-(void)deleteData;

-(NSArray *)selectData;   //选择flag_upload = 1的事件
-(void)updateData:(LogEventModel *)data; //单独更新某个事件

-(void)updateFlagUploadWithEventId:(NSInteger)eventId AndAfterTime:(NSInteger)eventStartTime; //只更新指定时间之后 日志事件 上传的状态 （1为上传到服务器）

@end
