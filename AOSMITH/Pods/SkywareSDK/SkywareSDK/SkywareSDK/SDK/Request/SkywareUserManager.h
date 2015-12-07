//
//  SkywareUserManager.h
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareHttpTool.h"

@interface SkywareUserManager : NSObject

/**
 *  验证用户id （login_id 在数据库中是否存在）
 */
+ (void) UserVerifyLoginIdExistsWithLoginid:(NSString *) login_id Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  获取用户信息
 */
+ (void) UserGetUserWithParamesers:(NSArray *)parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  修改用户信息
 */
+ (void) UserEditUserWithParamesers:(NSDictionary *)parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  用户上传头像
 */
+ (void)UserUploadIconWithParamesers:(NSDictionary *)parameser Icon:(UIImage *)img FileName:(NSString *) fileName Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  修改用户密码
 */
+ (void) UserEditUserPasswordWithParamesers:(NSDictionary *)parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  用户注册
 */
+ (void) UserRegisterWithParamesers:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  用户登录
 */
+ (void) UserLoginWithParamesers:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  找回密码
 */
+ (void) UserRetrievePasswordWithParamesers:(NSDictionary *) parameser Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  用户反馈
 */
+ (void) UserFeedBackWithParamesers:(SkywareUserFeedBackModel *) model Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;


@end
