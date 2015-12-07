//
//  MessageCodeTool.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/15.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCodeTool : NSObject

/**
 *  发送短信获取验证码
 *
 *  @param phone   手机号
 *  @param zone    区号 不传为86
 *  @param success 正确
 *  @param failure 错误
 */
+ (void) getMessageCodeWithPhone:(NSString *) phone Zone:(NSString *) zone Success :(void(^)()) success Error:(void(^)(NSError *error)) failure;

/**
 *  验证码是否正确
 *
 *  @param code    收到的验证码
 *  @param phone   手机号
 *  @param zone    区号 不传为86
 *  @param success 正确
 *  @param failure 错误
 */
+ (void)commitVerifyCode:(NSString *)code Phone:(NSString *)phone Zone:(NSString *)zone Success:(void (^)())success Error:(void (^)())failure;

@end
