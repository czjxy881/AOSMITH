//
//  PlistTool.h
//  LiXiao
//
//  Created by 李晓 on 15/7/2.
//  Copyright (c) 2015年 BookStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistTool : NSObject

/**
 *  获取plist 文件
 *
 *  @param name 文件名
 *  @param type 类型不传自动添加
 *
 *  @return 转换成的Array
 */
+ (NSArray *)loadPlistWithName:(NSString *) name AndType:(NSString *)type;


+ (NSArray *) loadTabBarCenterViewWithName:(NSString *) name;

@end
