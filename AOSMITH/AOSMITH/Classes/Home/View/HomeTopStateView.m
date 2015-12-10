//
//  HomeTopStateView.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/14.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "HomeTopStateView.h"

@interface HomeTopStateView()
{
    CoreLocationTool *locationTool;
}
@end

@implementation HomeTopStateView

-(void)awakeFromNib
{
    // 获取用户所在地的天气情况
    locationTool = [[CoreLocationTool alloc] init];
    [locationTool getLocation:^(CLLocation *location) {
        [locationTool reverseGeocodeLocation:location userAddress:^(UserAddressModel *userAddress) {
            SkywareWeatherModel *model = [[SkywareWeatherModel alloc] init];
            model.province = userAddress.State;
            model.city = userAddress.City;
            model.district = userAddress.SubLocality;
            [SkywareOtherManager UserAddressWeatherParamesers:model Success:^(SkywareResult *result) {
                SkywareAddressWeatherModel *weath = [SkywareAddressWeatherModel mj_objectWithKeyValues:result.result];
                self.wind.text = [NSString stringWithFormat:@"%@%@",weath.wind_direct,weath.wind_power];
                self.cityState.text = [NSString stringWithFormat:@"%@ %@",weath.area_name,weath.temperature];
            } failure:^(SkywareResult *result) {
                NSLog(@"%@",result);
            }];
        }];
    }];
}



@end
