//
//  SystemExceptionDetailController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 16/2/19.
//  Copyright © 2016年 LXFrameWork. All rights reserved.
//

#import "SystemExceptionDetailController.h"
#import "NSDate+Extension.h"
#import "BundleTool.h"

@interface SystemExceptionDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *exception_name;
@property (weak, nonatomic) IBOutlet UILabel *exception_time;
@property (weak, nonatomic) IBOutlet UILabel *exception_dispose;
@property (weak, nonatomic) IBOutlet UILabel *exception_reason;
@property (weak, nonatomic) IBOutlet UITextView *exception_info;
@property (weak, nonatomic) IBOutlet UIButton *workedBtn;

@end

@implementation SystemExceptionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.workedBtn.layer.cornerRadius = 5;
    self.workedBtn.clipsToBounds= YES;
    [self setNavTitle:@"异常明细"];
    
    [self updateWithModel:self.model];
}

- (IBAction)workedBtnClick:(UIButton *)sender {
    [SystemExceptionDebugModel updateExceptionStatusWithExceptionId:self.model.exception_id];
    self.model = [SystemExceptionDebugModel getSystemExceptionDebugModelWithExceptionId:self.model.exception_id];
    [self updateWithModel:self.model];
}

- (void) updateWithModel:(SystemExceptionDebugModel *)model
{
    NSString *name = [self.model.exception name];
    NSString *reason = [self.model.exception reason];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nName:\t[%@]\nReason:\t[%@]\nCallStackSymbols:\n[%@]",name,reason,[self.model.exception_callStack componentsJoinedByString:@"\n"]];
    
    self.exception_name.text = name;
    self.exception_time.text = [self.model.exception_time FormatterYMDHMS];
    if (self.model.isDispose) {
        self.exception_dispose.textColor = [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1];
        self.exception_dispose.text = @"已处理";
        self.workedBtn.hidden = YES;
        [self setRightView:[UIView new]];
    }else{
        self.exception_dispose.textColor = [UIColor redColor];
        self.exception_dispose.text = @"未处理";
        self.workedBtn.hidden = NO;
        [self setUpNavRightView];
    }
    self.exception_reason.text = reason;
    self.exception_info.text = content;
}

- (void) setUpNavRightView
{
    __weak typeof(self) weakSelf = self;
    [self setRightBtnWithImage:[BundleTool getImage:@"share_send" FromBundle:LXFrameWorkBundle] orTitle:nil ClickOption:^{
        LXFrameWorkManager *manager = [LXFrameWorkManager sharedLXFrameWorkManager];
        if (!manager.exceptionEmailAddress.length) {
            [SVProgressHUD showInfoWithStatus:@"请先添加异常信息收件人(LXFrameWorkManager)"];
            return;
        }
        NSMutableString *mailUrl = [NSMutableString string];
        // 添加收件人
        [mailUrl appendFormat:@"mailto:%@",manager.exceptionEmailAddress];
        // 添加抄送
        //        [mailUrl appendFormat:@"?cc=%@", [array componentsJoinedByString:@","]];
        [mailUrl appendString:@"?subject=程序异常崩溃，请配合异常报告修改，谢谢合作！"];
        [mailUrl appendFormat:@"&body=%@", weakSelf.exception_info.text];
        NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
    }];
}

@end
