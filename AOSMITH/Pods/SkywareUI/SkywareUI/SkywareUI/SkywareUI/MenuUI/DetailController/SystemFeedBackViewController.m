//
//  SystemFeedBackViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "SystemFeedBackViewController.h"

@interface SystemFeedBackViewController ()
/***  反馈标题 */
@property (weak, nonatomic) IBOutlet UITextField *titleView;
/***  反馈内容 */
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
/***  提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation SystemFeedBackViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        SkywareUIInstance *UIM = [SkywareUIInstance sharedSkywareUIInstance];
        self.view.backgroundColor = UIM.Menu_view_bgColor == nil?UIM.All_view_bgColor : UIM.Menu_view_bgColor;
        [self.commitBtn setBackgroundColor:UIM.User_button_bgColor == nil ? UIM.All_button_bgColor :UIM.User_button_bgColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"意见反馈"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.titleView becomeFirstResponder];
}

- (IBAction)commitBtnClick:(UIButton *)sender {
    if (!self.titleView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    if (!self.contentTextView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入反馈内容"];
        return;
    }
    SkywareUserFeedBackModel *feedBack = [[SkywareUserFeedBackModel alloc] init];
    feedBack.title = self.titleView.text;
    feedBack.content = self.contentTextView.text;
    [SVProgressHUD show];
    [SkywareUserManager UserFeedBackWithParamesers:feedBack Success:^(SkywareResult *result) {
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"感谢您的反馈，我们会尽快处理"];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"亲，您的反馈我们没收到，再试一下"];
    }];
    
}

@end
