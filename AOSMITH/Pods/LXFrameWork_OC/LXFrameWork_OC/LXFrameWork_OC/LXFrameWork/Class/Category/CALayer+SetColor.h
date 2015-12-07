//
//  CALayer+SetColor.h
//  LiXiao
//
//  Created by 李晓 on 15/6/30.
//  Copyright (c) 2015年 BookStore. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (SetColor)

/**
 *  XIB 当中设置borderColor
 */
- (void)setBorderColorFromUIColor:(UIColor *)color;

@end
