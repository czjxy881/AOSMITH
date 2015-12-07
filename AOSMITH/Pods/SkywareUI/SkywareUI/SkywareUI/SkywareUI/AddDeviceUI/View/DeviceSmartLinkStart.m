//
//  DeviceSmartLinkStart.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceSmartLinkStart.h"

@interface DeviceSmartLinkStart ()
/***  ImageView */
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
/***  取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;

@end

@implementation DeviceSmartLinkStart

- (void)awakeFromNib
{
    [self beginAnimationImages];
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    self.backgroundColor = UIM.Device_view_bgColor == nil? UIM.All_view_bgColor :UIM.Device_view_bgColor;
    [self.cleanBtn setBackgroundColor:UIM.Device_button_bgColor == nil ? UIM.All_button_bgColor : UIM.Device_button_bgColor];
}

+ (instancetype)createDeviceSmartLinkStartView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AddDeviceViews" owner:nil options:nil][3];
}

- (IBAction)cleanBtnClick:(UIButton *)sender {
    if (self.option) {
        self.option();
    }
}

- (void) beginAnimationImages{
    if(self.centerImageView.isAnimating) return ;
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    self.centerImageView.animationImages = UIM.Device_smartLink_array;
    self.centerImageView.animationRepeatCount = MAXFLOAT;
    self.centerImageView.animationDuration = 4 * 0.6;
    [self.centerImageView startAnimating];
}

- (void)dealloc
{
    [self.centerImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.centerImageView.animationDuration];
}

@end
