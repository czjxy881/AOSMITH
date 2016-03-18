//
//  SystemExceptionDebugCell.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 16/2/19.
//  Copyright © 2016年 LXFrameWork. All rights reserved.
//

#import "SystemExceptionDebugCell.h"
#import "NSDate+Extension.h"
#import "BundleTool.h"

#define MYBUNDLE_NAME @ "LXFrameWork.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface SystemExceptionDebugCell()
@property (weak, nonatomic) IBOutlet UILabel *exception_name;
@property (weak, nonatomic) IBOutlet UILabel *exception_time;
@property (weak, nonatomic) IBOutlet UIImageView *disposeImage;

@end

@implementation SystemExceptionDebugCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SystemExceptionDebugCellID";
    SystemExceptionDebugCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYBUNDLE loadNibNamed:@"SystemExceptionDebugCell" owner:nil options:nil]lastObject];
        //        cell = [[[NSBundle mainBundle] loadNibNamed:@"SystemExceptionDebugCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

- (void)setModel:(SystemExceptionDebugModel *)model
{
    _model = model;
    self.exception_name.text = [model.exception name];
    self.exception_time.text = [model.exception_time FormatterYMDHMS];
    if (model.isDispose) {
        self.disposeImage.image = [BundleTool getImage:@"exception_success" FromBundle:LXFrameWorkBundle];
    }else{
        self.disposeImage.image = [BundleTool getImage:@"exception_fail" FromBundle:LXFrameWorkBundle];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

@end
