//
//  CALayer+SetColor.m
//  LiXiao
//
//  Created by 李晓 on 15/6/30.
//  Copyright (c) 2015年 BookStore. All rights reserved.
//

#import "CALayer+SetColor.h"

@implementation CALayer (SetColor)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
