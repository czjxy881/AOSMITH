//
//  UserCheckCodeView.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserCheckCodeView.h"
#import "MessageCodeTool.h"
#import "TimeButton.h"

@interface UserCheckCodeView ()

/*** 验证码发送到手机提示 */
@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;
/*** 输入验证码 */
@property (weak, nonatomic) IBOutlet UITextField *authCode;
/*** 重新获取按钮 */
@property (weak, nonatomic) IBOutlet TimeButton *againBtn;
/*** 完成按钮 */
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation UserCheckCodeView

- (void)awakeFromNib
{
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    self.againBtn.defineColor = UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor;
    [self.againBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    [self.checkBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    self.backgroundColor = UIM.User_view_bgColor == nil? UIM.All_view_bgColor :UIM.User_view_bgColor;
}

+ (instancetype)getUserCheckCodeView
{
    return [[NSBundle mainBundle]loadNibNamed:@"UserManager" owner:nil options:nil][1];
}

- (void)setParams:(NSDictionary *)params
{
    [super setParams:params];
    [self.againBtn startWithTimer:60];
    self.phoneTitle.text = [NSString stringWithFormat:kMessageUserGetCodeSuccess,self.params[@"phone"]];
}


- (IBAction)againBtnClick:(UIButton *)sender {
    [self.againBtn startWithTimer:60];
    [SVProgressHUD showWithStatus:kMessageUserGetCodeLoad];
    [MessageCodeTool getMessageCodeWithPhone:self.params[@"phone"] Zone:nil Success:^{
        [SVProgressHUD dismiss];
    } Error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:kMessageUserGetCodeError];
    }];
}

- (IBAction)CheckCodeBtnClick:(UIButton *)sender {
    
    [self endEditing:YES];
    
    if(self.authCode.text.length!=4)
    {
        [SVProgressHUD showInfoWithStatus:kMessageUserWriteCode];
        return;
    }else{
        [MessageCodeTool commitVerifyCode:self.authCode.text Phone:self.params[@"phone"] Zone:nil Success:^{
            if (self.option) {
                self.option();
            }
        } Error:^{
            [SVProgressHUD showErrorWithStatus:kMessageUserWriteCodeError];
        }];
    }
}


@end
