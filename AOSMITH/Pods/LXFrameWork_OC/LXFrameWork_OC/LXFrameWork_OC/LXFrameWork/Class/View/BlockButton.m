//
//  BlockButton.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/8.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnClick
{
    if (self.ClickOption) {
        self.ClickOption();
    }
}

@end
