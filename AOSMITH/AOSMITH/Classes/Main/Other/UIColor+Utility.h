//
//  UIColor+Utility.h
//  AirPurifier
//
//  Created by bluE on 14-9-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithARGB:(NSInteger)ARGBValue;
@end
