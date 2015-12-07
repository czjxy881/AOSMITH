//
//  UserDefaultsTool.h
//  HangingFurnace
//
//  Created by 李晓 on 15/9/11.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsTool : NSObject

/**
 *  存储偏好设置
 *
 *  @param obj 要存储的对象
 *  @param key 所使用的Key
 */
+ (void) setUserDefaultsWith:(id) obj forKey:(NSString *) key;

/**
 *  取存储的偏好设置
 *
 *  @param key 所使用的Key
 *
 *  @return 取出存储的对象
 */
+ (id) getUserDefaultsForKey:(NSString *) key;

@end
