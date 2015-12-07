//
//  selectDataPickView.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/10.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "selectDataPickView.h"

@implementation selectDataPickView

+ (instancetype) createSelectDatePickView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"selectDataPickView" owner:nil options:nil]lastObject];
}

- (IBAction)cleanBtnClick:(UIButton *)sender {
    [self cleanMethod];
}

- (IBAction)centerBtnClick:(UIButton *)sender {
    
    NSInteger componentCount = self.pickView.numberOfComponents;
    NSString *selectDate = nil;
    if (componentCount == 2) {
        NSInteger com0 = [self.pickView selectedRowInComponent:0];
        NSInteger com1 = [self.pickView selectedRowInComponent:1];
        NSString *comStr0 = [NSString stringWithFormat:@"%.2ld",com0];
        NSString *comStr1 = [NSString stringWithFormat:@"%.2ld",com1];
        selectDate = [NSString stringWithFormat:@"%@:%@",comStr0,comStr1];
    }else if(componentCount ==1){ // 等于1 说明选择的是温度，就一列
        NSInteger com0 = [self.pickView selectedRowInComponent:0];
        UILabel *select = (UILabel *)[self.pickView viewForRow:com0 forComponent:0];
        selectDate = select.attributedText.string;
    }
    
    [kNotificationCenter postNotificationName:kSelectCustomDatePickNotification object:nil userInfo:@{@"selectPick":selectDate}];
    [self cleanMethod];
}

- (void) cleanMethod
{
    [UIView animateWithDuration:0.4f animations:^{
        self.y = kWindowHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.cleanClick) {
            self.cleanClick();
        }
    }];
}

@end
