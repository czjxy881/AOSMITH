//
//  UIColor+Utility.m
//  AirPurifier
//
//  Created by bluE on 14-9-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
						   green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
							blue:((float)(hexValue & 0xFF))/255.0
						   alpha:alpha];
}

+ (UIColor *)colorWithARGB:(NSInteger)ARGBValue
{
	return [UIColor colorWithRed:((float)((ARGBValue & 0xFF0000) >> 16)) / 255.0
						   green:((float)((ARGBValue & 0xFF00) >> 8)) / 255.0
							blue:((float)(ARGBValue & 0xFF))/255.0
						   alpha:((float)((ARGBValue & 0xFF000000) >> 24)) / 255.0];
}


@end
