//
//  PathTool.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/24.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "PathTool.h"

@implementation PathTool

+ (NSString *)getUserDataPath
{
    return [[NSString getApplicationDocumentsDirectory] stringByAppendingPathComponent:@"User.data"];
}


+ (BOOL)haveFolderPath:(NSString *)path Create:(BOOL)isCreate
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir)){
        if (isCreate) {
            BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            if(!bCreateDir){
                NSLog(@"创建%@路径失败",path);
            }
        }
        return NO;
    }
    return YES;
}


+ (BOOL)haveFilePath:(NSString *)path Create:(BOOL)isCreate
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        if (isCreate) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        return NO;
    }
    return YES;
}

@end
