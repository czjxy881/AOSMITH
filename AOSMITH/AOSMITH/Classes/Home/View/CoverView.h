//
//  CoverView.h
//  AOSMITH
//
//  Created by ybyao07 on 16/1/15.
//  Copyright © 2016年 aosmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoverView : NSObject
/**
 *  添加蒙版
 */
+(void)addCoverViewWithHeight:(CGFloat)height;

/**
 *  添加故障报警蒙版
 *
 *  @param height <#height description#>
 */
+(void)addCoverErrorViewWithHeight:(CGFloat)height;
/**
 *  移除蒙版
 */
+(void)removeCoverView;
@end
