//
//  DeviceBindSucceedView.h
//  Pods
//
//  Created by ybyao07 on 16/1/20.
//
//

#import <UIKit/UIKit.h>
#import "StepNextView.h"
#import "SkywareDeviceInfoModel.h"

typedef void(^ShareOption)();

@interface DeviceBindSucceedView : StepNextView

+ (instancetype)createBindSucceedView;

@property (nonatomic,strong) SkywareDeviceInfoModel *deviceInfo;

@property (nonatomic,copy) ShareOption shareOption;


@end
