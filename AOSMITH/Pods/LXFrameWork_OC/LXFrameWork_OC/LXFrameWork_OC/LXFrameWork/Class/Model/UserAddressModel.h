//
//  UserAddressModel.h
//  WebIntegration
//
//  Created by 李晓 on 15/8/27.
//  Copyright (c) 2015年 skyware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAddressModel : NSObject

@property (nonatomic,copy) NSString *SubLocality;
@property (nonatomic,copy) NSString *CountryCode;
@property (nonatomic,copy) NSString *Street;
@property (nonatomic,copy) NSString *State;
@property (nonatomic,copy) NSString *Name;
@property (nonatomic,copy) NSString *Thoroughfare;
@property (nonatomic,copy) NSString *Country;
@property (nonatomic,copy) NSString *City;

//@property (nonatomic,copy) id FormattedAddressLines;

@end
