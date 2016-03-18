//
//  UserAccountViewController.m
//  WebIntegration
//
//  Created by 李晓 on 15/8/19.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserAccountViewController.h"

@interface UserAccountViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation UserAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"账号管理"];
    [self addAccountData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editUserNickName:) name:kEditUserNickNameRefreshTableView object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)editUserNickName:(NSNotification *) notification
{
    NSString *userName = notification.userInfo[@"user_name"];
    if (!userName.length) return;
    self.user_name = userName;
    [self addAccountData];
}

- (void) actionSheetView
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"从相册选取" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
    [sheet showInView: self.view.window];
}

- (void) addAccountData
{
    BaseIconItem *iconItem ;
    NSString *imgurl = self.user_img.length == 0 ? @"view_userface" :self.user_img;
    NSString *name = self.user_name.length == 0? @"匿名" :self.user_name;
    NSString *phone = self.user_phone.length == 0?@"":self.user_phone;
    iconItem = [BaseIconItem createBaseCellItemWithIconNameOrUrl:imgurl AndTitle:name SubTitle:phone
                                                 ClickCellOption:nil ClickIconOption:^{
                                                     UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否从相册选取" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"从相册选取", nil];
                                                     [sheet showInView: self.view.window];
                                                 }];
    
    BaseCellItemGroup *group1 = [BaseCellItemGroup createGroupWithHeadView:iconItem.sectionView AndFootView:iconItem.sectionView OrItem:@[iconItem]];
    
    BaseArrowCellItem *nickName = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"修改昵称" SubTitle:nil ClickOption:^{
        UserEditNickNameViewController *editName = [[UserEditNickNameViewController alloc] initWithNibName:@"UserEditNickNameViewController" bundle:nil];
        [self.navigationController pushViewController:editName animated:YES];
    }];
    BaseArrowCellItem *password = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"修改密码" SubTitle:nil ClickOption:^{
        UserEditPasswordViewController *password = [[UserEditPasswordViewController alloc] initWithNibName:@"UserEditPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:password animated:YES];
    }];
    BaseArrowCellItem *cancle = [BaseArrowCellItem createBaseCellItemWithIcon:nil AndTitle:@"注销" SubTitle:nil ClickOption:^{
        [[[UIAlertView alloc] initWithTitle:@"您确定要注销吗？" message:@"注销后会跳转到登录页面" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }];
    BaseCellItemGroup *group2 = [BaseCellItemGroup createGroupWithItem:@[nickName,password,cancle]];
    
    [self.dataList removeAllObjects];
    [self.dataList addObject:group1];
    [self.dataList addObject:group2];
    [self.tableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
    
    switch (buttonIndex) {
        case 0:
            pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
            
        case 1:
            pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        case 2:
            return;
            break;
    }
    
    pickController.delegate = self;
    
    [self presentViewController:pickController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self uploadUserIconWithImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) uploadUserIconWithImage:(UIImage *) img
{
    [SVProgressHUD show];
    [SkywareUserManager UserUploadIconWithParamesers:nil Icon:[img scaleToSize:CGSizeMake(100, 100)] FileName:@"file.png" Success:^(SkywareResult *result) {
        self.user_img = result.icon_url;
        [self addAccountData];
        [self updateuserPhotoWithUrl:result.icon_url];
        [SVProgressHUD showSuccessWithStatus:@"上传头像成功"];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
    }];
}


- (void) updateuserPhotoWithUrl:(NSString *) url
{
    [SVProgressHUD show];
    [SkywareUserManager UserEditUserWithParamesers:@{@"user_img":url} Success:^(SkywareResult *result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kEditUserNickNameRefreshTableView object:nil];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 清除保存的用户名密码
        [NSKeyedArchiver archiveRootObject:[[SkywareResult alloc] init] toFile:[PathTool getUserDataPath]];
        // 清除用户detoken
        SkywareSDKManager *manager = [SkywareSDKManager sharedSkywareSDKManager];
        manager.token = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 调回到登陆界面
            UserLoginViewController *loginRegister = [[UIStoryboard storyboardWithName:@"User" bundle:nil] instantiateInitialViewController];
            [UIWindow changeWindowRootViewController:loginRegister animated:YES];
            
        });
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 0;
}



@end
