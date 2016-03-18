//
//  SharePhoneViewController.m
//  Pods
//
//  Created by ybyao07 on 16/2/25.
//
//

#import "SharePhoneViewController.h"
#import "SkywareUIManager.h"
#import "NSString+RegularExpression.h"
@interface SharePhoneViewController ()<UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *btnSure;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *tfPhoneNumber;

@end

@implementation SharePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"共享设备"];

    // 设置页面元素
    SkywareUIManager *UIM = [SkywareUIManager sharedSkywareUIManager];
    [_btnSure setBackgroundColor:UIM.User_button_bgColor == nil? UIM.All_button_bgColor : UIM.User_button_bgColor];
}



-(void)NavBackBtnClick
{
    if (_isFromBindViewDevice) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)shareDeviceByPhone:(UIButton *)sender {
    //检查手机号是否符合要求
    if (!_tfPhoneNumber.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([_tfPhoneNumber.text isPhoneNumber]) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"您要分享的用户是\n\"%@\"",_tfPhoneNumber.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [view show];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请输入正确手机号"];
    }
}


#pragma mark UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
         // 调用 绑定接口
        
        [self NavBackBtnClick];
    }
}

@end
