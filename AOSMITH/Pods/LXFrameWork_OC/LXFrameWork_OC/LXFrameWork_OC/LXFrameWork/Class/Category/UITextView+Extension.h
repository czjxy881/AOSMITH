//
//  UITextView+Extension.h
//  LiXIao
//
//  Created by 李晓 on 14-10-24.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)

/**
 *  textView 光标选中的位置插入属性文字
 *
 *  @param attributed 属性文字
 */
- (void) insertAttributedText:(NSAttributedString *) attributed;

/**
 *  textView 光标选中的位置插入属性文字，并可以改变所有文字的大小
 *
 *  @param attributed 属性文字
 */
- (void) insertAttributedText:(NSAttributedString *) attributed settingBlocks:(void(^)(NSMutableAttributedString * attribute)) settingBlock;

@end
