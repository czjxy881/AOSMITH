//
//  UIColor+Extension.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/11/17.
//  Copyright © 2015年 LXFrameWork. All rights reserved.
//

#import "UIColor+Extension.h"
static NSArray *colorHexs ;

@implementation UIColor (Extension)

+ (void)initialize
{
    colorHexs = @[@"#2c5aa5", @"#50bcbe", @"#f4ad6b", @"#f486a3", @"#ceb559", @"#32b5d1", @"#bb221c", @"#f8e63a", @"#a3bd42", @"#8bc684", @"#3fa65d", @"#758cc2", @"#38327a", @"#732163", @"#6b1a23", @"#f09c9c", @"#ec1364", @"#fc5204", @"#a36452", @"#e98e3d", @"#698aab", @"#94859c", @"#efefef", @"#bce1e7", @"#d2cfd8", @"#afb9a7"];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor colorWithRed:0 green:200/255.0 blue:171/255.0 alpha:1.0];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor colorWithRed:0 green:200/255.0 blue:171/255.0 alpha:1.0];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

+ (NSArray *)someHexColors {
    
    return colorHexs;
}

@end
