//
//  SelectCityViewController.h
//  SkywareUI
//
//  Created by 李晓 on 15/12/11.
//  Copyright © 2015年 skyware. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void (^cityCellClick)(NSString *);

@interface SelectCityViewController : BaseTableViewController

@property (nonatomic,copy) cityCellClick cellClick;

@property (nonatomic,assign,getter = isNeedCity) BOOL needCity;

@end
