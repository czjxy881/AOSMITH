//
//  NSString+Extension.h
//  LiXiao
//
//  Created by 李晓 on 14-10-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)
/**
 *  根据传入的字体计算所占大小
 *
 */
- (CGSize) sizeWithFont:(UIFont *) font;
/**
 *  根据传入的字体计算所占大小
 *  width : 传入最大宽度计算出高度
 */
- (CGSize) sizeWithFont:(UIFont *)font Width:(CGFloat) width;
/**
 *  对 url 进行编码
 *
 */
- (NSString *)encodeToPercentEscapeString;
/**
 *  对 url 进行解码
 *
 */
- (NSString *)decodeFromPercentEscapeString;
/**
 *  获取设备沙盒路径
 */
+ (NSString *)getApplicationDocumentsDirectory;
/**
 *  删掉字符串前边多余的 "0"
 */
- (NSString *) removeStringFrontZero;

/**
 *  将NSString 转化为NSData 二进制
 */
- (NSData *) stringHexToBytes;

/**
 *  将 年月日时分秒时间转换为 仅年月日的时间
 */
- (NSString *)FormatterYYYYMMDD;

/**
 *  将 String 类型转化位 Date 类型 YYYY-MM-DD  HH:mm:ss
 */
- (NSDate *) FormatterDateFromYMDHMS;

/**
 *  将 String 类型转化位 Date 类型 YYYY-MM-DD
 */
- (NSDate *) FormatterDateFromYMD;
/**
 *  将 String 类型进行 Base64 编码
 *
 *  @param input 编码前 String
 *
 *  @return 编码后 String
 */
+ (NSString*)encodeBase64String:(NSString *)input;

/**
 *  将 String 类型进行 Base64 解码
 *
 *  @param input 解码前 String
 *
 *  @return 解码后 String
 */
+ (NSString*)decodeBase64String:(NSString *)input;

/**
 *  将 Data 类型进行 Base64 编码
 *
 *  @param input 编码前 String
 *
 *  @return 编码后 String
 */
+ (NSString*)encodeBase64Data:(NSData *)data;

/**
 *  将 Data 类型进行 Base64 解码
 *
 *  @param input 解码前 String
 *
 *  @return 解码后 String
 */
+ (NSString*)decodeBase64Data:(NSData *)data;
@end
