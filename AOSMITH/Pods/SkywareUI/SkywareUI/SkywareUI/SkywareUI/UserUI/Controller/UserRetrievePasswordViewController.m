//
//  UserRetrievePasswordViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserRetrievePasswordViewController.h"

@interface UserRetrievePasswordViewController ()

/*** 手机号 */
@property (weak, nonatomic) IBOutlet UITextField *phone;
/*** 验证码 */
@property (weak, nonatomic) IBOutlet UITextField *code;
/*** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *password;
/*** 重复密码 */
@property (weak, nonatomic) IBOutlet UITextField *againPassword;

/*** 获取验证码 */
@property (weak, nonatomic) IBOutlet TimeButton *getCodeBtn;
/*** 发送验证码（暂时没用） */
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
/*** 确定按钮 */
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
/**
 *  找回密码
 */
@implementation UserRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置页面元素
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    self.getCodeBtn.defineColor = UIM.User_button_bgColor ==nil? UIM.All_button_bgColor :UIM.User_button_bgColor;
    [self.getCodeBtn setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor :UIM.User_button_bgColor];
    [self.confirmBtn setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor :UIM.User_button_bgColor];
    self.view.backgroundColor = UIM.User_view_bgColor == nil? UIM.All_view_bgColor :UIM.User_view_bgColor;
    
    [self setNavTitle:@"找回密码"];
}

- (IBAction)getCodeClick:(UIButton *)sender {
    if (!self.phone.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![self.phone.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式有误"];
        return;
    }
    
    [SVProgressHUD showWithStatus:kMessageUserGetCodeLoad];
    [MessageCodeTool getMessageCodeWithPhone:self.phone.text Zone:nil Success:^{
        [self.getCodeBtn startWithTimer:60];
        [SVProgressHUD dismiss];
    } Error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kMessageUserGetCodeError];
    }];
}

- (IBAction)sendCodeClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if(self.code.text.length!=4)
    {
        [SVProgressHUD showInfoWithStatus:kMessageUserWriteCode];
        return;
    }else{
        [self VerifyCode];
    }
}

- (IBAction)confirmClick:(UIButton *)sender {
    
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
    if (!self.phone.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![self.phone.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式有误"];
        return;
    }
    
    if(self.code.text.length!=4)
    {
        [SVProgressHUD showInfoWithStatus:kMessageUserWriteCode];
        return;
    }
    [SVProgressHUD showWithStatus:kMessageUserChangePassword];
    [SkywareUserManager UserVerifyLoginIdExistsWithLoginid:self.phone.text Success:^(SkywareResult *result) {
        [self VerifyCode];
    } failure:^(SkywareResult *result) { // 如果是200 说明已经存在可以找回密码
        [SVProgressHUD showErrorWithStatus:kMessageUserNotRegister];
    }];
}

- (void) changePassword
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.phone.text forKey:@"login_id"];
    [param setObject:self.password.text forKey:@"login_pwd"];
    [SVProgressHUD show];
    [SkywareUserManager UserRetrievePasswordWithParamesers:param Success:^(SkywareResult *result) {
        [SVProgressHUD showSuccessWithStatus:kMessageUserChangePasswordSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:kMessageUserChangePasswordError];
    }];
}

- (void) VerifyCode
{
    [MessageCodeTool commitVerifyCode:self.code.text Phone:self.phone.text Zone:nil Success:^{
        [self changePassword];
    } Error:^{
        [SVProgressHUD showErrorWithStatus:kMessageUserWriteCodeError];
    }];
}

@end
