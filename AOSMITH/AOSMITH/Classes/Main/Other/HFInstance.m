//
//  HFInstance.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/10.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HFInstance.h"

@implementation HFInstance
//LXSingletonM(HFInstance)

@synthesize defaultTem = _defaultTem;

- (NSInteger)defaultTem
{
    NSInteger t = [[UserDefaultsTool getUserDefaultsForKey:[self getNowDeviceStateKey]] integerValue];
    if (!t) {
        t =42;
    }
    return t;
}


- (void)setDefaultTem:(NSInteger)defaultTem
{
    _defaultTem = defaultTem;
    [UserDefaultsTool setUserDefaultsWith:@(defaultTem) forKey:[self getNowDeviceStateKey]];
    
}

- (NSString *) getNowDeviceStateKey
{
    NSString *key = nil;
    if (self.deviceFunState == heating_fun) { // 采暖
        if (self.heatingState == heating_radiator) { // 暖气片采暖
            if (self.heating_select_model == ceaseless_run) {
                key = @"ceaseless_run";
            }else if (self.heating_select_model == business_one){
                key = @"business_one";
            }else if (self.heating_select_model == business_two){
                key = @"business_two";
            }else if (self.heating_select_model == economy){
                key = @"economy";
            }else if (self.heating_select_model == custom){
                key = @"custom";
            }
        }else if (self.heatingState == heating_floor){ //地暖采暖
            if (self.heating_select_model == ceaseless_run) {
                key = @"ceaseless_run";
            }else if (self.heating_select_model == business_one){
                key = @"business_one";
            }else if (self.heating_select_model == business_two){
                key = @"business_two";
            }else if (self.heating_select_model == economy){
                key = @"economy";
            }else if (self.heating_select_model == custom){
                key = @"custom";
            }
        }
    }else if(self.deviceFunState == hotwater_fun){ // 热水
        if (self.hotwater_select_model == convention){ // 常规
            key = @"convention";
        }else if (self.hotwater_select_model == comfortable){ // 舒适
            key = @"comfortable";
        }
    }
    //    NSLog(@"%@",key);
    return key;
}

- (NSArray *)tRange
{
    NSInteger minValue = 0;
    NSInteger maxValue = 0;
    
    if (self.deviceFunState == heating_fun) { // 采暖
        if (self.heatingState == heating_radiator) { // 暖气片采暖
            minValue = [self.heating_radiator.firstObject integerValue];
            maxValue = [self.heating_radiator.lastObject integerValue];
        }else if (self.heatingState == heating_floor){ //地暖采暖
            minValue = [self.heating_floor.firstObject integerValue];
            maxValue = [self.heating_floor.lastObject integerValue];
        }
    }else if(self.deviceFunState == hotwater_fun){ // 热水
        if (self.hotwater_select_model == convention){ // 常规
            minValue = [self.hotwater_convention.firstObject integerValue];
            maxValue = [self.hotwater_convention.lastObject integerValue];
        }else if (self.hotwater_select_model == comfortable){ // 舒适
            minValue = [self.hotwater_comfortable.firstObject integerValue];
            maxValue = [self.hotwater_comfortable.lastObject integerValue];
        }
    }
    return @[@(minValue),@(maxValue)];
}

- (NSMutableArray *)heating_radiator
{
    if (!_heating_radiator) {
        _heating_radiator = [[NSMutableArray alloc] init];
        for (int i = 30; i <= 80; i++) {
            [_heating_radiator addObject:@(i)];
        }
    }
    return _heating_radiator;
}

- (NSMutableArray *)heating_floor
{
    if (!_heating_floor) {
        _heating_floor = [[NSMutableArray alloc] init];
        for (int i = 30; i <= 60; i++) {
            [_heating_floor addObject:@(i)];
        }
    }
    return _heating_floor;
}

- (NSMutableArray *)hotwater_convention
{
    if (!_hotwater_convention) {
        _hotwater_convention = [[NSMutableArray alloc] init];
        for (int i = 30; i <= 60; i++) {
            [_hotwater_convention addObject:@(i)];
        }
    }
    return _hotwater_convention;
}

- (NSMutableArray *)hotwater_comfortable
{
    if (!_hotwater_comfortable) {
        _hotwater_comfortable = [[NSMutableArray alloc] init];
        for (int i = 40; i <= 44; i++) {
            [_hotwater_comfortable addObject:@(i)];
        }
    }
    return _hotwater_comfortable;
}

- (NSArray *)deviceHeatingDateArray
{
    if (!_deviceHeatingDateArray) {
        _deviceHeatingDateArray = [NSMutableArray array];
        NSArray *array1 = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        NSArray *array2 = @[@"0",@"2",@"4",@"6",@"7",@"17",@"18",@"19",@"20",@"21",@"22"];
        NSArray *array3 = @[@"0",@"2",@"4",@"6",@"7",@"11",@"12",@"18",@"19",@"20",@"21"];
        NSArray *array4 = @[@"4",@"6",@"7",@"18",@"19",@"20",@"21"];
        [_deviceHeatingDateArray addObjectsFromArray:@[array1,array2,array3,array4]];
    }
    return _deviceHeatingDateArray;
}

- (NSArray *)deviceHeatingModelArray
{
    if (!_deviceHeatingModelArray) {
        _deviceHeatingModelArray = @[@"无定时模式",@"商务模式1",@"商务模式2",@"经济模式",@"自定义模式"];
    }
    return _deviceHeatingModelArray;
}

- (NSArray *)deviceHotwaterModelArray
{
    if (!_deviceHotwaterModelArray) {
        _deviceHotwaterModelArray = @[@"常规模式",@"舒适模式"];
    }
    return _deviceHotwaterModelArray;
}

@end
