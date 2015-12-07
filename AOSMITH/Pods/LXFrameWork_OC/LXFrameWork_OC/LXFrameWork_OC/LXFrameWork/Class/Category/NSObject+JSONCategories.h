//
//  NSObject+JSONCategories.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/10.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSONCategories)

/**
 *  将NSArray或者NSDictionary转化为JsonData
 */
- (NSData*)JSONData;

/**
 *  将NSArray或者NSDictionary转化为JsonString
 */
- (NSString *)JSONString;

@end
