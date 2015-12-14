//
//  SkywareOtherManager.m
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SkywareOtherManager.h"

@implementation SkywareOtherManager

+ (void)UserAddressWeatherParamesers:(SkywareWeatherModel *)model Success:(void (^)(SkywareResult *))success failure:(void (^)(SkywareResult *))failure
{
    [SkywareHttpTool HttpToolPostWithUrl:Address_wpm paramesers:model.mj_keyValues requestHeaderField:nil SuccessJson:^(id json) {
        [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
    } failure:^(NSError *error) {
        
    }];
}


@end
