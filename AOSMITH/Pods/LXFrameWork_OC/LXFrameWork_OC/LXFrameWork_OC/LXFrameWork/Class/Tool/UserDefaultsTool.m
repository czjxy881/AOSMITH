//
//  UserDefaultsTool.m
//  HangingFurnace
//
//  Created by 李晓 on 15/9/11.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import "UserDefaultsTool.h"

@implementation UserDefaultsTool

+ (void) setUserDefaultsWith:(id) obj forKey:(NSString *) key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

+ (id) getUserDefaultsForKey:(NSString *) key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

@end
