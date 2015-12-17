//
//  CustomModel.h
//  HangingFurnace
//
//  Created by 李晓 on 15/9/9.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomModel : NSObject

/***  开启时间 */
@property (nonatomic,copy) NSString *openTime;
/***  关闭时间 */
@property (nonatomic,copy) NSString *closeTime;

/***  是否开启 */
@property (nonatomic,assign,getter = isOpenTime) BOOL open;
@property (nonatomic,assign,getter = isCloseTIme) BOOL close;


+ (instancetype) createCustomModelWithOpenTime:(NSString *) openTime CloseTime:(NSString *)closeTime isOpen:(BOOL)isOpen;


@end
