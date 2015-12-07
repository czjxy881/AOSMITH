//
//  DeviceResetView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceResetView.h"

@interface DeviceResetView()

/***  闪动的图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/***  否按钮 */
@property (weak, nonatomic) IBOutlet UIButton *NOBtn;
/***  是按钮 */
@property (weak, nonatomic) IBOutlet UIButton *YESBtn;

/***  标题 */
@property (weak, nonatomic) IBOutlet UILabel *rest_title;
/***  内容 */
@property (weak, nonatomic) IBOutlet UITextView *rest_content;

@end

@implementation DeviceResetView

- (void)awakeFromNib
{
    [self beginAnimationImages];
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    [self.NOBtn setBackgroundColor:UIM.Device_button_bgColor == nil ? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    [self.YESBtn setBackgroundColor:UIM.Device_button_bgColor == nil ? UIM.All_button_bgColor : UIM.Device_button_bgColor];
    self.backgroundColor = UIM.Device_view_bgColor == nil? UIM.All_view_bgColor :UIM.Device_view_bgColor;
    if (UIM.Device_resetTitle.length) {
        self.rest_title.text = UIM.Device_resetTitle;
    }
    if (UIM.Device_resetContent.length) {
        self.rest_content.text = UIM.Device_resetContent;
    }
}

+ (instancetype)createDeviceResetView
{
    return [[NSBundle mainBundle] loadNibNamed:@"AddDeviceViews" owner:nil options:nil][2];
}

- (IBAction)notBtnClick:(UIButton *)sender {
    if (self.otherOption) {
        self.otherOption(nil);
    }
}

- (IBAction)yesBtnClick:(UIButton *)sender {
    if (self.option) {
        self.option();
    }
}

- (void) beginAnimationImages
{
    if(self.imageView.isAnimating) return ;
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    self.imageView.animationImages = UIM.Device_bickerArray;
    self.imageView.animationRepeatCount = MAXFLOAT;
    self.imageView.animationDuration = 0.3;
    [self.imageView startAnimating];
    
}

-(void)dealloc
{
    [self.imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.imageView.animationDuration];
}


@end
