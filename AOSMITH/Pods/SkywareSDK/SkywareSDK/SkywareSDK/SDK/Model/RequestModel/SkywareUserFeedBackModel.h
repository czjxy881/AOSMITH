//
//  SkywareUserFeedBackModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/17.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareUserFeedBackModel : NSObject

/**
 *  反馈标题
 */
@property (nonatomic,copy) NSString *title;
/**
 *  反馈内容
 */
@property (nonatomic,copy) NSString *content;
/**
 * APP ID
 */
@property (nonatomic,copy) NSString *app_id;
/**
 * APP 版本号
 */
@property (nonatomic,copy) NSString *app_version;
/**
 * 标识
 */
@property (nonatomic,assign) NSInteger category;

@end
