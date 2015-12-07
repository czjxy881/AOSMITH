//
//  self.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/16.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareHttpTool.h"

@implementation SkywareHttpTool

+ (void)ErrorLogDispose:(NSError *)error
{
    NSLog(@"HTTP_Error = %@",error);
    /**
     *  有可能报 Code = 1011  服务器错误
     */
    if (error.code == -1001) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力 请检查网络设置"];
    }else if(error.code == -1011){        // 连接数过多
        [SVProgressHUD showErrorWithStatus:@"网络拥挤 请稍后重试"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请求失败 请稍后再试"];
    }
}

/**
 *  请求成功后返回判断状态码，做出相应的判断
 *
 *  @param json    返回的Json
 *  @param success 成功 block
 *  @param failure 错误 block
 */
+(void) responseHttpToolWithJson:(id)json Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    SkywareResult *result = [SkywareResult mj_objectWithKeyValues:json];
    NSInteger message = [result.message integerValue];
    if (message == request_frequently) {
        [SVProgressHUD showInfoWithStatus:@"亲～慢点我快顶不住了..."];
        return;
    }
    if (message == request_success) {
        if (success) {
            success(result);
        }
    }else{
        if (failure) {
            failure(result);
        }else{
            [SVProgressHUD dismiss];
        }
    }
}


+(void)HttpToolGetWithUrl:(NSString *)url paramesers:(NSArray *)parameser requestHeaderField:(NSDictionary *) header SuccessJson:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *URL = [self getURLWithRUL:url AndParamesers:parameser];
    [HttpTool HttpToolGetWithUrl: URL paramesers:nil requestHeaderField:[self getSignatureWithRequestHeader:header URL:URL] Serializer:JSONResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *) header SuccessJson:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPostWithUrl:[self getEncryptURLWithRUL:url] paramesers:parameser requestHeaderField:[self getSignatureWithRequestHeader:header URL:url] Serializer:JSONResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)HttpToolPutWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *) header SuccessJson:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *URL = [self getEncryptURLWithRUL:url];
    [HttpTool HttpToolPutWithUrl:URL paramesers:parameser requestHeaderField:[self getSignatureWithRequestHeader:header URL:URL] Serializer:JSONResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolDeleteWithUrl:(NSString *)url paramesers:(NSArray *)parameser requestHeaderField:(NSDictionary *) header SuccessJson:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *URL = [self getURLWithRUL:url AndParamesers:parameser];
    [HttpTool HttpToolDeleteWithUrl: URL paramesers:nil requestHeaderField:[self getSignatureWithRequestHeader:header URL:URL] Serializer:JSONResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)HttpToolUploadWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *) header Data:(NSData *)data Name:(NSString *)name FileName:(NSString *) fileName MainType:(NSString *)mainType SuccessJson:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPostWithUrl:[self getEncryptURLWithRUL:url] paramesers:parameser requestHeaderField:[self getSignatureWithRequestHeader:header URL:url] Data:data Name:name FileName:fileName MainType:mainType Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  对请求进行加密
 *
 */
+ (NSDictionary *) getSignatureWithRequestHeader:(NSDictionary *)header URL:(NSString *)url
{
    NSMutableDictionary *signatureDic = [NSMutableDictionary dictionary];
    NSMutableString *urlsub = [NSMutableString string];
    NSRange range= [url rangeOfString:@"api"];
    if (range.location != NSNotFound) {
        NSString *apiUrl = [url substringFromIndex:range.location + 4];
        NSArray *urlArray = [apiUrl componentsSeparatedByString:@"/"];
        [urlArray enumerateObjectsUsingBlock:^(NSString  *str, NSUInteger idx, BOOL *stop) {
            [urlsub appendString:str];
        }];
    }else{
        [urlsub appendString:url];
    }
    NSString *token = [header objectForKey:@"token"];
    [signatureDic setObject:kSignature_apiver forKey:@"apiver"];
    if (token) { // 需要 token
        [signatureDic setObject:token forKey:@"token"];
        NSString *signature = [[NSString stringWithFormat:@"%@%@%@%@",[urlsub md5String],kSignature_apiver,token,kSignature_key] md5String];
        [signatureDic setObject:signature forKey:@"signature"];
    }else{ // 不需要token
        NSString *signature = [[NSString stringWithFormat:@"%@%@%@",[urlsub md5String],kSignature_apiver,kSignature_key]md5String];
        [signatureDic setObject:signature forKey:@"signature"];
    }
    return signatureDic;
}

/**
 *  拼接服务器域名
 */
+ (NSString *)getEncryptURLWithRUL:(NSString *) url
{
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",RTServersURL,url];
    return requestURL;
}

/**
 *  GET 请求方式将参数拼接到 URL 上
 */
+ (NSString *)getURLWithRUL:(NSString *) url AndParamesers:(NSArray *)parameser
{
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",RTServersURL,url];
    NSMutableString *mutableStr = [NSMutableString stringWithString:requestURL];
    [parameser enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *param ;
        if ([obj isKindOfClass:[NSString class]]) {
            param = [NSString stringWithFormat:@"%@",obj];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            param = [NSString stringWithFormat:@"%ld",[obj longValue]];
        }
        [mutableStr appendFormat:@"/%@",param];
    }];
    [mutableStr substringToIndex: mutableStr.length -1];
    return mutableStr;
}

@end
