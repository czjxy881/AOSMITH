//
//  SelectWeekView.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/9.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "SelectWeekView.h"

@interface SelectWeekView ()

@property (nonatomic,strong) NSMutableArray *selectWeek;
// 周一至周日的汉字
@property (nonatomic,strong) NSArray *dateWeekString;
// 周一至周日的数字
@property (nonatomic,strong) NSArray *dataWeekNumber;

@end

@implementation SelectWeekView

- (IBAction)CleanBtnClick:(UIButton *)sender {
    [self cleanMethod];
}

- (IBAction)CenterBtnClick:(UIButton *)sender {
    [kNotificationCenter postNotificationName:kSelectCustomWeekDateNotification object:nil userInfo:@{@"selectWeekStr":[self centerMethod],@"selectedNumber":[self getSelectedWeekNumber]}];
   [self cleanMethod];
}

- (IBAction)selectWeek:(UIButton *)sender {
    [sender.superview.subviews enumerateObjectsUsingBlock:^(UIView *sub, NSUInteger idx, BOOL *stop) {
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *) sub;
            if (btn.tag) {
                btn.selected = !btn.selected;
            }
        }
    }];
}

+ (instancetype) createSelectWeekView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SelectWeekView" owner:nil options:nil]lastObject];
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

-(NSArray *)getSelectedWeekNumber
{
    NSArray *weekNumbers = [self selectNumberWithSelectWeek:_selectWeek];
    return weekNumbers;
}

- (NSString *) centerMethod
{
    NSArray *selectWeek = [self recurrenceViewWithView:self];
    NSString *weekStr = [self selectStrWithSelectWeek:selectWeek];
    return weekStr;
}

- (NSArray *) recurrenceViewWithView:(UIView *) view
{
    [view.subviews enumerateObjectsUsingBlock:^(UIView *sub, NSUInteger idx, BOOL *stop) {
        if (sub.subviews.count) {
            [self recurrenceViewWithView:sub];
        }
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn.selected) {
                [self.selectWeek addObject:@(btn.tag)];
            }
        }
    }];
    return self.selectWeek;
}

- (NSString *)selectStrWithSelectWeek:(NSArray *) selectWeek
{
//    if (selectWeek.count == 7) {
//        return @"每天";
//    }
    NSMutableString *subStr = [NSMutableString string];
    [selectWeek enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger tag = [obj integerValue];
        [subStr appendFormat:@"%@、",[self.dateWeekString objectAtIndex:tag]];
    }];
    if (subStr &&subStr.length) {
        return [subStr substringToIndex:subStr.length -1];
    }
    return @"永不";
}


- (NSArray *)selectNumberWithSelectWeek:(NSArray *) selectWeek
{
    NSMutableArray *numberArray = [NSMutableArray new];
    [selectWeek enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger tag = [obj integerValue];
        [numberArray addObject:[self.dataWeekNumber objectAtIndex:tag]];
    }];
    return numberArray;
}




- (void)setDefineStr:(NSString *)defineStr
{
    _defineStr = defineStr;
    NSArray *selectWeek = [defineStr componentsSeparatedByString:@"、"];
    [selectWeek enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        NSUInteger index = [self.dateWeekString indexOfObject:str];
        [self selectBtnWithTag:index inView:self];
    }];
}

- (void) selectBtnWithTag:(NSInteger) tag inView:(UIView *) view
{
    [view.subviews enumerateObjectsUsingBlock:^(UIView *sub, NSUInteger idx, BOOL *stop) {
        if (sub.subviews.count) {
            [self selectBtnWithTag:tag inView:sub];
        }
        if ([sub isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sub;
            if (btn.tag == tag) {
                btn.selected = YES;
            }
        }
    }];
    
}

#pragma mark - 懒加载

- (NSMutableArray *)selectWeek
{
    if (!_selectWeek) {
        _selectWeek = [[NSMutableArray alloc] init];
    }
    return _selectWeek;
}


- (NSArray *)dateWeekString
{
    if (!_dateWeekString) {
        _dateWeekString = @[@"",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    }
    return _dateWeekString;
}

- (NSArray *)dataWeekNumber
{
    if (!_dataWeekNumber) {
        _dataWeekNumber = @[@"",@(1),@(2),@(3),@(4),@(5),@(6),@(0)];
    }
    return _dataWeekNumber;
}

@end
