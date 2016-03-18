//
//  LANDeviceModel.m
//  SkywareSDK
//
//  Created by 李晓 on 16/1/13.
//  Copyright © 2016年 skyware. All rights reserved.
//

#import "LANDeviceModel.h"

@implementation LANDeviceModel

- (instancetype)initWithArray:(NSArray *)array
{
    [array enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
            {
                self.IP = string;
            }
                break;
            case 1:
            {
                self.MAC = string;
            }
                break;
            case 2:
            {
                self.device_code = string;
            }
                break;
            default:
                break;
        }
    }];
    return self;
}

@end
