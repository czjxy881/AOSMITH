//
//  SkywareUserManager.m
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SkywareUserManager.h"

@implementation SkywareUserManager

+ (void)UserVerifyLoginIdExistsWithLoginid:(NSString *)login_id Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSMutableArray *parameser = [NSMutableArray array];
    [parameser addObject:@(manager.app_id)];
    [parameser addObject:login_id];
    [SkywareHttpTool HttpToolGetWithUrl:UserCheckId paramesers:parameser requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure]; // message = 200 找到 = 已经注册过
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)UserGetUserWithParamesers:(NSArray *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolGetWithUrl:User paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)UserRegisterWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *result))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameser];
    [dict setObject: @(manager.app_id) forKey:@"app_id"];
    [SkywareHttpTool HttpToolPostWithUrl:UserRegisterURL paramesers:dict requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)UserLoginWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *result))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameser];
    [dict setObject: @(manager.app_id) forKey:@"app_id"];
    [SkywareHttpTool HttpToolPostWithUrl:UserLoginURL paramesers:dict requestHeaderField:nil SuccessJson:^(id json) {
        SkywareResult *result = [SkywareResult mj_objectWithKeyValues:json];
        NSInteger message = [result.message integerValue];
        if (message == request_success) {
            manager.token = result.token;
        }
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)UserRetrievePasswordWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *result))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameser];
    [dict setObject: @(manager.app_id) forKey:@"app_id"];
    [SkywareHttpTool HttpToolPostWithUrl:UserRetrievePassword paramesers:dict requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)UserEditUserWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPutWithUrl:User paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)UserEditUserPasswordWithParamesers:(NSDictionary *)parameser Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolPutWithUrl:UserPassword paramesers:parameser requestHeaderField:@{@"token":manager.token} SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)UserUploadIconWithParamesers:(NSDictionary *)parameser Icon:(UIImage *)img FileName:(NSString *)fileName Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    [SkywareHttpTool HttpToolUploadWithUrl:UserUploadIcon paramesers:@{@"token":manager.token} requestHeaderField:@{@"token":manager.token}  Data:UIImagePNGRepresentation(img) Name:@"file" FileName:fileName MainType:@"image/gif" SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

+ (void)UserFeedBackWithParamesers:(SkywareUserFeedBackModel *)model Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
    model.app_version = [SystemDeviceTool getApp_Version];
    model.category = 1;
    model.app_id = [NSString stringWithFormat:@"%ld",manager.app_id];
    [SkywareHttpTool HttpToolPostWithUrl:UserFeedBack paramesers:model.mj_keyValues requestHeaderField:@{@"token":manager.token}  SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        [SkywareHttpTool ErrorLogDispose:error];
    }];
}

@end
