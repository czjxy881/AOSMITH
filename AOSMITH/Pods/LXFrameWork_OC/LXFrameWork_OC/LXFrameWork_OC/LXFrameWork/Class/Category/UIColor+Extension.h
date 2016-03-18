//
//  UIColor+Extension.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/11/17.
//  Copyright © 2015年 LXFrameWork. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HexColor(colorStr) [UIColor colorWithHexString:colorStr]

@interface UIColor (Extension)
/**
 *  根据 16 进制字符串生成颜色 例子：#2c5aa5
 *
 *  @param stringToConvert 16进制String
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  返回一些 16 进制的颜色
 *
 *  @return NAarray
 */
+ (NSArray *)someHexColors;


/**
 *  判断两个颜色是否相等
 */
+ (BOOL) isTheSameColor2:(UIColor*)color1 anotherColor:(UIColor*)color2;

@end
