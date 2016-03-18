//
//  SystemHttpDetailController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/10.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "SystemHttpDetailController.h"
#import "NSObject+JSONCategories.h"
#import <CoreData/CoreData.h>

@interface SystemHttpDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *request_url;
@property (weak, nonatomic) IBOutlet UILabel *request_time;
@property (weak, nonatomic) IBOutlet UILabel *request_status;
@property (weak, nonatomic) IBOutlet UILabel *request_params;
@property (weak, nonatomic) IBOutlet UITextView *request_result;
@property (weak, nonatomic) IBOutlet UILabel *request_head;

@end

@implementation SystemHttpDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"请求明细"];
    
    self.request_url.text = self.model.request_URL;
    self.request_time.text = self.model.request_time;
    if (self.model.isSuccess) {
        self.request_status.textColor = [UIColor colorWithRed:0 green:0.8 blue:0 alpha:1];
        self.request_status.text = @"请求成功";
    }else{
        self.request_status.textColor = [UIColor redColor];
        self.request_status.text = @"请求失败";
    }
    self.request_head.text = [self.model.request_heard_data JSONString];
    self.request_params.text = [self.model.request_data JSONString];
    if (self.model.isSuccess) {
        self.request_result.text = [[self.model.result_data JSONString] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }else{
        NSMutableString *string = [NSMutableString string];
        [string appendFormat:@"错误标示:\t[%ld];\n",[self.model.error_data code]];
        [string appendFormat:@"错误域: \t[%@];\n",[self.model.error_data domain]];
        [string appendFormat:@"详细描述:\t[%@];\n",[self.model.error_data localizedDescription]];
        NSHTTPURLResponse *respone = [self.model.error_data.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"];
        if (respone) {
            [string appendFormat:@"请求状态码:\t[%ld];\n",respone.statusCode];
            [string appendFormat:@"请求服务器信息:\t[%@];\n",[respone.allHeaderFields JSONString]];
        }
        
        self.request_result.text = [string stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }
}

@end
