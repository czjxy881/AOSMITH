//
//  NSString+RegularExpression.m
//  LiXiao
//
//  Created by 李晓 on 15/1/5.
//  Copyright (c) 2015年 pinmei. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString (RegularExpression)

- (BOOL)match:(NSString *)pattern
{
    // 1.创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return results.count > 0;
}

- (BOOL)validationUserName
{
    return [self match:@"^[a-zA-z][a-zA-Z0-9_]{2,9}$"];
}

- (BOOL)validationPwd
{
    return [self match:@"^[a-zA-Z]\\w{5,11}$"];
}

- (BOOL)isQQ
{
    return [self match:@"^[1-9]\\d{4,10}$"];
}

- (BOOL)isPhoneNumber
{
    return [self match:@"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"];
    
}

- (BOOL)isIPAddress
{
    return [self match:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"];
}
@end
