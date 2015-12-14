//
//  HttpTool.m
//  LiXiao
//
//  Created by 李晓 on 15/7/2.
//  Copyright (c) 2015年 BookStore. All rights reserved.
//

#import "HttpTool.h"
#import "HttpToolLogModel.h"
#import "NSDate+Extension.h"
#import "NSString+Extension.h"
#import "NSObject+JSONCategories.h"

@implementation HttpTool

//+ (void) requestSuccessUrl:(NSString *) url WithRequestData:(NSDictionary *)requestData AndresponseData:(id)responseObject
//{
//    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//    HttpToolLogModel *httplog = [[HttpToolLogModel alloc] init];
//    httplog.request_time = [[NSDate new]FormatterYMDHMS];
//    httplog.request_dict  = requestData;
//    httplog.request_URL = url;
//    httplog.isSuccess = YES;
//    httplog.result_dict = responseDict;
//    [HttpToolLogModel addHttpToolLog:httplog];
//}
//
//+ (void) requestFailureUrl:(NSString *) url WithRequestData:(NSDictionary *)requestData AndresponseData:(NSError *)failure
//{
//    HttpToolLogModel *httplog = [[HttpToolLogModel alloc] init];
//    httplog.request_time = [[NSDate new]FormatterYMDHMS];
//    httplog.request_dict = requestData;
//    httplog.request_URL = url;
//    httplog.isSuccess = NO;
//    httplog.result_dict = failure.userInfo;
//    [HttpToolLogModel addHttpToolLog:httplog];
//}

/** ---------------------------AFNetWorking GET 方法------------------------------- **/
+ (void)HttpToolGetWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser timeoutInterval:(NSTimeInterval)timeout requestHeaderField:(NSDictionary *)header Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (timeout) {
        manager.requestSerializer.timeoutInterval = timeout;
    }
    AFHTTPResponseSerializer *ser = [AFHTTPResponseSerializer serializer];
    
    if (serializer == JSONResponseSerializer) {
        ser = [AFJSONResponseSerializer serializer];
    }else if (serializer == XMLParserResponseSerializer){
        ser = [AFXMLParserResponseSerializer serializer];
    }
    manager.responseSerializer = ser;
    
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    [manager GET:url parameters:parameser progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)HttpToolGetWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolGetWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:nil Serializer:HTTPResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolGetWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolGetWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:nil Serializer:serializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolGetWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *)header Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolGetWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:header Serializer:serializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** ---------------------------AFNetWorking POST 方法------------------------------- **/

+(void)HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser timeoutInterval:(NSTimeInterval)timeout requestHeaderField:(NSDictionary *)header Data:(NSData *)data Name:(NSString *)name FileName:(NSString *)fileName MainType:(NSString *)mainType Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (timeout) {
        manager.requestSerializer.timeoutInterval = timeout;
    }
    AFHTTPResponseSerializer *ser = [AFHTTPResponseSerializer serializer];
    
    if (serializer == JSONResponseSerializer) {
        ser = [AFJSONResponseSerializer serializer];
    }else if (serializer == XMLParserResponseSerializer){
        ser = [AFXMLParserResponseSerializer serializer];
    }
    manager.responseSerializer = ser;
    
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    if (data) {
        
        [manager POST:url parameters:parameser constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mainType];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }else{
        [manager POST:url parameters:parameser progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

+ (void)HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPostWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:nil Data:nil Name:nil FileName:nil MainType:nil Serializer:HTTPResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



+ (void)HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPostWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:nil Data:nil Name:nil FileName:nil MainType:nil Serializer:serializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *)header Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPostWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:header Data:nil Name:nil FileName:nil MainType:nil Serializer:serializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Data:(NSData *)data Name:(NSString *)name FileName:(NSString *)fileName MainType:(NSString *)mainType Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPostWithUrl:url paramesers:parameser timeoutInterval:60 requestHeaderField:nil Data:data Name:name FileName:fileName MainType:mainType Serializer:JSONResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *)header Data:(NSData *)data Name:(NSString *)name FileName:(NSString *)fileName MainType:(NSString *)mainType Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPostWithUrl:url paramesers:parameser timeoutInterval:60 requestHeaderField:header Data:data Name:name FileName:fileName MainType:mainType Serializer:JSONResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** ---------------------------AFNetWorking PUT 方法------------------------------- **/

+(void)HttpToolPutWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser timeoutInterval:(NSTimeInterval)timeout requestHeaderField:(NSDictionary *)header Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (timeout) {
        manager.requestSerializer.timeoutInterval = timeout;
    }
    
    AFHTTPResponseSerializer *ser = [AFHTTPResponseSerializer serializer];
    if (serializer == JSONResponseSerializer) {
        ser = [AFJSONResponseSerializer serializer];
    }else if (serializer == XMLParserResponseSerializer){
        ser = [AFXMLParserResponseSerializer serializer];
    }
    manager.responseSerializer = ser;
    
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forKey:key];
        }];
    }
    
    [manager PUT:url parameters:parameser success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolPutWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPutWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:nil Serializer:HTTPResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)HttpToolPutWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPutWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:nil Serializer:serializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolPutWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *)header Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolPutWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:header Serializer:serializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** ---------------------------AFNetWorking DELETE 方法------------------------------- **/

+ (void)HttpToolDeleteWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser timeoutInterval:(NSTimeInterval)timeout requestHeaderField:(NSDictionary *)header Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (timeout) {
        manager.requestSerializer.timeoutInterval = timeout;
    }
    
    AFHTTPResponseSerializer *ser = [AFHTTPResponseSerializer serializer];
    if (serializer == JSONResponseSerializer) {
        ser = [AFJSONResponseSerializer serializer];
    }else if (serializer == XMLParserResponseSerializer){
        ser = [AFXMLParserResponseSerializer serializer];
    }
    manager.responseSerializer = ser;
    
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    [manager DELETE:url parameters:parameser success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)HttpToolDeleteWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolDeleteWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:nil Serializer:HTTPResponseSerializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolDeleteWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolDeleteWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:nil Serializer:serializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)HttpToolDeleteWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *)header Serializer:(serializer)serializer Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HttpTool HttpToolDeleteWithUrl:url paramesers:parameser timeoutInterval:30 requestHeaderField:header Serializer:serializer Success:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
