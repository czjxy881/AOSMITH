//
//  SkywareSendCmdModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/14.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareSendCmdModel : NSObject

/**
 *  SN 号
 */
@property (nonatomic,copy) NSString *sn;
/**
 *  MAC 地址
 */
@property (nonatomic,copy) NSString *mac;
/**
 *  转发的指令
 */
@property (nonatomic,copy) NSString *commandv;

@end
