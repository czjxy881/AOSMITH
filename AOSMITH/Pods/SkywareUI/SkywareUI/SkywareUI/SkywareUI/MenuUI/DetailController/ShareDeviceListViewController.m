//
//  ShareDeviceListViewController.m
//  Pods
//
//  Created by ybyao07 on 16/1/21.
//
//

#import "ShareDeviceListViewController.h"
#import "SkywareDeviceManager.h"
#import "SkywareUserDeviceBind.h"
#import "ShareBindDeviceTableCell.h"
#import <UIColor+Extension.h>
#import <MJExtension.h>
@interface ShareDeviceListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSIndexPath *_currentIndexPath;
}
@end

@implementation ShareDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"分享管理"];
    //调用接口获取分享设备列表
    [self downloadDatalist];
    self.tableView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
}

-(void)downloadDatalist
{
    //测试代码
//    SkywareUserDeviceBind *test = [[SkywareUserDeviceBind alloc] init];
//    test.login_id = @"1111111111";
//    test.user_id = @"222222222";
//    
//    SkywareUserDeviceBind *test2 = [[SkywareUserDeviceBind alloc] init];
//    test2.login_id = @"2222222";
//    test2.user_id = @"222222222";
//    
//    [self.dataList addObject:test];
//    [self.dataList addObject:test2];
//    [self.dataList addObject:test];
//    [self.tableView reloadData];
    /* 传入deviceId
     /* "result": [{
     "user_id": "1",
     "login_id": "18600364250",
     "user_name": "huawei"
     }],*/

    [SVProgressHUD showWithStatus:@"加载中..."];
    [SkywareDeviceManager DeviceGetShareListNew:[NSArray arrayWithObject:_currentDeviceId] Success:^(SkywareResult *result) {
        if ([result.message intValue] == 200) {
            [self.dataList removeAllObjects];
            self.dataList = [SkywareUserDeviceBind mj_objectArrayWithKeyValuesArray:result.result];
            [self.tableView reloadData];
        }
        [SVProgressHUD dismiss];
    } failure:^(SkywareResult *result) {
        [SVProgressHUD dismiss];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor lightGrayColor];
    lblTitle.font = [UIFont systemFontOfSize:14];
    lblTitle.frame = CGRectMake(0, 0, kWindowWidth, 40);
    lblTitle.text = [NSString stringWithFormat:@"有%d人绑定",self.dataList.count];
    return lblTitle;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"ShareBindDeviceTableCell";
    ShareBindDeviceTableCell *unBindcell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (unBindcell==nil) {
        unBindcell = [[ShareBindDeviceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    SkywareUserDeviceBind *mode = self.dataList[indexPath.row];
    unBindcell.lblPhone.text =[NSString stringWithFormat:@"用户%@",mode.login_id]
    ;
    unBindcell.unBindBlock = ^{
        //调用分享解绑接口
        _currentIndexPath = indexPath;
        [[[UIAlertView alloc] initWithTitle:@"您确定要删除该用户么?" message:@"删除后被分享者将无法查看该设备" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    };
    return unBindcell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [SVProgressHUD show];
        SkywareUserDeviceBind *mode = self.dataList[_currentIndexPath.row];
        [SkywareDeviceManager DeviceReleaseShareUser:@{@"deviceid":_currentDeviceId,@"shareid":mode.user_id} Success:^(SkywareResult *result) {
            if ([result.message intValue] == 200) {
                [self.dataList removeObjectAtIndex:_currentIndexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[_currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView beginUpdates];
                [self.tableView reloadData];
                [self.tableView endUpdates];
            }
            [SVProgressHUD dismiss];
        } failure:^(SkywareResult *result) {
            [SVProgressHUD showErrorWithStatus:@"解绑失败"];
        }];

    }
}

@end
