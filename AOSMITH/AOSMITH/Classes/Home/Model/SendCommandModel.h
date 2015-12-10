//
//  SendCommandModel.h
//  AOSMITH
//
//  Created by 李晓 on 15/12/9.
//  Copyright © 2015年 aosmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendCommandModel : NSObject

/**
 *  是否开机
 */
@property (nonatomic,assign) BOOL power;
/**
 *  温度设置
 */
@property (nonatomic,assign) NSInteger settingTemp;
/**
 *  档位
 */
@property (nonatomic,assign) level_type level;
/**
 * 开机时间
 */
@property (nonatomic,copy) NSString *openTime;
/**
 * 关机时间
 */
@property (nonatomic,copy) NSString *closeTime;
/**
 *  时间校准
 */
@property (nonatomic,copy) NSString *deviceTime;

@end
