//
//  BlockButton.h
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/7/8.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//


typedef void (^ClickButton)();

@interface BlockButton : UIButton

@property (nonatomic,copy) ClickButton ClickOption;

@end
