//
//  BundleTool.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/10.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "BundleTool.h"

#define BUNDLE_PATH(name) [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: (name)]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
#define SYSTEM_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation BundleTool


+ (UIImage *)getImage:(NSString *)img FromBundle:(NSString *)bundle
{
    NSMutableString *imgName = [NSMutableString stringWithString:img];
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        [imgName appendString:@".png"];
    }
    UIImage *image=[UIImage imageWithContentsOfFile:[BUNDLE_PATH(bundle) stringByAppendingPathComponent : imgName]];
    return image;
}

+ (id)getViewControllerNibName:(NSString *)name FromBundle:(NSString *)bundle
{
    Class vc = NSClassFromString(name);
    return [[vc alloc] initWithNibName:name bundle:[NSBundle bundleWithPath: BUNDLE_PATH(bundle)]];
}

+ (NSData *)getFileDataWithName:(NSString *)name FromBundle:(NSString *)bundle
{
    return [NSData dataWithContentsOfFile:[BUNDLE_PATH(bundle) stringByAppendingPathComponent :name]];
}

+ (NSArray *)getArrayWithName:(NSString *)name FromBundle:(NSString *)bundle
{
  return [NSArray arrayWithContentsOfFile:[BUNDLE_PATH(bundle) stringByAppendingPathComponent :name]];
}

@end
