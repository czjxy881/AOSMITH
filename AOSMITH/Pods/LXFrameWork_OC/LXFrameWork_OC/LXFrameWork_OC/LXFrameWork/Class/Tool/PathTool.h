//
//  PathTool.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/24.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Extension.h"

typedef enum {
    kUser_Path_file,
    kUser_path_folder
}Path_Type;

@interface PathTool : NSObject

/**
 *  获取用户基本信息保存路径
 *
 *  @return 路径
 */
+ (NSString *) getUserDataPath;

/**
 *  检查是否存在此路径
 *
 *  @param path     路径 path
 *  @param isCreate 没有该路径是否创建该路径
 *
 *  @return 是否存在路径
 */
+ (BOOL) haveFolderPath:(NSString *) path Create:(BOOL) isCreate;

/**
 *  检测文件是否存在
 *
 *  @param path     路径path
 *  @param isCreate 没有该文件就创建该文件
 *
 *  @return 是否存在文件
 */
+ (BOOL) haveFilePath:(NSString *) path Create:(BOOL) isCreate;



@end
