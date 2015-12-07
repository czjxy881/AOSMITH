//
//  SkywareResult.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface SkywareResult : NSObject<NSCoding>

/*** 用户手机号 */
@property (nonatomic,copy) NSString *phone;

/*** 用户密码 */
@property (nonatomic,copy) NSString *password;

/*** 用户token */
@property (nonatomic,copy) NSString *token;

/*** 返回的状态消息 */
@property (nonatomic,copy) NSString *message;

/*** 用户登录ID(用户手机号) */
@property (nonatomic,copy) NSString *login_id;

/*** 返回状态 */
@property (nonatomic,copy) NSString *status;

/*** 返回info */
@property (nonatomic,strong) id result;

/** 当前系统时间戳 */
@property (nonatomic,copy) NSString *time;

/** 用户头像的URL */
@property (nonatomic,copy) NSString *icon_url;

@end
