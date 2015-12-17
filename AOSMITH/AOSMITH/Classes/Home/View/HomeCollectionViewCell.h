//
//  HomeCollectionViewCell.h
//  HangingFurnace
//
//  Created by 李晓 on 15/9/6.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceDataModel.h"

@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)  SkywareDeviceInfoModel *skywareInfo;//设备信息
@property (nonatomic,strong)  DeviceDataModel *deviceData;//设备状态

/***  加热中 */
@property (weak, nonatomic) IBOutlet UILabel *hotUpLabel;
/***  开关机 Lable */
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;

@end
