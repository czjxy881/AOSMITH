//
//  CustomModel.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/9.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "CustomModel.h"

@implementation CustomModel

MJCodingImplementation

+ (instancetype) createCustomModelWithOpenTime:(NSString *) openTime CloseTime:(NSString *)closeTime isOpen:(BOOL)isOpen
{
    CustomModel *custom = [[CustomModel alloc] init];
    custom.openTime = openTime;
    custom.closeTime = closeTime;
    custom.open = isOpen;
    return custom;
}

- (NSString *)openTime
{
    if (_openTime.length) {
        return _openTime;
    }else{
        return @"--:--";
    }
}

- (NSString *)closeTime
{
    if (_closeTime.length) {
        return _closeTime;
    }else{
        return @"--:--";
    }
}



@end
