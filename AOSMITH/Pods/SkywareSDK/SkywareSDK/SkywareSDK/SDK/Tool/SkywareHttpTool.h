//
//  SkywareHttpTool.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareSDK.h"
#import <HttpTool.h>
#import <SystemDeviceTool.h>
#import <SVProgressHUD.h>
#import <NSString+Hash.h>
#import <NSString+Extension.h>

typedef enum {
    request_success = 200,                      // 响应成功
    request_parameter_error = 400,             // 签名不正确或请求参数不正确
    request_token_inexistence = 401,          // token不存在
    request_prohibit = 403,                  // 403：禁止访问（黑名单）
    request_resultless = 404,               // 请求无结果
    request_method_inexistence = 405,      // 方法不存在
    request_https = 406,                  // 必须https
    request_frequently = 429,            // 访问速度过快
    request_services_error = 500,       // 服务器错误
    request_create_folder_error = 501, // 创建文件夹失败
    
} resultMessage;

@interface SkywareHttpTool : NSObject

/**
 *  请求成功后返回判断状态码，做出相应的判断
 *
 *  @param json    返回的Json
 *  @param success 成功 block
 *  @param failure 错误 block
 */
+(void) responseHttpToolWithJson:(id)json Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

/**
 *  请求失败后返回错误信息，做出相应的判断
 *
 *  @param Error    返回的错误信息
 */
+ (void)ErrorLogDispose:(NSError *)error;

/**
 *  发送GET请求
 *
 */
+ (void) HttpToolGetWithUrl:(NSString *) url paramesers:(NSArray *) parameser requestHeaderField:(NSDictionary *) header SuccessJson:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;

/**
 *  发送POST请求
 *
 */
+ (void) HttpToolPostWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser requestHeaderField:(NSDictionary *) header SuccessJson:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;

/**
 *  发送PUT请求
 *
 */
+ (void) HttpToolPutWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser requestHeaderField:(NSDictionary *) header SuccessJson:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;

/**
 *  发送Delete请求
 *
 */
+ (void) HttpToolDeleteWithUrl:(NSString *) url paramesers:(NSArray *) parameser requestHeaderField:(NSDictionary *) header SuccessJson:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;

/**
 *  发送Post请求上传数据
 *
 */
+ (void)HttpToolUploadWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *) header Data:(NSData *)data Name:(NSString *)name FileName:(NSString *) fileName MainType:(NSString *)mainType SuccessJson:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;


@end
