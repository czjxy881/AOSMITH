//
//  SystemDeviceTool.h
//  examination
//
//  Created by 李晓 on 15/9/15.
//  Copyright (c) 2015年 exam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemDeviceTool : NSObject

/**
 *  获取设备的UUID
 *
 *  @return 这个UUID 每一次获取都会改变。如果想要保证不改变，需要使用CHKeychain 存储起来
 *
 */
+ (NSString *) getUUID;

/**
 *  获取当前APP的版本
 *
 *  @return 版本号
 */
+ (NSString *) getApp_Version;

@end
