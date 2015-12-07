//
//  UserAddressModel.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/27.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserAddressModel.h"

@implementation UserAddressModel

- (NSString *) City
{
    NSRange range = [_City rangeOfString:@"市"];
    if (range.location != NSNotFound) {
        if (_City.length > range.location) {
            return [_City substringToIndex:range.location +1];
        }
    }
    return _City;
}

@end
