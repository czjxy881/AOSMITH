//
//  CoreLocationTool.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/26.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "CoreLocationTool.h"

@interface CoreLocationTool ()<CLLocationManagerDelegate>
/**
 *   定位的Manager
 */
@property (nonatomic ,strong) CLLocationManager *mgr;
/**
 *  地理编码对象
 */
@property (nonatomic,strong) CLGeocoder *code;

@end

@implementation CoreLocationTool

- (void)getLocation:(locationOption)option
{
    self.option = option;
    self.mgr.delegate = self;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.mgr requestAlwaysAuthorization];
    }else{
        [self.mgr startUpdatingLocation];
    }
}

/**
 *  地理编码
 */

- (void)geocodeAddressString:(NSString *)addressString userAddress:(void (^)(CLPlacemark *))placemark
{
    [self.code geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pacemark = [placemarks firstObject];
        if (placemark) {
            placemark(pacemark);
        }
    }];
}

/**
 *  反地理编码
 */
- (void)reverseGeocodeLocation:(CLLocation *)location userAddress:(void (^)(UserAddressModel *))userAddress
{
    [self.code reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pacemark = [placemarks firstObject];
        UserAddressModel *address = [UserAddressModel mj_objectWithKeyValues:pacemark.addressDictionary];
        if (userAddress) {
            userAddress(address);
        }
    }];
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways){
        [self.mgr startUpdatingLocation];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"定位信息授权失败，将无法获取您所在地的天气情况，请前往设置开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.mgr stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    self.option(location);
    [self.mgr stopUpdatingLocation];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark - 懒加载
- (CLLocationManager *)mgr
{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
        _mgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    return _mgr;
}

- (CLGeocoder *)code
{
    if (!_code) {
        _code = [[CLGeocoder alloc] init];
    }
    return _code;
}

@end
