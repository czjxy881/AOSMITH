//
//  MessageCodeTool.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/15.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "MessageCodeTool.h"
#import <SMS_SDK/SMSSDK.h>

@implementation MessageCodeTool

+ (void)getMessageCodeWithPhone:(NSString *)phone Zone:(NSString *)zone Success:(void (^)())success Error:(void (^)(NSError *))failure
{
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:zone == nil ? @"86" :zone customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            if (success) {
                success();
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)commitVerifyCode:(NSString *)code Phone:(NSString *)phone Zone:(NSString *)zone Success:(void (^)())success Error:(void (^)())failure
{
    [SMSSDK commitVerificationCode:code phoneNumber:phone zone:zone == nil ? @"86" :zone result:^(NSError *error) {
        if (!error) {
            if (success) {
                success();
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}


@end
