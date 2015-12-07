//
//  HomeCollectionViewCell.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/6.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()
{
    NSTimer *_timer;
    UILabel *_centerLabel;
    UILabel *_topLabel;
    UILabel *_bottomLabel;
    CGFloat progress;
}

/***  设备的名称 */
@property (weak, nonatomic) IBOutlet UILabel *deviceName;

//@property (nonatomic,strong) DeviceData *currentDeviceData;
@end

@implementation HomeCollectionViewCell

+ (void)load
{
    Method existing = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method new = class_getInstanceMethod(self, @selector(_autolayout_replacementLayoutSubviews));
    method_exchangeImplementations(existing, new);
}

#pragma mark - Method

@end
