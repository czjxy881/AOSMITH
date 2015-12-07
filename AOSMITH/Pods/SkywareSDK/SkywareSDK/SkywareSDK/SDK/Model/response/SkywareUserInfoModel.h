//
//  SkywareUserInfoModel.h
//  RoyalTeapot
//
//  Created by 李晓 on 15/8/3.
//  Copyright (c) 2015年 RoyalStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkywareUserInfoModel : NSObject

/***  用户登陆名 */
@property (nonatomic,copy) NSString *login_id;
/***  用户ID */
@property (nonatomic,copy) NSString *user_id;
/***  用户名称 */
@property (nonatomic,copy) NSString *user_name;
/***  用户头像 */
@property (nonatomic,copy) NSString *user_img;
/***  用户Email */
@property (nonatomic,copy) NSString *user_email;
/***  用户手机 */
@property (nonatomic,copy) NSString *user_phone;
/***  app_id */
@property (nonatomic,copy) NSString *app_id;
/***  设备耗材信息（滤网过期时间，更换时间） */
@property (nonatomic,copy) NSString *user_prefer;

@end
