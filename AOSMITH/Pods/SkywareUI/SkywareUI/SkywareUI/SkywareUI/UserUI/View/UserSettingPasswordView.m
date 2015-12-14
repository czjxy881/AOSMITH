//
//  UserSettingPasswordView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserSettingPasswordView.h"
#import <BaseDelegate.h>
#define Delegate  ((BaseDelegate *)[UIApplication sharedApplication].delegate)

@interface UserSettingPasswordView ()
/*** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *password;
/*** 重复密码 */
@property (weak, nonatomic) IBOutlet UITextField *againPassword;
/*** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation UserSettingPasswordView

- (void)awakeFromNib
{
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    [self.registerBtn setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor : UIM.User_button_bgColor];
    self.backgroundColor = UIM.User_view_bgColor == nil ? UIM.All_view_bgColor :UIM.User_view_bgColor;
}

+ (instancetype)getUserSettingPasswordView
{
    return [[NSBundle mainBundle]loadNibNamed:@"UserManager" owner:nil options:nil][2];
}

- (IBAction)registerUserClick:(UIButton *)sender {
    NSString *phone = self.params[@"phone"];
    if (self.password.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"密码长度至少6位"];
        return;
    }
    
    if (self.againPassword.text.length > 16) {
        [SVProgressHUD showInfoWithStatus:@"密码长度不能超过16位"];
        return;
    }
    
    if (![self.password.text isEqualToString:self.againPassword.text]) {
        [SVProgressHUD showInfoWithStatus:@"两次输入的密码不一致"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:phone forKey:@"login_id"];
    [dict setObject:self.password.text forKey:@"login_pwd"];
    [SVProgressHUD show];
    [SkywareUserManager UserRegisterWithParamesers:dict Success:^(SkywareResult *result) {
        [SVProgressHUD showSuccessWithStatus:kMessageUserRegisterSuccess];
        [Delegate.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力,请稍后重试"];
    }];
}

@end
