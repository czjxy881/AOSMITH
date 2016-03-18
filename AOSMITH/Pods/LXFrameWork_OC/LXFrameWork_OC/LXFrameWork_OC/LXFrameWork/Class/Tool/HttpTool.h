//
//  HttpTool.h
//  LiXiao
//
//  Created by 李晓 on 15/7/2.
//  Copyright (c) 2015年 BookStore. All rights reserved.
//

#import <AFNetworking.h>

typedef enum {
    JSONResponseSerializer,
    XMLParserResponseSerializer,
    HTTPResponseSerializer
} serializer;

@interface HttpTool : NSObject

/**
 *  AFNetWorking 发送Get请求总方法
 *
 *  @param url        RUL
 *  @param parameser  参数
 *  @param timeout    超时时间
 *  @param header     请求头
 *  @param serializer 返回类型
 *  @param success    成功
 *  @param failure    失败
 */
+ (NSURLSessionDataTask *)HttpToolGetWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser timeoutInterval:(NSTimeInterval)timeout requestHeaderField:(NSDictionary *)header Serializer:(serializer)serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送GET请求
 */
+ (NSURLSessionDataTask *) HttpToolGetWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送GET请求,设置返回值类型
 */
+ (NSURLSessionDataTask *) HttpToolGetWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送GET请求,设置返回值类型,添加请求头
 */
+ (NSURLSessionDataTask *) HttpToolGetWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser requestHeaderField:(NSDictionary *) header Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;



/**
 *  AFNetWorking 发送Post请求总方法
 *
 *  @param url       URL
 *  @param parameser 参数
 *  @param timeout   超时时间
 *  @param header    请求头
 *  @param data      上传Data
 *  @param name      后台接收名称
 *  @param fileName  上传文件名称
 *  @param mainType  上传文件类型
 *  @param success   成功
 *  @param failure   失败
 */
+ (NSURLSessionDataTask *) HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser timeoutInterval:(NSTimeInterval)timeout requestHeaderField:(NSDictionary *)header Data:(NSData *) data Name:(NSString *)name FileName:(NSString *) fileName MainType:(NSString *)mainType Serializer:(serializer)serializer Success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  利用 AFNetWorking 发送POST请求
 */
+ (NSURLSessionDataTask *) HttpToolPostWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送POST请求,设置返回值类型
 */
+ (NSURLSessionDataTask *) HttpToolPostWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送POST请求,设置返回值类型,添加请求头
 */
+ (NSURLSessionDataTask *) HttpToolPostWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser requestHeaderField:(NSDictionary *) header Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;

/**
 *  可以上传数据
 *  利用 AFNetWorking 发送POST请求，
 */
+ (NSURLSessionDataTask *) HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser Data:(NSData *) data Name:(NSString *)name FileName:(NSString *) fileName MainType:(NSString *)mainType  Success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
/**
 *  可以上传数据
 *  利用 AFNetWorking 发送POST请求,添加请求头
 */
+ (NSURLSessionDataTask *) HttpToolPostWithUrl:(NSString *)url paramesers:(NSDictionary *)parameser requestHeaderField:(NSDictionary *) header Data:(NSData *) data Name:(NSString *)name FileName:(NSString *) fileName MainType:(NSString *)mainType  Success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;



/**
 *  AFNetWorking 发送PUT请求总方法
 *
 *  @param url        URL
 *  @param parameser  参数
 *  @param timeout    超时时间
 *  @param header     请求头
 *  @param serializer 返回类型
 *  @param success    成功
 *  @param failure    失败
 */
+ (NSURLSessionDataTask *) HttpToolPutWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser timeoutInterval:(NSTimeInterval)timeout requestHeaderField:(NSDictionary *)header Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送PUT请求
 */
+ (NSURLSessionDataTask *) HttpToolPutWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送PUT请求,设置返回值类型
 */
+ (NSURLSessionDataTask *) HttpToolPutWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送PUT请求,设置返回值类型,添加请求头
 */
+ (NSURLSessionDataTask *) HttpToolPutWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser requestHeaderField:(NSDictionary *) header Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;



/**
 *  AFNetWorking 发送Delete请求总方法
 *
 *  @param url        URL
 *  @param parameser  参数
 *  @param timeout    超时时间
 *  @param header     请求头
 *  @param serializer 返回类型
 *  @param success    成功
 *  @param failure    失败
 */
+ (NSURLSessionDataTask *) HttpToolDeleteWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser timeoutInterval:(NSTimeInterval)timeout requestHeaderField:(NSDictionary *)header Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送Delete请求
 */
+ (NSURLSessionDataTask *) HttpToolDeleteWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送Delete请求,设置返回值类型
 */
+ (NSURLSessionDataTask *) HttpToolDeleteWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;
/**
 *  利用 AFNetWorking 发送Delete请求,设置返回值类型,添加请求头
 */
+ (NSURLSessionDataTask *) HttpToolDeleteWithUrl:(NSString *) url paramesers:(NSDictionary *) parameser requestHeaderField:(NSDictionary *) header Serializer:(serializer) serializer Success:(void(^)(id json)) success failure:(void (^)(NSError *error)) failure;

@end
