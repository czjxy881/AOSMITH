//
//  UserGetCodeView.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/20.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "StepNextView.h"
#import "SkywareUIManager.h"

@interface UserGetCodeView : StepNextView

/***  所填手机号  */
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
/***  获取验证码按钮  */
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

/**
 *  加载 UserCodeView
 */
+ (instancetype) getUserCodeView;

@end
