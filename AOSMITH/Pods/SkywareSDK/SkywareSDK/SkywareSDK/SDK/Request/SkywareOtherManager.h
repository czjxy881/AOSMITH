//
//  SkywareOtherManager.h
//  SkywareSDK
//
//  Created by 李晓 on 15/12/3.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkywareHttpTool.h"

@interface SkywareOtherManager : NSObject

/**
 *             天气接口
 *
 *   SkywareWeatherModel *model = [[SkywareWeatherModel alloc] init];
 *   model.province = @"河北省";
 *   model.city = @"沧州市";
 *   model.district = @"吴桥县";
 *  [SkywareOthersManager UserAddressWeatherParamesers:model Success:^(SkywareResult *result) {
 *       SkywareAddressWeatherModel *addressModel = [SkywareAddressWeatherModel objectWithKeyValues:result.result];
 *       NSLog(@"%@",addressModel);
 *     } failure:^(SkywareResult *result) {
 *        NSLog(@"%@",result);
 *   }];
 */
+ (void) UserAddressWeatherParamesers:(SkywareWeatherModel *) model Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

@end
