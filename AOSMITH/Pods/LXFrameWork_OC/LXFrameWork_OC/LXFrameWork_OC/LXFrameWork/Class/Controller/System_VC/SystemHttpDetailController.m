//
//  SystemHttpDetailController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/10.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "SystemHttpDetailController.h"
#import "NSObject+JSONCategories.h"

@interface SystemHttpDetailController ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *request_url;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *request_time;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *request_status;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *request_params;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *request_result;


@end

@implementation SystemHttpDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.request_url.text = self.model.request_URL;
    self.request_time.text = self.model.request_time;
    if (self.model.isSuccess) {
        self.request_status.text = @"请求成功";
    }else{
        self.request_status.text = @"请求失败";
    }
    self.request_params.text = [self.model.request_dict JSONString];
    self.request_result.text = [self.model.result_dict JSONString];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
