//
//  EventProfile.m
//  Pods
//
//  Created by ybyao07 on 16/2/18.
//
//

#import "EventProfile.h"
#import <MJExtension.h>

//static NSArray *events;

@implementation EventProfile

+(EventProfile *)shareEventProfile
{
    static EventProfile *eventProfile = nil;
    static dispatch_once_t onceToken;
    //一次只允许一个线程访问
    dispatch_once(&onceToken, ^{
        if(eventProfile==nil){
            eventProfile =  [[self alloc] init];
            eventProfile.events = [self eventArray];
        }
    });
    return eventProfile;
}
+ (NSArray *)eventArray{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"EventLog.bundle/events.plist"];
    NSArray *data =[NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *events= [NSMutableArray new];
    [data enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        EventCategory *eventModel = [EventCategory mj_objectWithKeyValues:dic];
        [events addObject:eventModel];
    }];
   return  events;
}










@end
