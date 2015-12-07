//
//  NSString+Extension.m
//  LiXiao
//
//  Created by 李晓 on 14-10-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Size)

- (CGSize) sizeWithFont:(UIFont *) font
{
    return [self sizeWithFont:font Width:MAXFLOAT];
}

- (CGSize) sizeWithFont:(UIFont *)font Width:(CGFloat) width
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

- (NSString *)encodeToPercentEscapeString
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)self,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    CFRelease((__bridge CFTypeRef)(outputStr));
    return outputStr;
}

- (NSString *)decodeFromPercentEscapeString
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)getApplicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString *)FormatterYYYYMMDD
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:self];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

-(NSString*) removeStringFrontZero
{
    NSString *str = self;
    while ([str hasPrefix:@"0"]){
        str = [str substringFromIndex:1];
    }
    return str;
}

-(NSData*) stringHexToBytes {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSDate *)FormatterDateFromYMDHMS
{
    NSDateFormatter *strToDateFor = [[NSDateFormatter alloc]init];
    strToDateFor.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    return [strToDateFor dateFromString:self];
}

- (NSDate *)FormatterDateFromYMD
{
    NSDateFormatter *strToDateFor = [[NSDateFormatter alloc]init];
    strToDateFor.dateFormat = @"yyyy/MM/dd";
    return [strToDateFor dateFromString:self];
}

@end
