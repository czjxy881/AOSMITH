//
//  UserEditPasswordViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserEditPasswordViewController.h"

@interface UserEditPasswordViewController ()

/*** 旧密码 */
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
/*** 新密码 */
@property (weak, nonatomic) IBOutlet UITextField *Password;
/*** 确认密码 */
@property (weak, nonatomic) IBOutlet UITextField *againPassword;
/*** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation UserEditPasswordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
        self.view.backgroundColor = UIM.Menu_view_bgColor == nil?UIM.All_view_bgColor : UIM.Menu_view_bgColor;
        [self.finishBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"修改密码"];
}


- (IBAction)submit:(UIButton *)sender {
    if (!self.oldPassword.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入旧密码"];
        return;
    }
    if (!self.Password.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if (self.Password.text.length < 6 || self.Password.text.length > 16) {
        [SVProgressHUD showErrorWithStatus:@"新密码格式错误"];
        return;
    }
    if (![self.Password.text isEqualToString:self.againPassword.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.Password.text forKey:@"login_pwd"];
    [params setObject:self.oldPassword.text forKey:@"login_pwd_old"];
    [SVProgressHUD show];
    [SkywareUserManager UserEditUserPasswordWithParamesers:params Success:^(SkywareResult *result) {
        
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 清除保存的用户名密码
            [NSKeyedArchiver archiveRootObject:[[SkywareResult alloc] init] toFile:[PathTool getUserDataPath]];
            // 清除用户detoken
            SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
            manager.token = nil;
            // 调回到登陆界面
            UserLoginViewController *loginRegister = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
            [UIWindow changeWindowRootViewController:loginRegister animated:YES];
        });
        
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"密码修改失败"];
    }];
    
}


@end
