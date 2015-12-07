//
//  CustomQRCodeTool.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/11/3.
//  Copyright © 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomQRCodeTool : NSObject

/**
 *  根据字符串创建二维码
 *
 *  String： 字符串
 *  sizeWH： 大小宽高
 */
+ (UIImage *)createQRCodeFromString:(NSString *) string WithSize:(CGFloat)sizeWH;

@end
