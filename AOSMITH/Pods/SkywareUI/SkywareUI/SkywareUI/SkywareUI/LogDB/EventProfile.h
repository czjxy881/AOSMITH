//
//  EventProfile.h
//  Pods
//
//  Created by ybyao07 on 16/2/18.
//
//

#import <Foundation/Foundation.h>
#import "EventCategory.h"

@interface EventProfile : NSObject

@property (nonatomic,strong) NSArray *events; /** 保存 EventCategory 对象的数组 **/
+(EventProfile *)shareEventProfile;


@end
