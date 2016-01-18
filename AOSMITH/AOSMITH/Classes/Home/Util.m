//
//  Util.m
//  AirPurifier
//
//  Created by bluE on 15-1-19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "Util.h"
#import <Social/Social.h>
#import <ShareSDK/ShareSDK.h>
#import "SVProgressHUD.h"

@implementation Util

+(void)shareAllButtonClickHandler:(UIView *)view withContent:(NSString *)content;
{
    //创建弹出菜单容器
    UIImage *image = [UIImage imageNamed:@"icon"];
    id<ISSCAttachment> _shareImage =   [ShareSDK pngImageWithImage:image];
    id<ISSContainer> container = [ShareSDK container];
    NSString *title  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:title
                                                image:_shareImage
                                                title:title
                                                  url:kDownloadLink
                                          description:title
                                            mediaType:SSPublishContentMediaTypeNews];
//    [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@%@",SHARE_CONTENT,kDownloadLink] image:_shareImage locationCoordinate:nil];
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                        message:nil
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"确定"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //                                    NSString *errorInfo = [error errorDescription];
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
}





@end
