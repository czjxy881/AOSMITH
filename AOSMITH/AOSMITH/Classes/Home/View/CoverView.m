//
//  CoverView.m
//  AOSMITH
//
//  Created by ybyao07 on 16/1/15.
//  Copyright © 2016年 aosmith. All rights reserved.
//

#import "CoverView.h"

@implementation CoverView

//添加蒙版
+(void)addCoverViewWithHeight:(CGFloat)height
{
    //显示 您还木有绑定新风机,点击“+”来绑定 或者设备掉线
    UIView *coverTransparentView = [UIView newAutoLayoutView];
    coverTransparentView.tag = 10001;
    coverTransparentView.backgroundColor = [UIColor colorWithHexString:@"#001b38"];
    coverTransparentView.alpha = 0.6;
    [[UIWindow getCurrentWindow] addSubview:coverTransparentView];
    
    [coverTransparentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(74+height, 0, 55, 0)];
    
}
+(void)addCoverErrorViewWithHeight:(CGFloat)height
{
    UIView *coverTransparentView = [UIView newAutoLayoutView];
    coverTransparentView.tag = 10002;
    coverTransparentView.backgroundColor = [UIColor colorWithHexString:@"#001b38"];
    coverTransparentView.alpha = 0.6;
    [[UIWindow getCurrentWindow] addSubview:coverTransparentView];
    [coverTransparentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(74+height, 0, 0, 0)];
}

+(void)removeCoverView
{
    UIView *bgView = [UIWindow getCurrentWindow];
    for (UIView *view in [bgView subviews]) {
        if (view.tag == 10001) {
            [view removeFromSuperview];
        }if (view.tag == 10002) {
            [view removeFromSuperview];
        }
    }
}





@end
