//
//  SkywareMQTTTool.m
//  RoyalTeapot
//
//  Created by 李晓 on 15/7/22.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import "SkywareMQTTTool.h"

@implementation SkywareMQTTTool

+ (SkywareMQTTModel *)conversionMQTTResultWithData:(NSData *) data
{
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    SkywareMQTTModel *model = [SkywareMQTTModel mj_objectWithKeyValues:dataDict];
    if (model.data.count) { // 手动添加，如果data.cout 有值，说明设备在线
        model.device_online = 1;
    }else{
        model.device_online = 0;
    }
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    [model.data enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        NSArray *separated = [str componentsSeparatedByString:@"::"];
        [codeDict setObject:separated[1] forKey:separated[0]];
    }];
    model.dataDictionary = codeDict;
    return model;
}

+ (NSDictionary *)getMQTTStatusDataWithData:(NSData *) data
{
    SkywareMQTTModel *model = [SkywareMQTTTool conversionMQTTResultWithData:data];
    return model.dataDictionary;
}

@end
