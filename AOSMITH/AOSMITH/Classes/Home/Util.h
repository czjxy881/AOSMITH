//
//  Util.h
//  AirPurifier
//
//  Created by bluE on 15-1-19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

//禁止输入表情符号
//+ (NSString *)disable_emoji:(NSString *)text;

/**
 *  分享
 *
 *  @param view 需要展示分享的UIView 和内容
 */
+(void)shareAllButtonClickHandler:(UIView *)view withContent:(NSString *)content;

@end
