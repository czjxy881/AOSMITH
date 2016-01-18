//
//  UserLoginViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserLoginViewController.h"
#import "BaseNetworkTool.h"

@interface UserLoginViewController ()<UIAlertViewDelegate>
/*** 登录名 */
@property (weak, nonatomic) IBOutlet UITextField *phone;
/*** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *password;
/*** 登录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
/*** 登录页面Logo */
@property (weak, nonatomic) IBOutlet UIImageView *loginLogo;

@end

/**
 *  用户登录
 */
@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.hidden = YES;
    
    // 设置页面元素
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    [_loginBtn setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor : UIM.User_button_bgColor];
    _loginLogo.image = UIM.User_loginView_logo;
    self.view.backgroundColor = UIM.User_view_bgColor == nil? UIM.All_view_bgColor :UIM.User_view_bgColor;
    
    // 页面加载完成后清空输入框
    self.phone.text = @"";
    self.password.text = @"";
    
    // 自动登录
    SkywareResult *result = [NSKeyedUnarchiver unarchiveObjectWithFile:[PathTool getUserDataPath]];
    if (result.phone.length && result.password.length) { // 保存有用户名密码，跳转到首页
        self.phone.text = result.phone;
        self.password.text = result.password;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:result.phone forKey:@"login_id"];
        [param setObject:result.password forKey:@"login_pwd"];
        [SVProgressHUD showWithStatus:kMessageUserAutoLogin];   // 自动登陆
        [self userLoginWithparams:param];
    }
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    if (!self.phone.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (!self.password.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.phone.text forKey:@"login_id"];
    [param setObject:self.password.text forKey:@"login_pwd"];
    [SVProgressHUD showWithStatus:kMessageUserLogin];
    [self userLoginWithparams:param];
}

- (void) userLoginWithparams:(NSDictionary *) params
{
    // 判断是否有网
    if (![BaseNetworkTool isConnectNetWork]) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"手机网络异常" message:@"您的网络出现一点问题，请检查网络，并重新刷新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新", nil]show];
        return;
    }
    [SkywareUserManager UserLoginWithParamesers:params Success:^(SkywareResult *result) {
        // 将用户信息保存到本地
        result.phone = self.phone.text;
        result.password = self.password.text;
        [NSKeyedArchiver archiveRootObject:result toFile:[PathTool getUserDataPath]];
        [SVProgressHUD dismiss];
        [UIWindow changeWindowRootViewController:[[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateInitialViewController] animated:NO];
    } failure:^(SkywareResult *result) {
        if ([result.message isEqualToString:@"404"]) {
            [SVProgressHUD showErrorWithStatus:kMessageUserNotRegister];
            return ;
        }
        //用户名密码或密码错误
        [SVProgressHUD showErrorWithStatus:kMessageUserNameOrPasswordError];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loginBtnClick:nil];
    }
}

@end
