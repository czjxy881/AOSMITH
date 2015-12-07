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
 *  天气接口
 */
+ (void) UserAddressWeatherParamesers:(SkywareWeatherModel *) model Success:(void(^)(SkywareResult *result)) success failure:(void (^)(SkywareResult *result)) failure;

@end
