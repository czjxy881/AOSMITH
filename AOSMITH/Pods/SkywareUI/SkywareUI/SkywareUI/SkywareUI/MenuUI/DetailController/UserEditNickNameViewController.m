//
//  UserEditNickNameViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserEditNickNameViewController.h"

@interface UserEditNickNameViewController ()
/*** 用户昵称 */
@property (weak, nonatomic) IBOutlet UITextField *user_nickName;
/*** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end

@implementation UserEditNickNameViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
        self.view.backgroundColor = UIM.Menu_view_bgColor == nil?UIM.All_view_bgColor : UIM.Menu_view_bgColor;
        [self.finishBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"账号管理"];
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    
    if (!self.user_nickName.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入新昵称"];
        return;
    }
    [SVProgressHUD show];
    [SkywareUserManager UserEditUserWithParamesers:@{@"user_name":self.user_nickName.text} Success:^(SkywareResult *result) {
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kEditUserNickNameRefreshTableView object:nil userInfo:@{@"user_name":self.user_nickName.text}];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"修改失败,请稍后重试"];
    }];
    
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITextInputMode *currentInputMode = textField.textInputMode;
    if ([currentInputMode.primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

@end
