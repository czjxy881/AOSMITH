//
//  HomeTopStateView.h
//  HangingFurnace
//
//  Created by 李晓 on 15/9/14.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HomeTopStateView : UIView

/**
 *  地点 温度
 */
@property (nonatomic,weak)IBOutlet UILabel *cityState;
/**
 *  天气风速风向
 */
@property (nonatomic,weak)IBOutlet UILabel *wind;
/**
 *  风扇
 */
@property (nonatomic,weak)IBOutlet UIImageView *flabellum;
/**
 *  定时
 */
@property (nonatomic,weak)IBOutlet UIImageView *timing;
/**
 *  冬季模式
 */
@property (nonatomic,weak)IBOutlet UIImageView *snowflake;
/**
 *  设置
 */
@property (nonatomic,weak)IBOutlet UIImageView *setting;
/**
 *  火焰
 */
@property (nonatomic,weak)IBOutlet UIImageView *fire;




@end
