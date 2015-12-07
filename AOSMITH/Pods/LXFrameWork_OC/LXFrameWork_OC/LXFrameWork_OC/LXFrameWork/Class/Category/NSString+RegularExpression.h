//
//  NSString+RegularExpression.h
//  LiXiao
//
//  Created by 李晓 on 15/1/5.
//  Copyright (c) 2015年 pinmei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpression)

/**
 *  验证用户名是否合法
 *  用户名由 3-10位的字母下划线和数字组成。不能以数字或下划线开头。只能已字母开头。允许全部是字母
 */
- (BOOL) validationUserName;
/**
 *  验证密码是否合法
 *  以字母开头，长度在6-12之间，只能包含字符、数字和下划线
 */
- (BOOL) validationPwd;
/**
 *  是否 QQ 格式
 */
- (BOOL)isQQ;
/**
 *  是否为手机号格式
 */
- (BOOL)isPhoneNumber;
/**
 *  是否 IP 地址格式
 */
- (BOOL)isIPAddress;

@end
