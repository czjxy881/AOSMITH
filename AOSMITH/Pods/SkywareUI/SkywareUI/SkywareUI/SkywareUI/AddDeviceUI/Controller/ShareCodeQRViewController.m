//
//  ShareCoceQRViewController.m
//  Pods
//
//  Created by ybyao07 on 16/1/20.
//
//

#import "ShareCodeQRViewController.h"
#import "CustomQRCodeTool.h"
@interface ShareCodeQRViewController ()

@end

@implementation ShareCodeQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"共享设备"];
    if (_codeStr) {
        self.QRCodeImg.image = [CustomQRCodeTool createQRCodeFromString:[self codeStrPlusDateTime:_codeStr] WithSize:260];
    }
}

-(void)NavBackBtnClick
{
    if (_isFromBindViewDevice) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSString *)codeStrPlusDateTime:(NSString *)initStr
{
    NSInteger time = [[NSDate new] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%@;%ld",initStr,time];
}

@end
