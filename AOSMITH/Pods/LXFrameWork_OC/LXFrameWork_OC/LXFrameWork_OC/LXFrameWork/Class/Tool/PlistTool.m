//
//  PlistTool.m
//  LiXiao
//
//  Created by 李晓 on 15/7/2.
//  Copyright (c) 2015年 BookStore. All rights reserved.
//

#import "PlistTool.h"

@implementation PlistTool

+ (NSArray *)loadPlistWithName:(NSString *) name AndType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type ? type :@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

+ (NSArray *) loadTabBarCenterViewWithName:(NSString *) name
{
    return [self loadPlistWithName:name AndType:nil];
}

@end
