//
//  SkywareSDKManager.m
//  SkywareSDK
//
//  Created by 李晓 on 15/12/1.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "SkywareSDKManager.h"
#import <UserDefaultsTool.h>
#import "SkywareConst.h"

@implementation SkywareSDKManager

LXSingletonM(SkywareSDKManager)

static NSArray *service_type_array ;

+ (void)initialize
{
    // 开发（0,1） 测试（2,3） 正式（4，5）
    service_type_array = @[@"v1", @"c1", @"v2", @"c3", @"v3", @"c2"];
}

- (void)PostApplicationDidBecomeActive
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidBecomeActive object:nil];
}

- (NSString *)service
{
    // 先从本地加载设置值，
    NSString *type =  [UserDefaultsTool getUserDefaultsForKey:@"service_type"];
    if (type == nil || type.length == 0) {
        return service_type_array[self.service_type];
    }else{
        return [service_type_array objectAtIndex:[type integerValue]];
    }
}

- (void)changeCurrentDeviceWithMac:(NSString *)mac
{
    SkywareDeviceInfoModel *model = [self.bind_Devices_Dict objectForKey:mac];
    if (model) {
        self.currentDevice = model;
    }
}

#pragma mark - 懒加载 -

- (NSMutableArray *)bind_Devices_Array
{
    if (!_bind_Devices_Array) {
        _bind_Devices_Array = [[NSMutableArray alloc] init];
    }
    return _bind_Devices_Array;
}

- (NSMutableDictionary *)bind_Devices_Dict
{
    if (!_bind_Devices_Dict) {
        _bind_Devices_Dict = [[NSMutableDictionary alloc] init];
    }
    return _bind_Devices_Dict;
}

@end
