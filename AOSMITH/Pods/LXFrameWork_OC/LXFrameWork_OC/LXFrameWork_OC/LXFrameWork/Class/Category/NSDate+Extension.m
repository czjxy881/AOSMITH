//
//  NSDate+Extension.m
//  LiXiao
//
//  Created by 李晓 on 14-10-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  判断是不是今年
 *
 */
- (BOOL) isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger crateYear =  [calendar components: NSCalendarUnitYear fromDate:self].year;
    NSInteger nowYear = [calendar components: NSCalendarUnitYear fromDate:[NSDate date]].year;
    return crateYear == nowYear;
}

/**
 *  判断是不是今天
 *
 */
- (BOOL) isToday
{
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    sdf.dateFormat = @"yyyy-MM-dd";
    NSString *createStr = [sdf stringFromDate:self];
    NSString *nowStr = [sdf stringFromDate:[NSDate date]];
    return [createStr isEqualToString:nowStr];
}

/**
 *  判断是不是昨天
 *
 */
-(BOOL) isYesterday
{
    NSCalendarUnit unit = kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    sdf.dateFormat = @"yyyy-MM-dd";
    NSString *createStr = [sdf stringFromDate:self];
    NSDate *createDate = [sdf dateFromString:createStr];
    
    NSString *nowStr = [sdf stringFromDate:[NSDate date]];
    NSDate *nowDate = [sdf dateFromString:nowStr];
    
    NSDateComponents *component =  [calendar components:unit fromDate:createDate toDate:nowDate options:0];
    return (component.year ==0 && component.month == 0 && component.day == 1);
}

- (NSString*)FormatterYMDHMS
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:self];
}

- (NSString *)FormatterYMD
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:self];
}


- (NSString *)getMillisecond
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
    return [NSString stringWithFormat:@"%f", a]; //转为字符型
}

+ (NSInteger)compareData:(NSDate *)date1 WithDate:(NSDate *)date2
{
    NSComparisonResult result = [date1 compare:date2];
    if (result == NSOrderedAscending) { //升序，右边 > 左边
        return 1 ;
    }else if (result == NSOrderedSame){
        return 0;
    }else if (result == NSOrderedDescending){ //降序，右边 < 左边
        return -1;
    }
    return 0;
}

+ (NSInteger)compareStrData:(NSString *)date1 WithDate:(NSString *)date2
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [df dateFromString:date1];
    NSDate *dt2 = [df dateFromString:date2];
    return  [self compareData:dt1 WithDate:dt2];
}

+ (NSTimeInterval)getDiscrepancyData:(NSDate *)date1 WithDate:(NSDate *)date2
{
    NSTimeInterval dt1 = [date1 timeIntervalSince1970];
    NSTimeInterval dt2 = [date2 timeIntervalSince1970];
    return dt2 - dt1;
}

@end
