//
//  SkywareUserDeviceBind.h
//  Pods
//
//  Created by ybyao07 on 16/1/21.
//
//

#import <Foundation/Foundation.h>

@interface SkywareUserDeviceBind : NSObject

/***  用户登陆名 */
@property (nonatomic,copy) NSString *login_id;
/***  用户ID */
@property (nonatomic,copy) NSString *user_id;
/***  用户名称 */
@property (nonatomic,copy) NSString *user_name;


@end
