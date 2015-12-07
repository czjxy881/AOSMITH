//
//  TimeButton.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/15.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "TimeButton.h"

@interface TimeButton ()
{
    dispatch_source_t _timer;
}
@end

@implementation TimeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    return self;
}

- (void)startWithTimer:(NSInteger)time
{
    [self setBackgroundColor:[UIColor lightGrayColor]];
    self.enabled = NO;
    
    __block NSInteger timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                [self setBackgroundColor:self.defineColor];
                [self setTitle: @"重新获取"forState:UIControlStateNormal];
            });
        }else{
            NSInteger seconds = timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle: [NSString stringWithFormat:@"%ld秒后重试",seconds] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void) endTimed
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        self.enabled = YES;
        [self setBackgroundColor:self.defineColor];
        [self setTitle: @"重新获取"forState:UIControlStateNormal];
    }
}

@end
