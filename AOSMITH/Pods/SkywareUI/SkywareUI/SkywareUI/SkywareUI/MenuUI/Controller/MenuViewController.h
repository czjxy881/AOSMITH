//
//  MenuViewController.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "BaseCellTableViewController.h"
#import "SystemAboutViewController.h"
#import "SystemFeedBackViewController.h"
#import "UserAccountViewController.h"
#import "DeviceManagerViewController.h"
#import "SystemFeedBackViewController.h"
#import "AddDeviceViewController.h"
#import "SkywareUIConst.h"

@interface MenuViewController : BaseCellTableViewController

/**
 *  您可以通过扫描或输入机身编码绑定新的设备
 */
@property (nonatomic,strong) UILabel *groupHeadTitle;

/**
 *  用户信息cell，网络请求
 */
- (void) addUserInfoManagerGroup;
/**
 *  设备管理
 */
- (void) addDeviceManagerGroup;
/**
 *  添加设备
 */
- (void) addDeviceGroup;
/**
 *  添加问题反馈
 */
- (void)SystemFeedBack;

@end
