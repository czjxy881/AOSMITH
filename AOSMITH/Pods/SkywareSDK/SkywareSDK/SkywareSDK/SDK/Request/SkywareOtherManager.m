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

+ (void) UserSendLogParamesers:(NSDictionary *) params Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure
{
    
    if ([SkywareSDKManager sharedSkywareSDKManager].token.length > 0 ) {
        [SkywareHttpTool HttpToolPostWithUrl:LogEvent paramesers:params requestHeaderField:@{@"token":[SkywareSDKManager sharedSkywareSDKManager].token} SuccessJson:^(id json) {
            [SkywareHttpTool responseHttpToolWithJson:json Success:success failure:failure];
        } failure:^(NSError *error) {
            
        }];
    }
}

@end
