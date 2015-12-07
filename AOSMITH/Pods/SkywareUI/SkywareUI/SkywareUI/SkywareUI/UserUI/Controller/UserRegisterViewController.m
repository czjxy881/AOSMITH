//
//  UserRegisterViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "UserGetCodeView.h"
#import "UserCheckCodeView.h"
#import "UserSettingPasswordView.h"
#import <StepView.h>
@interface UserRegisterViewController ()
{
    NSString *_phone;
}
@property (nonatomic,strong) NSMutableArray *dataList;

@end

/**
 *  快速注册
 */
@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"快速注册"];
    [self.dataList addObject:@"输入手机号"];
    [self.dataList addObject:@"输入验证码"];
    [self.dataList addObject:@"设置密码"];
    
    [self reloadData];
}

- (NSArray *) titleArrayAtHeadView:(UIView *)StepView
{
    return self.dataList;
}

- (UIView *)viewForRowAtFootView:(UIView *)StepView Count:(NSInteger)number
{
    if (number == 1) {
        UserGetCodeView *authCodeView = [UserGetCodeView getUserCodeView];
        authCodeView.option = ^{
            _phone =  authCodeView.phoneText.text;
            [self nextPage];
        };
        return authCodeView;
    }else if (number == 2){
        UserCheckCodeView *inputCodeView = [UserCheckCodeView getUserCheckCodeView];
        inputCodeView.params = @{@"phone":_phone};
        inputCodeView.option = ^{
            [self nextPage];
        };
        return inputCodeView;
    }else if (number == 3){
        UserSettingPasswordView *settingPassword = [UserSettingPasswordView getUserSettingPasswordView];
        settingPassword.params = @{@"phone":_phone};
        return settingPassword;
    }
    return nil;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
