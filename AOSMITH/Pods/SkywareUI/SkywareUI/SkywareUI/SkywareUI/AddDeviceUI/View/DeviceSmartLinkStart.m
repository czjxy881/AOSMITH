//
//  DeviceSmartLinkStart.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "DeviceSmartLinkStart.h"
#import "DALabeledCircularProgressView.h"

@interface DeviceSmartLinkStart ()
{
    NSTimer *_timer;
    int progressTime;
}
/***  取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;


#define SCREEN_WIDTH      ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT     ([[UIScreen mainScreen] bounds].size.height)

@property (nonatomic,strong) DALabeledCircularProgressView *circleProgressView;

@end

@implementation DeviceSmartLinkStart

- (void)awakeFromNib
{
    [self beginAnimationImages];
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
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
    //进度条
    if (self.circleProgressView==nil) {
        self.circleProgressView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake(200.0f, 40.0f, 90.0f, 90.0f)];
        self.circleProgressView.roundedCorners = NO;
        CGPoint center = CGPointMake(SCREEN_WIDTH/2.0, 200-80);
        self.circleProgressView.center = center;
        SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
        self.circleProgressView.progressTintColor = UIM.Device_button_bgColor;
        self.circleProgressView.trackTintColor=[UIColor colorWithWhite:0.0 alpha:0.1];
        [self addSubview:self.circleProgressView];
        
    }
    [self initCircleProgressView];
}


-(void)initCircleProgressView
{
    progressTime = 0;
    [self.circleProgressView setProgress:0.0 animated:YES];
    self.circleProgressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.circleProgressView.progress];
    [self startTimer];
}

-(void)startTimer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
    }
}

-(void)updateProgressView
{
    progressTime++;
    CGFloat progress = progressTime/ 30.0 ;
    [self.circleProgressView setProgress:progress animated:YES];
    self.circleProgressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.circleProgressView.progress*100];
}

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
@end
