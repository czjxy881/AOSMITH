//
//  UserGetCodeView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserGetCodeView.h"
#import <NSString+RegularExpression.h>
#import "MessageCodeTool.h"

@implementation UserGetCodeView

- (void)awakeFromNib
{
    SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
    [self.getCodeBtn setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor : UIM.User_button_bgColor];
    self.backgroundColor = UIM.User_view_bgColor == nil? UIM.All_view_bgColor : UIM.User_view_bgColor;
}

+ (instancetype)getUserCodeView
{
    return [[NSBundle mainBundle]loadNibNamed:@"UserManager" owner:nil options:nil][0];
}

- (IBAction)GetCodeClick:(UIButton *)sender {
    [self endEditing:YES];
    if (!self.phoneText.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([self.phoneText.text isPhoneNumber]) {
        [SVProgressHUD show];
        [SkywareUserManager UserVerifyLoginIdExistsWithLoginid:self.phoneText.text Success:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:kMessageUserAlreadyRegister];
        } failure:^(SkywareResult *result) {
            [self getCode];
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请输入正确手机号"];
    }
}

- (void) getCode
{
    [SVProgressHUD showWithStatus:kMessageUserGetCodeLoad];
    [MessageCodeTool getMessageCodeWithPhone:self.phoneText.text Zone:nil Success:^{
        [SVProgressHUD dismiss];
        if (self.option) {
            self.option();
        }
    } Error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kMessageUserGetCodeError];
    }];
}

@end
